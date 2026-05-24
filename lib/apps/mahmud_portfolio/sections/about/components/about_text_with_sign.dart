import 'package:flutter/material.dart';

import '../../../constants.dart';

class AboutTextWithSign extends StatelessWidget {
  const AboutTextWithSign({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "About \nmy story",
      style: Theme.of(context)
          .textTheme
          .headlineSmall!
          .copyWith(fontWeight: FontWeight.bold, color: Colors.black),
    );
  }
}
