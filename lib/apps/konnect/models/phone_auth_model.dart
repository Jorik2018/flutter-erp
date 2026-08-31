import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../validators/form_validator.dart';

enum PhoneAuthType { login, register }

class PhoneAuthModel with ChangeNotifier, FormValidator {
  String phoneNo;
  String otp;
  late String verId;
  User? userToLink;
  PhoneAuthType type;
  static FirebaseAuth auth = FirebaseAuth.instance;

  PhoneAuthModel({
    required this.type,
    this.userToLink,
    this.phoneNo = '',
    this.otp = '',
  });

  void updateWith({
    String? phoneNo,
    String? otp,
    PhoneAuthType? formType,
    bool? isSubmitted,
  }) {
    this.phoneNo = phoneNo ?? this.phoneNo;
    this.otp = otp ?? this.otp;
    this.type = formType ?? this.type;
    notifyListeners();
  }

  void updatePhone(String phNo) => updateWith(phoneNo: phNo);

  void updateOtp(String otp) => updateWith(otp: otp);

  bool get canSubmit {
    return phoneValidator.isValid(phoneNo);
  }

  bool get isValidOtp => otpValidator.isValid(otp);

  String? get phoneErrorText {
    bool showErrorText = !phoneValidator.isValid(phoneNo);
    return showErrorText ? phoneError : null;
  }

  Future<void> verifyPhoneNumber() async {
    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
          try {
            if (type == PhoneAuthType.login) {
              final prefs = await SharedPreferences.getInstance();

              if (prefs.getString('user') != null) {
                await auth.signInWithCredential(phoneAuthCredential);

                debugPrint(
                  'Phone number automatically verified and user signed in: '
                  '${auth.currentUser?.uid}',
                );
              } else {
                // Si necesitas conservar el credential para otro paso:
                // phoneCredential = phoneAuthCredential;
              }
            } else {
              final user = userToLink;

              if (user == null) {
                throw StateError('userToLink is required for phone linking.');
              }

              await user.linkWithCredential(phoneAuthCredential);

              await auth.signInWithCredential(phoneAuthCredential);

              debugPrint(
                'Phone number automatically verified and user signed in: '
                '${auth.currentUser?.uid}',
              );
            }
          } catch (e) {
            debugPrint('Automatic phone verification failed: $e');
          }
        };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
          debugPrint(
            'Phone number verification failed. '
            'Code: ${authException.code}. '
            'Message: ${authException.message}',
          );

          // Maneja aquí el error en tu modelo/estado.
        };

    final PhoneCodeSent codeSent =
        (String verificationId, int? forceResendingToken) {
          debugPrint('Please check your phone for the verification code.');

          verId = verificationId;
        };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
          verId = verificationId;
        };

    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } catch (e) {
      debugPrint('Failed to Verify Phone Number: $e');

      rethrow;
    }
  }

  Future<AuthCredential?> signInWithPhoneNumber() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verId,
        smsCode: otp,
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getString('user') != null) {
        await userToLink!.linkWithCredential(credential);
        print(
          "Phone number verified and user signed in: ${auth.currentUser!.uid}",
        );
        return null;
      } else
        return credential;
    } on FirebaseAuthException catch (e) {
      debugPrint("Failed to sign in: ${e.message}");

      throw PlatformException(code: e.code, message: e.message);
    }
  }
}
