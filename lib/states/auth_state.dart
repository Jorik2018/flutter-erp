import 'package:flutter_riverpod/legacy.dart';

final authProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(),
);

class AuthController extends StateNotifier<bool> {
  AuthController() : super(false);

  void login() => state = true;
  void logout() => state = false;
}