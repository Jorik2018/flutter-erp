import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/travel_app/screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Travel App',
      home: TravelAppScreen(),
    );
  }
}
