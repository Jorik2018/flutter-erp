import 'package:flutter/widgets.dart';

class SeparatedColumn extends StatelessWidget {
  final List<Widget> children;
  final Widget Function()? separatorBuilder;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;

  const SeparatedColumn({
    super.key,
    required this.children,
    this.separatorBuilder,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = [];

    for (int i = 0; i < children.length; i++) {
      items.add(children[i]);

      if (i != children.length - 1 && separatorBuilder != null) {
        items.add(separatorBuilder!());
      }
    }

    return Column(
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      children: items,
    );
  }
}