import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_erp/apps/cryptomarket/bloc/post_event.dart';
import 'package:flutter_erp/apps/cryptomarket/bloc/post_state.dart';
import 'package:flutter_erp/apps/cryptomarket/models/models.dart';
import 'package:rxdart/rxdart.dart';

EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) {
    return events.debounceTime(duration).switchMap(mapper);
  };
}

class MarketPostBloc extends Bloc<PostEvent, PostState> {
  final Dio dio;
  final String apiKey;

  MarketPostBloc({required this.dio, required this.apiKey})
    : super(PostUninitialized()) {
    on<Fetch>(
      _onFetch,
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }

  Future<void> _onFetch(Fetch event, Emitter<PostState> emit) async {
    // Este BLoC no tiene paginación implementada.
    // Si ya cargó los mercados, no vuelve a consultar.
    if (state is MarketLoaded || state is PostLoading) {
      return;
    }

    emit(PostLoading());

    try {
      final List<Market> posts = await fetchMarket(startIndex: 0, limit: 20);

      emit(MarketLoaded(market: posts, hasReachedMax: false));
    } on DioException catch (error) {
      emit(PostError(message: _getDioErrorMessage(error)));
    } catch (error) {
      emit(PostError(message: error.toString()));
    }
  }

  Future<List<Market>> fetchMarket({
    required int startIndex,
    required int limit,
  }) async {
    final Response<dynamic> response = await dio.get(
      'https://min-api.cryptocompare.com/data/exchanges/general',
      queryParameters: {'api_key': apiKey},
    );

    final dynamic responseBody = response.data;

    if (responseBody is! Map<String, dynamic>) {
      throw Exception('La respuesta del servidor no es válida.');
    }

    final dynamic data = responseBody['Data'];

    if (data is! Map) {
      throw Exception(
        responseBody['Message']?.toString() ?? 'No se encontraron mercados.',
      );
    }

    final List<Market> posts = [];

    final entries = data.entries.skip(startIndex).take(limit);

    for (final MapEntry<dynamic, dynamic> entry in entries) {
      final dynamic value = entry.value;

      if (value is! Map) {
        continue;
      }

      final String name = value['Name']?.toString() ?? '';
      final String logoUrl = value['LogoUrl']?.toString() ?? '';

      if (name.isEmpty) {
        continue;
      }

      posts.add(Market(name, logoUrl));
    }

    return posts;
  }

  String _getDioErrorMessage(DioException error) {
    final dynamic responseData = error.response?.data;

    if (responseData is Map<String, dynamic> &&
        responseData['Message'] != null) {
      return responseData['Message'].toString();
    }

    return 'Error de red: ${error.message ?? 'sin detalles'}';
  }
}
