import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/singtaxi/screens/authenticate/LoginPage.dart';
import 'package:flutter_erp/apps/singtaxi/StartPage.dart';
import 'package:flutter_erp/apps/singtaxi/screens/home/WelcomePage.dart';
import 'package:flutter_erp/apps/singtaxi/screens/authenticate/authenticate.dart';
import 'package:flutter_erp/apps/singtaxi/screens/home/home.dart';
import 'package:provider/provider.dart';
import 'package:flutter_erp/apps/singtaxi/models/user.dart';
import 'home/onboarding_screen.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print(user);
    //return either home or authenticate widget
    if (user == null) {
      return OnboardingScreen();
    } else {
      return WelcomePage();
    }
  }
}
