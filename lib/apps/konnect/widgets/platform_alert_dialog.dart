import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/konnect/widgets/platform_widget.dart';

class PlatformAlertDialog extends PlatformWidget {
  final String title;
  final String content;
  final String? cancelActionText;
  final String defaultActionText;

  PlatformAlertDialog({
    required this.title,
    this.cancelActionText,
    required this.content,
    required this.defaultActionText,
  });

  Future<bool> show(BuildContext context) async {
    final result = Platform.isIOS
        ? await showCupertinoDialog<bool>(
            context: context,
            builder: (context) => this,
          )
        : await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (context) => this,
          );

    return result ?? false;
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _buildActions(context),
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final List<Widget> actions = [];

    if (cancelActionText != null) {
      actions.add(
        PlatformAlertDialogAction(
          child: Text(cancelActionText!),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      );
    }

    actions.add(
      PlatformAlertDialogAction(
        child: Text(defaultActionText),
        onPressed: () => Navigator.of(context).pop(true),
      ),
    );

    return actions;
  }
}

class PlatformAlertDialogAction extends PlatformWidget {
  final Widget child;
  final VoidCallback onPressed;

  PlatformAlertDialogAction({required this.child, required this.onPressed});

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoDialogAction(onPressed: onPressed, child: child);
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return TextButton(onPressed: onPressed, child: child);
  }
}
