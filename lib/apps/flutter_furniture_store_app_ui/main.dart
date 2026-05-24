import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/flutter_furniture_store_app_ui/common/color_constants.dart';
import 'package:flutter_erp/apps/flutter_furniture_store_app_ui/screen/home_page_screen.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(
            color: ColorConstants.primaryColor,
          ),
          elevation: 0,
          color: Colors.white,
        ),
      ),
      home: HomePageScreen(),
    );
  }
}
