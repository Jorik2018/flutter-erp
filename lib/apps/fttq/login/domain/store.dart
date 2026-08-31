import 'package:flutter_erp/models/user.dart' as app_user;
import 'package:flutter_erp/apps/fttq/fttq.dart';

class AuthStore extends Store {
  app_user.User? _user;

  setUser(app_user.User newUser) => _user = newUser;
  get user => _user;
}
