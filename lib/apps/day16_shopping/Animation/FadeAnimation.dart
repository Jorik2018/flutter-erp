import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class FadeAnimation extends StatelessWidget {
  const FadeAnimation({super.key, required this.delay, required this.child});

  final double delay;
  final Widget child;

  static final MovieTweenProperty<double> _opacity =
      MovieTweenProperty<double>();

  static final MovieTweenProperty<double> _translateY =
      MovieTweenProperty<double>();

  static final MovieTween _tween = MovieTween()
    ..scene(begin: Duration.zero, duration: const Duration(milliseconds: 500))
        .tween(_opacity, Tween<double>(begin: 0, end: 1))
        .tween(
          _translateY,
          Tween<double>(begin: -30, end: 0),
          curve: Curves.easeOut,
        );

  @override
  Widget build(BuildContext context) {
    return PlayAnimationBuilder<Movie>(
      tween: _tween,
      duration: _tween.duration,
      delay: Duration(milliseconds: (500 * delay).round()),
      child: child,
      builder: (context, animation, child) {
        return Opacity(
          opacity: _opacity.from(animation),
          child: Transform.translate(
            offset: Offset(0, _translateY.from(animation)),
            child: child,
          ),
        );
      },
    );
  }
}
