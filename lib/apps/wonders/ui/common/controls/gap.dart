import 'package:flutter/widgets.dart';

class Gap extends StatelessWidget {
  final double size;
  final Axis direction;

  const Gap(
    this.size, {
    super.key,
    this.direction = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    return direction == Axis.vertical
        ? SizedBox(height: size)
        : SizedBox(width: size);
  }
}