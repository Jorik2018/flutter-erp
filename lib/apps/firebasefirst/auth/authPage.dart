import 'package:flutter_erp/apps/firebasefirst/pages/logingPage.dart';
import 'package:flutter_erp/apps/firebasefirst/pages/registerPage.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLogingPage = true;

  void toggleScreens() {
    setState(() {
      showLogingPage = !showLogingPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLogingPage) {
      return LogingPage(showRegisterPage: toggleScreens);
    } else {
      return RegisterPage(showLogingPage: toggleScreens);
    }
  }
}
