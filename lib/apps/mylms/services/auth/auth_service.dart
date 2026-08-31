import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter_erp/apps/mylms/config/env.dart';
import 'package:flutter_erp/models/user.dart' as app_user;
import 'package:flutter_erp/apps/mylms/services/auth/auth_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _userDatakey = "userdata";

  static const _headres = {
    "Content-type": "application/json",
    "Accept": "application/json",
  };

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static app_user.User? get user {
    print("User: ${_prefs}");
    final data = _prefs!.getString(_userDatakey);
    if (data == null) {
      return null;
    }
    return app_user.User.fromJson(jsonDecode(data));
  }

  static bool get isLoggedIn => user != null;

  static Future<void> login({
    required String userName,
    required String password,
  }) async {
    final url = Uri.parse("${Env.baseUrl}auth/login");

    try {
      final res = await http.post(
        url,
        body: jsonEncode({'username': userName, 'password': password}),
        headers: _headres,
      );

      if (res.statusCode != 200) {
        throw AuthException(res.body);
      }

      await _saveUser(app_user.User.fromJson(jsonDecode(res.body)));
    } on SocketException catch (e) {
      throw AuthException("Network Error");
    }
  }

  static Future<void> signup({
    required String firstName,
    required String lastName,
    required String userName,
    required String password,
  }) async {
    final url = Uri.parse("${Env.baseUrl}auth/signup/student");

    try {
      final res = await http.post(
        url,
        body: jsonEncode({
          'firstName': firstName,
          'lastName': lastName,
          'email': userName,
          'password': password,
        }),
        headers: _headres,
      );

      if (res.statusCode != 200) {
        throw AuthException(res.body);
      }
      await _saveUser(app_user.User.fromJson(jsonDecode(res.body)));
    } on SocketException catch (e) {
      throw AuthException("Network Error");
    }
  }

  static Future<void> logout() async {
    await _prefs!.remove(_userDatakey);
  }

  static Future<void> _saveUser(app_user.User user) async {
    await _prefs!.setString(_userDatakey, jsonEncode(user.toJson()));
  }
}
