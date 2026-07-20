import 'dart:async';
import 'dart:convert';

import '../Model/models.dart';
import '../Util/SharedPreferencesHelper.dart';
import 'bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

class NewsPostBloc extends Bloc<PostEvent, PostState> {
  final http.Client httpClient;

  NewsPostBloc({required this.httpClient}) : super(PostUninitialized()) {
    on<Fetch>(_onFetch);
  }

  Future<void> _onFetch(Fetch event, Emitter<PostState> emit) async {
    if (_hasReachedMax(state)) return;

    try {
      if (state is PostUninitialized) {
        final posts = await fetchNews(0, 20);
        emit(NewsLoaded(posts: posts, hasReachedMax: false));
      }
    } catch (_) {
      emit(PostError());
    }
  }

  bool _hasReachedMax(PostState state) =>
      state is NewsLoaded && state.hasReachedMax;
}

Future<List<News>> fetchNews(int startIndex, int limit) async {
  // TODO: implement fetchCurrencies

  List newsList = await SharedPreferencesHelper.getNewsList();
  String _news = newsList.toString().replaceAll('[', '').replaceAll(']', '');
  String news = await SharedPreferencesHelper.getNews();
  String apiUrl;
  if (news == '') {
    apiUrl =
        'https://min-api.cryptocompare.com/data/v2/news/?lang=EN&feeds=' +
        _news;
  } else {
    apiUrl =
        'https://min-api.cryptocompare.com/data/v2/news/?lang=EN&feeds=' +
        news.toLowerCase();
  }

  // Make a HTTP GET request to the CoinMarketCap API.
  // Await basically pauses execution until the get() function returns a Response
  http.Response response = await http.get(Uri.parse(apiUrl));
  var responseBody = json.decode(response.body);

  List data = responseBody['Data'];

  final statusCode = response.statusCode;
  if (statusCode != 200 || responseBody == null) {
    throw new Exception("An error ocurred : [Status Code : $statusCode]");
  }

  return data.map((c) => new News.fromMap(c)).toList();
}
