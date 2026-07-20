import '../Model/models.dart';
import 'package:equatable/equatable.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object?> get props => [];
}

class PostUninitialized extends PostState {
  @override
  String toString() => 'PostUninitialized';
}

class PostError extends PostState {
  @override
  String toString() => 'PostError';
}

class PostLoaded extends PostState {
  final List<GetCoinsAdd> posts;
  final bool hasReachedMax;

  const PostLoaded({required this.posts, required this.hasReachedMax});

  PostLoaded copyWith({List<GetCoinsAdd>? posts, bool? hasReachedMax}) {
    return PostLoaded(
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [posts, hasReachedMax];

  @override
  String toString() =>
      'PostLoaded { posts: ${posts.length}, hasReachedMax: $hasReachedMax }';
}

class NewsLoaded extends PostState {
  final List<News> posts;
  final bool hasReachedMax;

  const NewsLoaded({
    required this.posts,
    required this.hasReachedMax,
  });

  NewsLoaded copyWith({
    List<News>? posts,
    bool? hasReachedMax,
  }) {
    return NewsLoaded(
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [posts, hasReachedMax];

  @override
  String toString() =>
      'NewsLoaded { posts: ${posts.length}, hasReachedMax: $hasReachedMax }';
}

class MarketLoaded extends PostState {
  final List<Market> market;
  final bool hasReachedMax;

  const MarketLoaded({
    required this.market,
    required this.hasReachedMax,
  });

  MarketLoaded copyWith({
    List<Market>? market,
    bool? hasReachedMax,
  }) {
    return MarketLoaded(
      market: market ?? this.market,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [market, hasReachedMax];

  @override
  String toString() =>
      'MarketLoaded { market: ${market.length}, hasReachedMax: $hasReachedMax }';
}

class MarketCoinsLoaded extends PostState {
  final List<CoinsMarketData> marketcoins;
  final bool hasReachedMax;

  const MarketCoinsLoaded({
    required this.marketcoins,
    required this.hasReachedMax,
  });

  MarketCoinsLoaded copyWith({
    List<CoinsMarketData>? marketcoins,
    bool? hasReachedMax,
  }) {
    return MarketCoinsLoaded(
      marketcoins: marketcoins ?? this.marketcoins,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [marketcoins, hasReachedMax];

  @override
  String toString() =>
      'MarketCoinsLoaded { posts: ${marketcoins.length}, hasReachedMax: $hasReachedMax }';
}