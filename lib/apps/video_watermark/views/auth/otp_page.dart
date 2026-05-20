import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pinput/pinput.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter_erp/apps/video_watermark/Splash.dart';
import 'package:flutter_erp/apps/video_watermark/utils/firebaseConstants.dart';
import 'package:flutter_erp/apps/video_watermark/utils/constants.dart';
import 'package:flutter_erp/apps/video_watermark/utils/responsive.dart';

class OTPPage extends StatefulWidget {
  final verificationId;

  const OTPPage({Key? key, this.verificationId}) : super(key: key);
  @override
  _OTPPageState createState() => _OTPPageState(this.verificationId);
}

class _OTPPageState extends State<OTPPage> {
  var _smsCodeController;
  final verificationId;
  _OTPPageState(this.verificationId);
  String text = '';
  final FocusNode _pinPutFocusNode = FocusNode();
  final requiredValidator = RequiredValidator(
    errorText: 'This field is required',
  );
  final appleIdValidator = EmailValidator(
    errorText: 'Enter a valid email address',
  );
  final appleIdController = TextEditingController();
  final passController = TextEditingController();
  final TextEditingController _pinPutController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      bottom: false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_sharp),
                    iconSize: 32,
                    color: kTitleColor,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.only(
                    left: 30,
                    right: 20,
                    bottom: 30,
                  ),
                  child: Text(
                    'Verify your mobile number',
                    style: TextStyle(
                      color: kTitleColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Image.asset("assets/images/message.png", height: 58, width: 58),
                SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 10,
                  ),
                  child: Text(
                    'OTP has been sent to you on your mobile number. please enter it below',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 35,
                    right: 35,
                    bottom: 50,
                  ),
                  child: darkRoundedPinPut(),
                ),
                InkWell(
                  child: Text(
                    'Don\'t received otp?',
                    style: TextStyle(
                      color: kTextColor,
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  /**error:The method 'FlatButton' isn't defined for the type '_OTPPageState'.
Try correcting the name to the name of an existing method, or defining a method named 'FlatButton' */
                  child: TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size(SizeConfig.screenWidth! * 0.33, 38),
                      backgroundColor: kWhiteColor,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: kBlueColor, width: 2.5),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    onPressed: () {},
                    child: Text(
                      'Resend OTP',
                      style: TextStyle(
                        letterSpacing: 1,
                        color: kBlueColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 60),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size(SizeConfig.screenWidth! * 0.33, 38),
                      backgroundColor: kWhiteColor,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: kBlueColor, width: 2.5),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    onPressed: () async {
                      Loader.show(
                        context,
                        progressIndicator: CircularProgressIndicator(),
                      );

                      try {
                        final AuthCredential credential =
                            PhoneAuthProvider.credential(
                              verificationId: verificationId,
                              smsCode: _smsCodeController,
                            );
                        auth.signInWithCredential(credential);
                        final currentUser = auth.currentUser;
                        assert(currentUser!.uid == currentUser.uid);
                        Fluttertoast.showToast(msg: "Login Successfully..!");
                        Loader.hide();
                        Navigator.pop(context, true);
                        Navigator.pop(context, true);

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => Splash(),
                          ),
                        );
                      } on FirebaseAuthException catch (err) {
                        /**The getter 'code' isn't defined for the type 'Object'.
Try importing the library that defines 'code', correcting the name to the name of an existing getter, or defining a getter or field named 'cod */
                        if (err.code == 'ERROR_INVALID_VERIFICATION_CODE') {
                          Loader.hide();
                          Fluttertoast.showToast(msg: "${err.message}");
                        } else {
                          Loader.hide();
                          Fluttertoast.showToast(msg: "${err.message}");
                        }
                      }
                    },
                    child: Text(
                      'verify'.toUpperCase(),
                      style: TextStyle(
                        letterSpacing: 2,
                        color: kWhiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget darkRoundedPinPut() {
    final defaultPinTheme = PinTheme(
      textStyle: TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: kBlueColor),
        borderRadius: BorderRadius.circular(12.0),
      ),
    );

    return Pinput(
      focusNode: _pinPutFocusNode,
      controller: _pinPutController,
      onSubmitted: (String pin) {
        setState(() {
          _smsCodeController = pin;
          print('PIN : $pin');
        });
      },
      submittedPinTheme: defaultPinTheme,
      followingPinTheme: defaultPinTheme,
      pinAnimationType: PinAnimationType.scale,
    );
  }
}
