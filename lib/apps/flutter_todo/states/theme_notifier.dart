import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  /// login simple (mock o real)
  void login() {
    state = true;
  }

  void logout() {
    state = false;
  }

  /// si quieres simular auto auth
  void autoLogin(bool value) {
    state = value;
  }
}