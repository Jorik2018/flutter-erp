import 'package:flutter_erp/models/user.dart' as app_user;
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
      store.setUser(app_user.User(email: "admin@admin.com", name: "admin"));
      fire(LoginOk());
    } else {
      fire(LoginFailed("not an admin"));
    }
  }
}
