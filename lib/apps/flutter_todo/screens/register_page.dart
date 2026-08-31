import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_erp/apps/flutter_todo/widgets/ui_elements/loading_modal.dart';
import 'package:flutter_erp/apps/flutter_todo/helpers/message_dialog.dart';
import 'package:flutter_erp/apps/flutter_todo/widgets/ui_elements/rounded_button.dart';
import 'package:flutter_erp/apps/flutter_todo/states/auth_provider.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final Map<String, dynamic> _formData = {'email': null, 'password': null};

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _register() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    _formKey.currentState!.save();

    final result = await ref
        .read(authProvider.notifier)
        .register(_formData['email'], _formData['password']);

    if (result['success']) {
      if (mounted) Navigator.pop(context);
    } else {
      MessageDialog.show(context, message: result['message']);
    }
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Email'),
      validator: (value) {
        if (value == null ||
            value.isEmpty ||
            !RegExp(
              r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?",
            ).hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
      onSaved: (value) => _formData['email'] = value,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      obscureText: true,
      controller: _passwordController,
      decoration: const InputDecoration(labelText: 'Password'),
      validator: (value) {
        if (value == null || value.isEmpty || value.length < 6) {
          return 'Please enter valid password';
        }
        return null;
      },
      onSaved: (value) => _formData['password'] = value,
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      obscureText: true,
      decoration: const InputDecoration(labelText: 'Confirm Password'),
      validator: (value) {
        if (value != _passwordController.text) {
          return 'Password and confirm password do not match';
        }
        return null;
      },
    );
  }

  Widget _buildButtonRow() {
    final state = ref.watch(authProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RoundedButton(
          icon: const Icon(Icons.edit),
          label: 'Register',
          onPressed: state!.isLoading ? null : _register,
        ),
      ],
    );
  }

  Widget _buildPageContent() {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550 ? 500 : deviceWidth * 0.85;

    return Scaffold(
      appBar: AppBar(
        title: Text('Configure.AppName'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: targetWidth,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildEmailField(),
                    _buildPasswordField(),
                    _buildConfirmPasswordField(),
                    const SizedBox(height: 20),
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
    final state = ref.watch(authProvider);

    return Stack(
      children: [_buildPageContent(), if (state!.isLoading) LoadingModal()],
    );
  }
}
