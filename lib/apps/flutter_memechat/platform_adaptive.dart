// Copyright 2017, the Flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

final ThemeData kIOSTheme = ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
);

final ThemeData kDefaultTheme = ThemeData(
  primarySwatch: Colors.purple,
);

/// App bar that uses iOS styling on iOS
class PlatformAdaptiveAppBar extends AppBar {
  PlatformAdaptiveAppBar({
    Key? key,
    TargetPlatform? platform,
    List<Widget>? actions,
    Widget? title,
    Widget? body,
    // TODO(jackson): other properties?
  })
      : super(
          key: key,
          elevation: platform == TargetPlatform.iOS ? 0.0 : 4.0,
          title: title,
          actions: actions,
        );
}

class PlatformAdaptiveButton extends StatelessWidget {
  PlatformAdaptiveButton({Key? key, required this.child, required this.icon, this.onPressed})
      : super(key: key);
  final Widget child;
  final Widget icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return CupertinoButton(
        child: child,
        onPressed: onPressed,
      );
    } else {
      return IconButton(
        icon: icon,
        onPressed: onPressed,
      );
    }
  }
}

class PlatformAdaptiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets margin;

  PlatformAdaptiveContainer({Key? key, required this.child, required this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
      margin: margin,
      decoration: Theme.of(context).platform == TargetPlatform.iOS
          ? BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey[200]!)))
          : null,
    );
  }
}

class PlatformChooser extends StatelessWidget {
  PlatformChooser({Key? key, required this.iosChild, required this.defaultChild});
  final Widget iosChild;
  final Widget defaultChild;

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) return iosChild;
    return defaultChild;
  }
}
