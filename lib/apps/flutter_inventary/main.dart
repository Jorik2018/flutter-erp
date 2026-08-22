import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'package:flutter_erp/apps/flutter_inventary/router/main.dart';

void main() {
  usePathUrlStrategy();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  static const String title = 'Inventary Application';

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: getRouter(),
      title: title,
      debugShowCheckedModeBanner: false,
    );
  }
}
