import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_erp/apps/flutter_todo/models/user.dart';
import 'package:flutter_erp/apps/flutter_todo/states/auth_state.dart';

import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthNotifier extends Notifier<AuthState> {
  Timer? _authTimer;

  @override
  AuthState build() {
    return const AuthState();
  }

  // =========================
  // LOGIN
  // =========================
  Future<Map<String, dynamic>> authenticate(
    String email,
    String password,
  ) async {
    final formData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };

    try {
      final res = await Dio().post(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key={Configure.ApiKey}',
        data: json.encode(formData),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      final data = res.data is String ? json.decode(res.data) : res.data;

      if (data.containsKey('idToken')) {
        final user = User(
          id: data['localId'],
          email: data['email'],
          token: data['idToken'],
        );

        state = state.copyWith(user: user, isLoading: false);

        _setAuthTimeout(int.parse(data['expiresIn']));
        await _saveUser(data);

        return {'success': true};
      }

      return {'success': false, 'message': data['error']['message']};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // =========================
  // REGISTER
  // =========================
  Future<Map<String, dynamic>> register(String email, String password) async {
    final formData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };

    try {
      final res = await Dio().post(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key={Configure.ApiKey}',
        data: json.encode(formData),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      final data = res.data is String ? json.decode(res.data) : res.data;

      if (data.containsKey('idToken')) {
        final user = User(
          id: data['localId'],
          email: data['email'],
          token: data['idToken'],
        );

        state = state.copyWith(user: user, isLoading: false);

        _setAuthTimeout(int.parse(data['expiresIn']));
        await _saveUser(data);

        return {'success': true};
      }

      return {'success': false, 'message': data['error']['message']};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // =========================
  // LOGOUT
  // =========================
  Future<void> logout() async {
    state = state.copyWith(user: null, isLoading: false);
    ;
    _authTimer?.cancel();

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // =========================
  // AUTO AUTH
  // =========================
  Future<void> _autoAuthentication() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) return;

    final expiryString = prefs.getString('expiryTime');
    if (expiryString == null) return;

    final expiry = DateTime.parse(expiryString);

    if (expiry.isBefore(DateTime.now())) {
      state = state.copyWith(user: null, isLoading: false);
      return;
    }

    state = state.copyWith(
      user: User(
        id: prefs.getString('userId')!,
        email: prefs.getString('email')!,
        token: token,
      ),
      isLoading: false,
    );

    _setAuthTimeout(expiry.difference(DateTime.now()).inSeconds);
  }

  // =========================
  // REFRESH TOKEN
  // =========================
  Future<void> tryRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refreshToken');

    if (refreshToken == null) return logout();

    final formData = {
      'grant_type': 'refresh_token',
      'refresh_token': refreshToken,
    };

    try {
      final res = await Dio().post(
        'https://securetoken.googleapis.com/v1/token?key={Configure.ApiKey}',
        data: json.encode(formData),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      final data = res.data is String ? json.decode(res.data) : res.data;

      if (data.containsKey('id_token')) {
        state = state.copyWith(
          user: User(
            id: prefs.getString('userId')!,
            email: prefs.getString('email')!,
            token: data['id_token'],
          ),
          isLoading: false,
        );

        _setAuthTimeout(int.parse(data['expires_in']));

        final expiry = DateTime.now().add(
          Duration(seconds: int.parse(data['expires_in'])),
        );

        prefs.setString('token', data['id_token']);
        prefs.setString('expiryTime', expiry.toIso8601String());
        prefs.setString('refreshToken', data['refresh_token']);

        return;
      }

      logout();
    } catch (_) {
      logout();
    }
  }

  // =========================
  // HELPERS
  // =========================
  void _setAuthTimeout(int seconds) {
    _authTimer?.cancel();
    _authTimer = Timer(Duration(seconds: seconds), tryRefreshToken);
  }

  Future<void> _saveUser(Map<String, dynamic> data) async {
    final expiry = DateTime.now().add(
      Duration(seconds: int.parse(data['expiresIn'])),
    );

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('userId', data['localId']);
    await prefs.setString('email', data['email']);
    await prefs.setString('token', data['idToken']);
    await prefs.setString('refreshToken', data['refreshToken']);
    await prefs.setString('expiryTime', expiry.toIso8601String());
  }
}
