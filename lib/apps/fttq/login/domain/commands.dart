
import 'package:flutter_erp/apps/fttq/login/domain/models/user.dart';
import 'package:flutter_erp/apps/fttq/fttq.dart';

import 'events.dart';
import 'store.dart';

class LoginCmd extends Command {
  final String username;

  LoginCmd(this.username);
}

class ForgotPasswordCmd extends Command {}

class LoginHandler extends CommandHandler<LoginCmd> {
  final AuthStore store;
  LoginHandler() : store = getStore<AuthStore>();

  @override
  handle(LoginCmd command) {
    if (command.username == "admin") {
      store.setUser(User("admin@admin.com", "admin"));
      fire(LoginOk());
    } else {
      fire(LoginFailed("not an admin"));
    }
  }
}
