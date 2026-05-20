import 'package:flutter/material.dart';

class BottomCenter extends StatelessWidget {
  final Widget child;
  final double bottomOffset;

  const BottomCenter({
    super.key,
    required this.child,
    this.bottomOffset = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottomOffset,
      left: 0,
      right: 0,
      child: Center(child: child),
    );
  }
}

/// Bottom Left
class BottomLeft extends StatelessWidget {
  final Widget child;

  const BottomLeft({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: child,
    );
  }
}

/// Bottom Right
class BottomRight extends StatelessWidget {
  final Widget child;

  const BottomRight({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: child,
    );
  }
}

/// Center Left
class CenterLeft extends StatelessWidget {
  final Widget child;

  const CenterLeft({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: child,
    );
  }
}

/// Center Right
class CenterRight extends StatelessWidget {
  final Widget child;

  const CenterRight({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: child,
    );
  }
}

class TopLeft extends StatelessWidget {
  final Widget child;

  const TopLeft({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: child,
    );
  }
}

class TopRight extends StatelessWidget {
  final Widget child;

  const TopRight({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: child,
    );
  }
}

class TopCenter extends StatelessWidget {
  final Widget child;

  const TopCenter({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: child,
    );
  }
}