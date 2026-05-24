import 'package:flutter/material.dart';
import 'package:flutter_erp/states/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            ref.read(authProvider.notifier).login();
            context.go("/home");
          },
          child: const Text("LOGIN"),
        ),
      ),
    );
  }
}