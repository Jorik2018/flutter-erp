import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/flutterhotelbookingapp/utils/parallax_sliding_card.dart';

class ParallaxPageView extends StatefulWidget {
  final double viewportFraction;
  final int height;
  final List<ISlidingCard> data;
  final void Function(ISlidingCard) onCardTap;

  const ParallaxPageView({
    super.key,
    this.viewportFraction = 1,
    this.height = 500,
    required this.data,
    required this.onCardTap,
  });

  @override
  State<ParallaxPageView> createState() => _ParallaxPageViewState();

  static RectTween createRectTween(Rect? begin, Rect? end) {
    return MaterialRectCenterArcTween(begin: begin, end: end);
  }
}

class _ParallaxPageViewState extends State<ParallaxPageView> {
  late final PageController pageController;

  @override
  void initState() {
    super.initState();

    pageController = PageController(viewportFraction: widget.viewportFraction);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const OverScrollBehavior(),
      child: SizedBox(
        height: widget.height.toDouble(),
        child: AnimatedBuilder(
          animation: pageController,
          builder: (context, child) {
            return PageView.builder(
              controller: pageController,
              itemCount: widget.data.length,
              itemBuilder: (context, index) {
                final double page;

                if (pageController.hasClients &&
                    pageController.position.hasContentDimensions) {
                  page = pageController.page ?? 0.0;
                } else {
                  page = 0.0;
                }

                return SlidingCard(
                  height: widget.height,
                  viewportFraction: widget.viewportFraction,
                  title: widget.data[index].cardTitle(),
                  subTitle: widget.data[index].cardSubTitle(),
                  imageAssetName: widget.data[index].cardImageAsset(),
                  offset: page - index,
                  position: index,
                  onCardTap: (position) {
                    widget.onCardTap(widget.data[position]);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class OverScrollBehavior extends ScrollBehavior {
  const OverScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
