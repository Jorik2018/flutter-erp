import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LikeAnimation extends StatelessWidget {
  const LikeAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return const RiveAnimation.asset(
      'assets/rive/like.riv',
      fit: BoxFit.contain,
    );
  }
}
