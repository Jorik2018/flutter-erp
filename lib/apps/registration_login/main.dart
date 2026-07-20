import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/registration_login/screen/home_screen.dart';
import 'package:flutter_erp/apps/registration_login/screen/login_screen.dart';
import 'package:flutter_erp/apps/registration_login/screen/registration_screen.dart';
import 'package:flutter_erp/apps/registration_login/screen/splash_screen.dart';

var routes = <String, WidgetBuilder>{
  "/RegistrationScreen": (BuildContext context) => RegistrationScreen(),
  "/LoginScreen": (BuildContext context) => LoginScreen(),
  "/HomeScreen": (BuildContext context) => HomeScreen(),
};

void main() => runApp(MaterialApp(home: SplashScreen(), routes: routes));
