
import 'package:flutter_erp/apps/fttq/fttq.dart';

class LoginOk extends Event {}
class LoginFailed extends Event {
  final String reason;

  LoginFailed(this.reason);
}

class EmailValidationRequired extends Event {}