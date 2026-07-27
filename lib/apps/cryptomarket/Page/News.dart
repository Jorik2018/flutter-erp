import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_erp/apps/cryptomarket/bloc/news_post_bloc.dart';
import 'package:flutter_erp/apps/cryptomarket/bloc/post_event.dart';
import 'package:flutter_erp/apps/cryptomarket/bloc/post_state.dart';
import 'package:flutter_erp/apps/cryptomarket/models/models.dart';

import 'NewsDescription.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final ScrollController _scrollController = ScrollController();

  late final NewsPostBloc _newsPostBloc;

  static const double _scrollThreshold = 200.0;

  bool _isRequestInProgress = false;

  @override
  void initState() {
    super.initState();

    _newsPostBloc = NewsPostBloc(dio: Dio());

    _scrollController.addListener(_onScroll);

    _isRequestInProgress = true;
    _newsPostBloc.add(const Fetch());
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();

    _newsPostBloc.close();

    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients || _isRequestInProgress) {
      return;
    }

    final double maxScroll = _scrollController.position.maxScrollExtent;
    final double currentScroll = _scrollController.position.pixels;

    if (maxScroll - currentScroll <= _scrollThreshold) {
      _isRequestInProgress = true;
      _newsPostBloc.add(const Fetch());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        title: const Text('News', style: TextStyle(fontSize: 20)),
      ),
      body: BlocConsumer<NewsPostBloc, PostState>(
        bloc: _newsPostBloc,
        listener: (context, state) {
          if (state is NewsLoaded || state is PostError) {
            _isRequestInProgress = false;
          }
        },
        builder: (context, state) {
          if (state is PostUninitialized || state is PostLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PostError) {
            return Center(child: Text(state.message));
          }

          if (state is! NewsLoaded) {
            return const SizedBox.shrink();
          }

          if (state.posts.isEmpty) {
            return const Center(child: Text('No news'));
          }

          final bool showLoadingIndicator = !state.hasReachedMax;

          return ListView.builder(
            controller: _scrollController,
            itemCount: state.posts.length + (showLoadingIndicator ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= state.posts.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              return NewsWidget(news: state.posts[index]);
            },
          );
        },
      ),
    );
  }
}

class NewsWidget extends StatelessWidget {
  final News news;

  const NewsWidget({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => NewsDescription(news)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: SizedBox(
            height: 220,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  news.imageurl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      color: Colors.grey.shade800,
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.white,
                          size: 42,
                        ),
                      ),
                    );
                  },
                ),
                Container(color: Colors.black54),
                Positioned(
                  top: 8,
                  right: 8,
                  left: 8,
                  child: Text(
                    news.source.toUpperCase(),
                    maxLines: 2,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
                Positioned(
                  right: 8,
                  bottom: 8,
                  left: 8,
                  child: Text(
                    news.title,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
