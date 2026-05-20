import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/flutter_app/fragments/booking.dart';
import 'package:flutter_erp/apps/flutter_app/fragments/startrequest.dart';

void main() {
  //MapView.setApiKey("AIzaSyDT8-ttxGcKLv7LyC62JcSgT2TBYnXvfFw");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taxi App',
      theme: ThemeData(primarySwatch: Colors.blue),

      home: StartRequestScreen(),
      routes: <String, WidgetBuilder>{
        '/booking': (BuildContext context) => BookingScreen(),
      },
    );
  }
}
