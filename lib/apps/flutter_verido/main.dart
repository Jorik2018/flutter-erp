import 'package:flutter/material.dart';

import 'package:flutter_erp/apps/flutter_verido/widgets/Drawer.dart';
import 'package:flutter_erp/apps/flutter_verido/Widgets/MyAppBar.dart';
import 'package:flutter_erp/apps/flutter_verido/screens/Assignment3.dart';
import 'package:flutter_erp/apps/flutter_verido/screens/PrimeDetect.dart';
import 'package:flutter_erp/apps/flutter_verido/screens/AssignmentAPI5.dart';
import 'package:flutter_erp/apps/flutter_verido/screens/assignment4.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Zahid Ali Regestration Number 2018-CS-136

void main() {
  runApp(
    ScreenUtilInit(
      designSize: const Size(400, 810),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(home: child);
      },
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello World Flutter Application',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.teal,
      ),
      home: MyHomePage(),
      // initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        // '/': (context) => PrimeDetectState(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/Assignment3': (context) => Assignment3(),
        '/Assignment5': (context) => Assignment5(),
        '/Assignment4': (context) => Assignment4(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);
  // This widget is the home page of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: Container(
        width: MediaQuery.of(context).size.width * 0.65,
        child: DrawerWidget(),
      ),
      // imported from PrimeDetect
      body: PrimeDetectState(),
    );
  }
}
