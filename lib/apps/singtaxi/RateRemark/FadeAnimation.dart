import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class FadeAnimation extends StatelessWidget {
  static final _opacity = MovieTweenProperty<double>();
  static final _translateY = MovieTweenProperty<double>();

  final double delay;
  final Widget child;

  const FadeAnimation(this.delay, this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    final tween = MovieTween()
      ..scene(duration: const Duration(milliseconds: 500))
          .tween<double>(_opacity, Tween<double>(begin: 0.0, end: 1.0))
          .tween<double>(
            _translateY,
            Tween<double>(begin: -30.0, end: 0.0),
            curve: Curves.easeOut,
          );

    return PlayAnimationBuilder<Movie>(
      tween: tween,
      duration: tween.duration,
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
