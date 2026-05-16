import 'package:flutter/material.dart';

import '../themes/app_theme.dart';

class FodaTextfield extends StatelessWidget {
  final String title;
  final TextEditingController? controller;
  const FodaTextfield({
    Key? key,
    required this.title,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(color: AppTheme.white),
      controller: controller,
      decoration: InputDecoration(
        hintText: title,
      ),
    );
  }
}
