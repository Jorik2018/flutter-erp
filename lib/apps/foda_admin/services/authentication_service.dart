import 'package:firebase_auth/firebase_auth.dart';

import '../models/result.dart';

class AuthenicationService {
  AuthenicationService._();

  static AuthenicationService? _instance;

  static AuthenicationService get instance {
    _instance ??= AuthenicationService._();
    return _instance!;
  }

  final auth = FirebaseAuth.instance;

  Future<bool> isEmailInUse(String email) async {
    if (!email.contains("@") || email.split(".").length < 2) {
      print("Invalid Email");
      return false;
    }

    try {
      final users = await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: "password",
      );
      if (users.user != null) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<Result<User>> logIn(String email, String password) async {
    try {
      final emailInUse = await isEmailInUse(email);

      if (!emailInUse) {
        return const Failure(
          AuthError("This user does not exist or email badly formatted"),
        );
      }

      final UserCredential authResult = await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = authResult.user;
      if (user != null) {
        return Success(user);
      }

      return const Failure(AuthError("Unable to login user"));
    } on FirebaseAuthException catch (error) {
      return Failure(AuthError(error.message ?? "Authentication error"));
    } catch (e) {
      return Failure(UnexpectedError(e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      await auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  Stream<User?> authStates() {
    return auth.authStateChanges();
  }
}
