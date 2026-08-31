import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_erp/apps/konnect/managers/email_signin_manager.dart';
import 'package:flutter_erp/apps/konnect/models/email_sign_in_model.dart';
import 'package:flutter_erp/apps/konnect/screens/chat/home_page.dart';
import 'package:flutter_erp/apps/konnect/models/phone_auth_model.dart';
import 'package:flutter_erp/apps/konnect/utils/dimensions.dart';
import 'package:flutter_erp/apps/konnect/validators/form_validator.dart';
import 'package:flutter_erp/apps/konnect/widgets/platform_exception_alert_dialog.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/colors.dart';
import '../register/register_page.dart';

class OtpPageUI extends StatefulWidget with FormValidator {
  final PhoneAuthModel model;
  OtpPageUI({Key? key, required this.model}) : super(key: key);

  @override
  _OtpPageUIState createState() => _OtpPageUIState();
}

class _OtpPageUIState extends State<OtpPageUI> {
  // ToastWidget _toast;
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  bool _isLoading = false;
  bool _isSubmitted = false;

  PhoneAuthModel get model => widget.model;
  bool _isResending = false;

  String? get otpErroText {
    bool? showErrorText = !widget.otpValidator.isValid(model.otp);
    return showErrorText ? widget.otpError : null;
  }

  TextEditingController textEditingController = TextEditingController();

  late final PinInputController pinController;

  late Dimensions myDim;

  @override
  Widget build(BuildContext context) {
    myDim = Dimensions(context);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          _timer.cancel();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: myDim.width * 0.06,
              vertical: myDim.height * 0.01,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _buildChildren(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildChildren() {
    const SizedBox spacebox = SizedBox(height: 15.0);
    return [
      _buildInfoText(),
      spacebox,
      spacebox,
      _buildOTPField(),
      spacebox,
      _isLoading
          ? Center(
              child: SizedBox(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(kColorPrimary),
                  strokeWidth: 2.0,
                ),
                height: 25.0,
                width: 25.0,
              ),
            )
          : _buildVerifyButton(),
      spacebox,
      GestureDetector(
        onTap: _counter > 0 || _isLoading ? null : _resendOtp,
        child: _isResending
            ? Center(
                child: SizedBox(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2.0,
                  ),
                  height: 25.0,
                  width: 25.0,
                ),
              )
            : Text(
                _counter > 0
                    ? 'Resend code in $_counter s.'
                    : 'Resend code now.',
                textAlign: TextAlign.center,
                textScaleFactor: myDim.textScaleFactor,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(color: Colors.white),
              ),
      ),
      spacebox,

      SizedBox(
        height: myDim.height * 0.07,
        width: double.maxFinite,
        child: OutlinedButton(
          style: ButtonStyle(
            side: WidgetStateProperty.resolveWith<BorderSide>((
              Set<WidgetState> states,
            ) {
              return const BorderSide(color: kColorPrimary);
            }),
          ),
          onPressed: _isLoading || _isResending
              ? null
              : () {
                  _timer.cancel();
                  Navigator.of(context).pop();
                },
          child: Text(
            'Reset Mobile Number',
            textScaler: TextScaler.linear(myDim.textScaleFactor),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(color: Colors.white),
          ),
        ),
      ),
    ];
  }

  TextScaler get textScaler => TextScaler.linear(myDim.textScaleFactor);

  Widget _buildInfoText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phone Number Verification',
          textScaler: textScaler,
          style: TextStyle(
            color: Colors.white,
            fontSize: myDim.width * 0.06,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: myDim.height * 0.02),
        Center(
          child: Column(
            children: [
              Text(
                'Enter the 6-digit code sent to ',
                textAlign: TextAlign.center,
                textScaler: textScaler,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: myDim.width * 0.04,
                ),
              ),
              Text(
                model.phoneNo,
                textAlign: TextAlign.center,
                textScaler: textScaler,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                  fontSize: myDim.width * 0.04,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOTPField() {
    return MaterialPinField(
      length: 6,
      pinController: pinController,

      theme: MaterialPinTheme(
        shape: MaterialPinShape.outlined,
        cellSize: const Size(40, 50),
        spacing: 8,
        borderRadius: const BorderRadius.all(Radius.circular(3)),

        focusedBorderColor: _isSubmitted ? Colors.red : Colors.grey.shade900,

        filledBorderColor: Colors.grey.shade900,

        focusedFillColor: Colors.grey.shade900,
        filledFillColor: Colors.grey.shade900,

        textStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.normal,
        ),
      ),

      keyboardType: TextInputType.number,

      onChanged: (value) {
        model.updateOtp(value);
      },

      onCompleted: (value) {
        model.updateOtp(value);
        _verifyOtp();
      },
    );
  }

  Widget _buildVerifyButton() {
    return ElevatedButton(
      onPressed: !_isLoading || _isResending ? _verifyOtp : null,
      style: ElevatedButton.styleFrom(backgroundColor: kColorPrimary),
      child: const Padding(
        padding: EdgeInsets.all(12.0),
        child: Text('Verify'),
      ),
    );
  }

  int _counter = 45;
  late Timer _timer;

  void _startTimer() {
    _counter = 45;
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  Future<void> _verifyOtp() async {
    if (!model.isValidOtp) {
      setState(() {
        _isSubmitted = true;
      });
    } else {
      setState(() {
        _isLoading = true;
      });
      try {
        AuthCredential? creds = await model.signInWithPhoneNumber();
        if (creds != null)
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => EmailSignInManager(
                type: EmailSignInFormType.signUp,
                toLink: true,
                creds: creds,
                linkType: LinkType.phone,
              ),
            ),
            (Route<dynamic> route) => false,
          );
        else {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (prefs.getString('user') != null)
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomePage()),
              ModalRoute.withName('\main'),
            );
          else
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => RegisterPage(model.userToLink!),
              ),
              ModalRoute.withName('\main'),
            );
        }
      } on PlatformException catch (e) {
        showErrorDialog(e);
      }
      _timer.cancel();
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _resendOtp() async {
    setState(() {
      _isResending = true;
      _startTimer();
    });
    try {
      await model.verifyPhoneNumber();
    } on PlatformException catch (e) {
      showErrorDialog(e);
    } finally {
      setState(() {
        _isResending = false;
      });
    }
  }

  void showErrorDialog(PlatformException e) {
    PlatfromrExceptionAlertDialog(
      title: 'Verification Failed',
      e: e,
    ).show(context);
  }

  @override
  void dispose() {
    super.dispose();
    //textEditingController.dispose();
  }
}
