import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

import '../Util/SharedPreferencesHelper.dart';
import '../models/models.dart';
import 'post_event.dart';
import 'post_state.dart';

EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) {
    return events.debounceTime(duration).switchMap(mapper);
  };
}

class NewsPostBloc extends Bloc<PostEvent, PostState> {
  final Dio dio;

  NewsPostBloc({required this.dio}) : super(PostUninitialized()) {
    on<Fetch>(
      _onFetch,
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }

  Future<void> _onFetch(Fetch event, Emitter<PostState> emit) async {
    if (state is PostLoading || _hasReachedMax(state)) {
      return;
    }

    try {
      if (state is PostUninitialized) {
        emit(PostLoading());

        final posts = await fetchNews(startIndex: 0, limit: 20);

        emit(NewsLoaded(posts: posts, hasReachedMax: posts.length < 20));

        return;
      }

      if (state is NewsLoaded) {
        final currentState = state as NewsLoaded;

        final newPosts = await fetchNews(
          startIndex: currentState.posts.length,
          limit: 20,
        );

        if (newPosts.isEmpty) {
          emit(currentState.copyWith(hasReachedMax: true));

          return;
        }

        emit(
          NewsLoaded(
            posts: [...currentState.posts, ...newPosts],
            hasReachedMax: newPosts.length < 20,
          ),
        );
      }
    } on DioException catch (error) {
      emit(PostError(message: _getDioErrorMessage(error)));
    } catch (error) {
      emit(PostError(message: error.toString()));
    }
  }

  bool _hasReachedMax(PostState state) {
    return state is NewsLoaded && state.hasReachedMax;
  }

  Future<List<News>> fetchNews({
    required int startIndex,
    required int limit,
  }) async {
    final List<dynamic> newsList = await SharedPreferencesHelper.getNewsList();

    final String selectedNews = await SharedPreferencesHelper.getNews();

    String feeds;

    if (selectedNews.trim().isEmpty) {
      feeds = newsList
          .map((item) => item.toString().trim())
          .where((item) => item.isNotEmpty)
          .join(',');
    } else {
      feeds = selectedNews.trim().toLowerCase();
    }

    final Map<String, dynamic> queryParameters = {'lang': 'EN'};

    if (feeds.isNotEmpty) {
      queryParameters['feeds'] = feeds;
    }

    final Response<dynamic> response = await dio.get(
      'https://min-api.cryptocompare.com/data/v2/news/',
      queryParameters: queryParameters,
    );

    final dynamic responseBody = response.data;

    if (responseBody is! Map<String, dynamic>) {
      throw Exception('La respuesta del servidor no es válida.');
    }

    final dynamic data = responseBody['Data'];

    if (data is! List) {
      throw Exception(
        responseBody['Message']?.toString() ?? 'No se encontraron noticias.',
      );
    }

    return data
        .whereType<Map<String, dynamic>>()
        .skip(startIndex)
        .take(limit)
        .map(News.fromMap)
        .toList();
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
