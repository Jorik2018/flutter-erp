import 'package:flutter/foundation.dart';
import 'package:auth0_flutter/auth0_flutter.dart';

class LandingViewModel extends ChangeNotifier {

  bool _signingIn = false;
  
  bool get signingIn => _signingIn;

  Future<void> signIn() async {
    try {
      Auth0 auth0 = Auth0('dev-lsx2d3wz10wmnc47.us.auth0.com', 'BzcFFYfU2p3tI8K2CJrKgG4yHGqZtI84');
      await auth0.webAuthentication().login();
      _signingIn = true;
      notifyListeners();
      await Future.delayed(Duration(seconds: 3), () {});
      // TODO: handle signing in
    } finally {
      _signingIn = false;
      notifyListeners();
    }
  }

}