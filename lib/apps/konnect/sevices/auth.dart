import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

abstract class AuthBase {
  Stream<User?> getCurrentAuthState();
  User? getCurrentUser();
  Future<User?> signInWithGoogle(
    bool toLink, [
    String previousEmail,
    AuthCredential creds,
  ]);
  Future<User?> signUpWithEmail(
    String email,
    String password,

    bool toLink, [
    AuthCredential? creds,
  ]);
  Future<User?> loginWithEmail(
    String email,
    String password,
    bool toLink, [
    String previousEmail,
    AuthCredential creds,
  ]);
  Future<User> signInWithFb();
  Future<void> signOut();
  Future<void> sendPasswordResetEmail(String email);
}

class Auth implements AuthBase {
  final _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  // Konnector _getUserFromFirebase(User user) {
  //   if (user == null) return null;
  //   return Konnector(user: user);
  // }

  @override
  Stream<User?> getCurrentAuthState() {
    return _auth.authStateChanges();
  }

  @override
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  @override
  Future<User?> signUpWithEmail(
    String email,
    String password,
    bool toLink, [
    AuthCredential? creds,
  ]) async {
    try {
      UserCredential userCreds = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCreds.user!.sendEmailVerification();
      if (toLink) userCreds.user!.linkWithCredential(creds!);
      await signOut();
      return null;
    } on PlatformException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      throw PlatformException(code: e.code, message: e.message);
    }
  }

  @override
  Future<User?> signInWithGoogle(
    bool toLink, [
    String? previousEmail,
    AuthCredential? creds,
  ]) async {
    try {
      // GoogleSignIn 7.x debe inicializarse antes de authenticate().
      await _googleSignIn.initialize();

      final GoogleSignInAccount googleSignInAccount = await _googleSignIn
          .authenticate();

      final GoogleSignInAuthentication googleAuth =
          googleSignInAccount.authentication;

      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        throw PlatformException(
          code: 'ERROR_MISSING_GOOGLE_AUTH_TOKENS',
          message: 'Google ID token is missing',
        );
      }

      final AuthCredential googleCredential = GoogleAuthProvider.credential(
        idToken: idToken,
      );

      final UserCredential userCreds = await _auth.signInWithCredential(
        googleCredential,
      );

      final User? user = userCreds.user;

      if (user == null) {
        throw PlatformException(
          code: 'ERROR_USER_NOT_FOUND',
          message: 'Firebase did not return a user',
        );
      }

      if (!toLink) {
        return user;
      }

      if (user.email == previousEmail) {
        if (creds == null) {
          throw PlatformException(
            code: 'ERROR_MISSING_CREDENTIAL',
            message: 'Credential to link is missing',
          );
        }

        await user.linkWithCredential(creds);
        return user;
      }

      throw PlatformException(
        code: 'ERROR_TRIED_DIFFERENT_ACCOUNT',
        message: 'Unable to link account with your given email address.',
      );
    } on GoogleSignInException catch (e) {
      throw PlatformException(
        code: e.code.name,
        message: e.description ?? 'Google sign in failed',
      );
    } on FirebaseAuthException catch (e) {
      throw PlatformException(code: e.code, message: e.message);
    }
  }

  @override
  Future<User> signInWithFb() async {
    final LoginResult result = await FacebookAuth.instance.login(
      permissions: ['email', 'public_profile'],
    );

    if (result.status != LoginStatus.success || result.accessToken == null) {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: result.message ?? 'Sign in aborted by user',
      );
    }

    final accessToken = result.accessToken!;
    final token = accessToken.tokenString;

    final AuthCredential facebookCredential = FacebookAuthProvider.credential(
      token,
    );

    try {
      final UserCredential userCreds = await _auth.signInWithCredential(
        facebookCredential,
      );

      final user = userCreds.user;

      if (user == null) {
        throw PlatformException(
          code: 'ERROR_USER_NOT_FOUND',
          message: 'Facebook login succeeded but Firebase returned no user',
        );
      }

      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code != 'account-exists-with-different-credential') {
        rethrow;
      }

      final String? email = e.email;

      throw PlatformException(
        code: 'ERROR_ALREADY_HAS_ACCOUNT',
        details: {'email': email, 'creds': e.credential ?? facebookCredential},
        message: 'Try signing in with another authentication method',
      );
    }
  }

  @override
  Future<void> signOut() async {
    await FacebookAuth.instance.logOut();
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw PlatformException(code: e.code, message: e.message);
    }
  }

  @override
  Future<User?> loginWithEmail(
    String email,
    String password,
    bool toLink, [
    String? previousEmail,
    AuthCredential? creds,
  ]) async {
    try {
      final UserCredential userCreds = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCreds.user;

      if (user == null) {
        throw PlatformException(
          code: 'ERROR_USER_NOT_FOUND',
          message: 'Firebase did not return a user',
        );
      }

      if (!toLink) {
        if (user.emailVerified) {
          return user;
        }

        final DateTime? creationTime = user.metadata.creationTime;

        if (creationTime == null) {
          throw PlatformException(
            code: 'ERROR_USER_NOT_VERIFIED',
            message: 'Please verify your account.',
          );
        }

        final Duration duration = DateTime.now().difference(creationTime);

        if (duration.inSeconds > 299) {
          await user.delete();

          throw PlatformException(
            code: 'ERROR_USER_NOT_FOUND',
            message:
                'Your account has been deleted since lacking email verification',
          );
        }

        final int minutesLeft = creationTime
            .add(const Duration(minutes: 5))
            .difference(DateTime.now())
            .inMinutes;

        throw PlatformException(
          code: 'ERROR_USER_NOT_VERIFIED',
          message: 'Please verify your account under $minutesLeft minutes.',
        );
      }

      if (user.email == previousEmail) {
        if (creds == null) {
          throw PlatformException(
            code: 'ERROR_MISSING_CREDENTIAL',
            message: 'Missing credential to link',
          );
        }

        await user.linkWithCredential(creds);

        return user;
      }

      throw PlatformException(
        code: 'ERROR_TRIED_DIFFERENT_ACCOUNT',
        message: 'The email address does not match the previous account',
      );
    } on PlatformException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      throw PlatformException(code: e.code, message: e.message);
    }
  }
}
