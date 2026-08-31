import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/konnect/models/phone_auth_model.dart';
import 'package:provider/provider.dart';

import '../misc/phone_login_ui.dart';

class PhoneLoginPage extends StatelessWidget {
  final PhoneAuthModel model;

  const PhoneLoginPage({super.key, required this.model});

  static Widget create() {
    return ChangeNotifierProvider<PhoneAuthModel>(
      create: (_) =>
          PhoneAuthModel(userToLink: null, type: PhoneAuthType.login),
      child: Consumer<PhoneAuthModel>(
        builder: (context, model, _) {
          return PhoneLoginPage(model: model);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Sign In'),
      ),
      body: PhoneLoginUI(model),
    );
  }
}
