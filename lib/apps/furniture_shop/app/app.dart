import 'package:flutter/material.dart';

import 'home.dart';

class FurnitureApp extends StatelessWidget {
  const FurnitureApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Furniture Shop',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: const ColorScheme.light(),
        appBarTheme: const AppBarTheme(
          elevation: 0,
        ),
        cardTheme: const CardTheme(
          elevation: 0,
        ).data,
      ),
      home: const Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
