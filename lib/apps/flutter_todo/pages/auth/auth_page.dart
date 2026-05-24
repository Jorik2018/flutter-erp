import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_erp/apps/flutter_todo/.env.dart';
import 'package:flutter_erp/apps/flutter_todo/widgets/ui_elements/loading_modal.dart';
import 'package:flutter_erp/apps/flutter_todo/widgets/helpers/message_dialog.dart';
import 'package:flutter_erp/apps/flutter_todo/states/auth_provider.dart';
import 'package:flutter_erp/apps/flutter_todo/widgets/ui_elements/rounded_button.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  final Map<String, dynamic> _formData = {'email': null, 'password': null};

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _authenticate() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final result = await ref
        .read(authProvider.notifier)
        .authenticate(_formData['email'], _formData['password']);

    if (!result['success']) {
      MessageDialog.show(context, message: result['message']);
    }
  }

  Widget _buildButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RoundedButton(
          icon: const Icon(Icons.edit),
          label: 'Register',
          onPressed: () {
            Navigator.pushNamed(context, '/register');
          },
        ),
        const SizedBox(width: 20),
        RoundedButton(
          icon: const Icon(Icons.lock_open),
          label: 'Login',
          onPressed: _authenticate,
        ),
      ],
    );
  }

  Widget _buildPageContent() {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550 ? 500 : deviceWidth * 0.85;

    return Scaffold(
      appBar: AppBar(
        title: Text(Configure.AppName),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: targetWidth,
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _buildEmailField(),
                    _buildPasswordField(),
                    SizedBox(height: 20.0),
                    _buildButtonRow(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Stack(
      children: [_buildPageContent(), if (authState!.isLoading) LoadingModal()],
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Email'),
      validator: (value) {
        if (value!.isEmpty ||
            !RegExp(
              r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?",
            ).hasMatch(value)) {
          return 'Please enter a valid email';
        }

        return null;
      },
      onSaved: (value) {
        _formData['email'] = value;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(labelText: 'Password'),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter password';
        }

        return null;
      },
      onSaved: (value) {
        _formData['password'] = value;
      },
    );
  }
}
