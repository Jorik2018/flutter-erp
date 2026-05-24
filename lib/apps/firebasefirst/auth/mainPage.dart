import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_erp/apps/firebasefirst/auth/authPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/firebasefirst/pages/homePage.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, AsyncSnapshot<User?> snapshot) {
            if (snapshot.hasData) {
              return HomePage();
            } else {
              return AuthPage();
            }
          }),
    );
  }
}
