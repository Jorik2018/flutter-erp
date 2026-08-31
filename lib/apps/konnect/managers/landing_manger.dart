import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/konnect/screens/auth/add_phone_page.dart';
import 'package:flutter_erp/apps/konnect/screens/auth/auth_page.dart';
import 'package:flutter_erp/apps/konnect/screens/chat/home_page.dart';
import 'package:flutter_erp/apps/konnect/screens/misc/loading_page.dart';
import 'package:flutter_erp/apps/konnect/screens/register/register_page.dart';
import 'package:flutter_erp/apps/konnect/sevices/auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingManager extends StatelessWidget {
  const LandingManager({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context);

    return StreamBuilder<User?>(
      stream: auth.getCurrentAuthState(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState != ConnectionState.active) {
          return LoadingPage();
        }

        final User? thisUser = snapshot.data;

        if (thisUser == null) {
          return AuthPage();
        }

        final int index = thisUser.providerData.indexWhere(
          (info) => info.providerId == 'password',
        );

        if (index > -1 && !thisUser.emailVerified) {
          return AuthPage();
        }

        final String? phoneNumber = thisUser.phoneNumber;

        if (phoneNumber == null || phoneNumber.isEmpty) {
          return AddPhonePage.create(thisUser);
        }

        return FutureBuilder<SharedPreferences>(
          future: SharedPreferences.getInstance(),
          builder:
              (BuildContext context, AsyncSnapshot<SharedPreferences> prefs) {
                if (prefs.connectionState != ConnectionState.done) {
                  return LoadingPage();
                }

                final sharedPreferences = prefs.data;

                if (sharedPreferences == null) {
                  return LoadingPage();
                }

                if (sharedPreferences.getBool('user') != null) {
                  return HomePage();
                }

                return RegisterPage(thisUser);
              },
        );
      },
    );
  }
}
