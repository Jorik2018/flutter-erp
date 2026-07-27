import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../Util/SharedPreferencesHelper.dart';
import '../models/models.dart';
import 'post_event.dart';
import 'post_state.dart';

EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
}

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc({required Dio dio}) : _dio = dio, super(PostUninitialized()) {
    on<Fetch>(
      _onFetch,
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }

  final Dio _dio;
  IO.Socket? _socket;

  Future<void> _onFetch(Fetch event, Emitter<PostState> emit) async {
    if (state is PostLoading || _hasReachedMax(state)) {
      return;
    }

    emit(PostLoading());

    try {
      final posts = await fetchCurrencies();
      await _connectSocket();

      emit(PostLoaded(posts: posts, hasReachedMax: true));
    } on DioException catch (error) {
      emit(PostError(message: _getDioErrorMessage(error)));
    } catch (error) {
      emit(PostError(message: error.toString()));
    }
  }

  bool _hasReachedMax(PostState state) {
    return state is PostLoaded && state.hasReachedMax;
  }

  Future<List<GetCoinsAdd>> fetchCurrencies() async {
    final currency = await SharedPreferencesHelper.getCurrency();

    final response = await _dio.get<dynamic>(
      'https://min-api.cryptocompare.com/data/top/mktcapfull',
      queryParameters: {'limit': 100, 'tsym': currency},
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Error al consultar CryptoCompare. '
        'Código HTTP: ${response.statusCode}',
      );
    }

    if (response.data is! Map) {
      throw Exception('Respuesta inválida del servidor.');
    }

    final responseBody = Map<String, dynamic>.from(response.data as Map);
    final responseData = responseBody['Data'];

    if (responseData is! List) {
      throw Exception(
        responseBody['Message']?.toString() ??
            'No se encontraron criptomonedas.',
      );
    }

    return responseData
        .whereType<Map>()
        .map((coin) => GetCoinsAdd.fromMap(Map<String, dynamic>.from(coin)))
        .toList();
  }

  Future<void> _connectSocket() async {
    if (_socket?.connected == true) {
      return;
    }

    final currency = await SharedPreferencesHelper.getCurrency();
    final coins = await SharedPreferencesHelper.getCoinList();

    final subscriptions = coins
        .map((coin) => '5~CCCAGG~${coin.toString()}~$currency')
        .toList();

    _disposeSocket();

    _socket = IO.io(
      'https://streamer.cryptocompare.com/',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    _socket!
      ..onConnect((_) {
        _socket?.emit('SubAdd', {'subs': subscriptions});
      })
      ..on('m', _handleSocketMessage)
      ..onConnectError((error) {
        print('Error al conectar el socket: $error');
      })
      ..onError((error) {
        print('Error del socket: $error');
      })
      ..onDisconnect((_) {
        print('Socket desconectado');
      })
      ..connect();
  }

  void _handleSocketMessage(dynamic data) {
    if (data is! String) {
      return;
    }

    final values = data.split('~');

    if (values.isEmpty) {
      return;
    }

    if (values[0] == '3' || values[0] == '401') {
      print('Mensaje de CryptoCompare: $values');
      return;
    }

    if (values.length <= 5 || values[0] != '5') {
      return;
    }

    final coin = values[2];
    final currency = values[3];
    final flag = values[4];
    final price = values[5];

    final indicator = switch (flag) {
      '1' => '+',
      '2' => '-',
      _ => '',
    };

    print('$coin = $currency = $price $indicator');
  }

  String _getDioErrorMessage(DioException error) {
    final responseData = error.response?.data;

    if (responseData is Map && responseData['Message'] != null) {
      return responseData['Message'].toString();
    }

    return switch (error.type) {
      DioExceptionType.connectionTimeout => 'Tiempo de conexión agotado.',
      DioExceptionType.sendTimeout => 'Tiempo de envío agotado.',
      DioExceptionType.receiveTimeout => 'Tiempo de respuesta agotado.',
      DioExceptionType.connectionError =>
        'No se pudo conectar con el servidor.',
      DioExceptionType.badResponse =>
        'Error del servidor. Código HTTP: ${error.response?.statusCode}',
      _ => 'Error de red: ${error.message}',
    };
  }

  void _disposeSocket() {
    _socket
      ?..off('m')
      ..disconnect()
      ..dispose();

    _socket = null;
  }

  @override
  Future<void> close() async {
    _disposeSocket();
    return super.close();
  }
}
