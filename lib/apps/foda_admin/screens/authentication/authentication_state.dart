import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/foda_admin/components/base_state.dart';
import 'package:flutter_erp/apps/foda_admin/constant/route_name.dart';
import 'package:flutter_erp/apps/foda_admin/models/result.dart';
import 'package:flutter_erp/apps/foda_admin/repositories/user_repository.dart';
import 'package:flutter_erp/apps/foda_admin/services/get_it.dart';
import 'package:flutter_erp/apps/foda_admin/services/navigation_service.dart';

class AuthenticationState extends BaseState {
  final UserRepository userRepository = locate<UserRepository>();
  final NavigationService navigationService = locate<NavigationService>();

  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  AuthenticationState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();

    emailController.addListener(notifier);
    passwordController.addListener(notifier);
  }

  bool get emailIsValid {
    final email = emailController.text.trim();
    return email.isNotEmpty && email.contains("@");
  }

  @override
  void dispose() {
    emailController.removeListener(notifier);
    passwordController.removeListener(notifier);
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void notifier() {
    notifyListeners();
  }

  Future<void> login() async {
    if (isLoading) return;

    setLoading(true);

    final result = await userRepository.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    if (result case Success()) {
      emailController.clear();
      passwordController.clear();
      navigatePushReplaceName(overview);
    } else if (result case Failure(error: final error)) {
      final context = navigationService.navigatorKey.currentContext;
      if (context != null) {
        await showDialog<void>(
          context: context,
          builder: (_) => CupertinoAlertDialog(
            title: const Text("An error occurred"),
            content: Text(error.message),
          ),
        );
      }
    }

    setLoading(false);
  }
}
