import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/gettaxi/screens/login_page.dart';
import 'package:flutter_erp/apps/gettaxi/screens/main_page.dart';
import 'package:flutter_erp/apps/gettaxi/screens/register_page.dart';

class GetTaxiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Brand-Regular', primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,

      initialRoute: GetTaxiPage.id,
      routes: {
        RegisterPage.id: (context) => RegisterPage(),
        LoginPage.id: (context) => LoginPage(),
        GetTaxiPage.id: (context) => GetTaxiPage(),
      },
    );
  }
}
