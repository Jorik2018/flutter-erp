import 'package:flutter_erp/apps/delivery_app/screens/details_screen.dart';
import 'package:flutter_erp/apps/delivery_app/screens/home_screen.dart';
import 'package:flutter/material.dart';

class DeliveryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "Poppins",
      ),
      home: Home(),
    );
    // home: Category());
  }
}
