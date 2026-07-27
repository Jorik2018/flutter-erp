import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_erp/apps/cryptomarket/bloc/post_event.dart';
import 'package:flutter_erp/apps/cryptomarket/bloc/post_state.dart';
import 'package:rxdart/rxdart.dart';

import 'package:flutter_erp/apps/cryptomarket/Util/SharedPreferencesHelper.dart';
import 'package:flutter_erp/apps/cryptomarket/models/CoinsMarketData.dart';

EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) {
    return events.debounceTime(duration).switchMap(mapper);
  };
}

class MarketCoinsBloc extends Bloc<PostEvent, PostState> {
  final Dio dio;

  MarketCoinsBloc({required this.dio}) : super(PostUninitialized()) {
    on<Fetch>(
      _onFetch,
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }

  Future<void> _onFetch(Fetch event, Emitter<PostState> emit) async {
    if (state is PostLoading || _hasReachedMax(state)) {
      return;
    }

    emit(PostLoading());

    try {
      final posts = await fetchMarket1(startIndex: 0, limit: 20);

      emit(MarketCoinsLoaded(marketcoins: posts, hasReachedMax: false));
    } on DioException catch (error) {
      emit(PostError(message: _getDioErrorMessage(error)));
    } catch (error) {
      emit(PostError(message: error.toString()));
    }
  }

  bool _hasReachedMax(PostState state) {
    return state is MarketCoinsLoaded && state.hasReachedMax;
  }

  Future<List<CoinsMarketData>> fetchMarket1({
    required int startIndex,
    required int limit,
  }) async {
    final String market = await SharedPreferencesHelper.getMarket();
    final String currency = await SharedPreferencesHelper.getCurrency();

    final Response<dynamic> exchangesResponse = await dio.get(
      'https://min-api.cryptocompare.com/data/v2/all/exchanges',
    );

    final dynamic responseBody = exchangesResponse.data;

    if (responseBody is! Map<String, dynamic>) {
      throw Exception('Respuesta inválida al consultar los exchanges.');
    }

    final dynamic allData = responseBody['Data'];

    if (allData is! Map<String, dynamic>) {
      throw Exception('No se encontró la propiedad Data en la respuesta.');
    }

    final dynamic selectedMarketData = allData[market];

    if (selectedMarketData is! Map) {
      throw Exception('No se encontró el mercado seleccionado: $market');
    }

    final List<String> symbols = [];

    for (final MapEntry<dynamic, dynamic> entry in selectedMarketData.entries) {
      final String baseSymbol = entry.key.toString();

      if (baseSymbol == 'is_active') {
        continue;
      }

      final dynamic value = entry.value;

      if (value is! Map) {
        continue;
      }

      for (final dynamic coinSymbol in value.keys) {
        final String symbol = coinSymbol.toString();

        if (!symbols.contains(symbol)) {
          symbols.add(symbol);
        }
      }
    }

    final List<String> paginatedSymbols = symbols
        .skip(startIndex)
        .take(limit)
        .toList();

    final List<CoinsMarketData> posts = [];

    // No se usa forEach async: el ciclo espera cada petición correctamente.
    for (final String symbol in paginatedSymbols) {
      final CoinsMarketData? coin = await _fetchCoinData(
        symbol: symbol,
        currency: currency,
        market: market,
      );

      if (coin != null) {
        posts.add(coin);
      }
    }

    return posts;
  }

  Future<CoinsMarketData?> _fetchCoinData({
    required String symbol,
    required String currency,
    required String market,
  }) async {
    try {
      final Response<dynamic> response = await dio.get(
        'https://min-api.cryptocompare.com/data/pricemultifull',
        queryParameters: {'fsyms': symbol, 'tsyms': currency, 'e': market},
      );

      final dynamic responseBody = response.data;

      if (responseBody is! Map<String, dynamic>) {
        return null;
      }

      final dynamic raw = responseBody['RAW'];

      if (raw is! Map) {
        return null;
      }

      final dynamic symbolData = raw[symbol];

      if (symbolData is! Map) {
        return null;
      }

      final dynamic currencyData = symbolData[currency];

      if (currencyData is! Map) {
        return null;
      }

      return CoinsMarketData(
        _valueToString(currencyData['PRICE']),
        _valueToString(currencyData['CHANGEPCT24HOUR']),
        _valueToString(currencyData['MARKET']),
        _valueToString(currencyData['CHANGE24HOUR']),
        _valueToString(currencyData['HIGH24HOUR']),
        _valueToString(currencyData['LOW24HOUR']),
        _valueToString(currencyData['MKTCAP']),
        _valueToString(currencyData['VOLUME24HOUR']),
        _valueToString(currencyData['VOLUME24HOURTO']),
        _valueToString(currencyData['TOSYMBOL']),
        _valueToString(currencyData['SUPPLY']),
        _valueToString(currencyData['FROMSYMBOL']),
        _valueToString(currencyData['IMAGEURL']),
      );
    } on DioException {
      // Una moneda puede no tener cotización en el exchange elegido.
      // Se ignora esa moneda, sin detener toda la carga.
      return null;
    }
  }

  String _valueToString(dynamic value) {
    return value?.toString() ?? '';
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
