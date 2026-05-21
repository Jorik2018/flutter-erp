

import 'package:flutter_erp/apps/fttq/login/domain/models/user.dart';
import 'package:flutter_erp/apps/fttq/fttq.dart';

class AuthStore extends Store {
  User? _user;

  setUser(User newUser) => _user = newUser;
  get user => _user;
}