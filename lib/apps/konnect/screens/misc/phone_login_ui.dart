import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter_erp/apps/konnect/managers/email_signin_manager.dart';
import 'package:flutter_erp/apps/konnect/models/email_sign_in_model.dart';
import 'package:flutter_erp/apps/konnect/models/phone_auth_model.dart';
import 'package:flutter_erp/apps/konnect/widgets/platform_alert_dialog.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import 'otp_page_ui.dart';

class PhoneLoginUI extends StatefulWidget {
  final PhoneAuthModel model;
  const PhoneLoginUI(this.model);
  @override
  _PhoneLOginUIState createState() => _PhoneLOginUIState();
}

class _PhoneLOginUIState extends State<PhoneLoginUI> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late Dimensions myDim;
  PhoneAuthModel get model => widget.model;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    myDim = Dimensions(context);
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: myDim.width * 0.04,
            vertical: myDim.height * 0.01,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _buildChildren(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildChildren() {
    return [
      model.type == PhoneAuthType.login
          ? _welcomeText()
          : SizedBox(height: 30.0),
      Text(
        'Enter your phone number',
        style: Theme.of(
          context,
        ).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 10.0),
      _buildPhoneField(),
      SizedBox(height: 20),
      _buildInfoText(),
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
          : ElevatedButton(
              onPressed: model.canSubmit ? _submit : null,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) => kColorPrimary,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('Continue'),
              ),
            ),
    ];
  }

  Column _welcomeText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10.0),
        Text(
          'Welcome back!',
          style: Theme.of(
            context,
          ).textTheme.displayLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 3.0),
        Text(
          'Sign in to your account',
          style: Theme.of(
            context,
          ).textTheme.titleSmall!.copyWith(color: Colors.grey),
        ),
        const SizedBox(height: 30.0),
      ],
    );
  }

  Widget _buildPhoneField() {
    final initialNumber = PhoneNumber(isoCode: 'IN', dialCode: '+91');

    return SizedBox(
      height: myDim.height * 0.06,
      child: InternationalPhoneNumberInput(
        initialValue: initialNumber,
        selectorConfig: const SelectorConfig(
          selectorType: PhoneInputSelectorType.DIALOG,
        ),
        onInputChanged: (PhoneNumber number) {
          final phone = number.phoneNumber;

          if (phone != null) {
            model.updatePhone(phone);
          }
        },
        inputDecoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade900),
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: kColorPrimary),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoText() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        'A 6-digit code will be sent by SMS to confirm your phone number.',
        textAlign: TextAlign.center,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium!.copyWith(color: Colors.grey),
      ),
    );
  }

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await model.verifyPhoneNumber();

      if (!mounted) return;

      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (ctx) => OtpPageUI(model: model)));
    } on PlatformException catch (e) {
      if (!mounted) return;

      await PlatformAlertDialog(
        title: 'Failed to verify Phone number',
        content: e.message ?? 'An unexpected error occurred.',
        defaultActionText: 'OK',
      ).show(context);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
