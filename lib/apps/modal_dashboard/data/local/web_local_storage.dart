import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/local_storage_constant.dart';

class WebLocalStorageHelper {
  WebLocalStorageHelper._();

  static final WebLocalStorageHelper instance = WebLocalStorageHelper._();

  factory WebLocalStorageHelper() => instance;

  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  /// Elimina tanto preferencias comunes como tokens.
  Future<void> clearLocalStorage() async {
    await Future.wait([_preferences.clear(), _secureStorage.deleteAll()]);
  }

  Future<void> saveInternetState({required bool available}) async {
    await _preferences.setBool(LocalStorage.internetStateKey, available);
  }

  Future<bool> getInternetState() async {
    return await _preferences.getBool(LocalStorage.internetStateKey) ?? false;
  }

  Future<void> saveLoginState({required bool login}) async {
    await _preferences.setBool(LocalStorage.logInStateKey, login);
  }

  Future<bool> getLoginState() async {
    return await _preferences.getBool(LocalStorage.logInStateKey) ?? false;
  }

  Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(key: LocalStorage.accessTokenKey, value: token);
  }

  Future<String?> getAccessToken() async {
    return _secureStorage.read(key: LocalStorage.accessTokenKey);
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    await _secureStorage.write(
      key: LocalStorage.refreshTokenKey,
      value: refreshToken,
    );
  }

  Future<String?> getRefreshToken() async {
    return _secureStorage.read(key: LocalStorage.refreshTokenKey);
  }

  Future<void> saveTokenExpiryTime(int timestamp) async {
    await _preferences.setInt(LocalStorage.tokenExpiryKey, timestamp);
  }

  Future<int?> getTokenExpiryTime() async {
    return _preferences.getInt(LocalStorage.tokenExpiryKey);
  }

  Future<void> clearAuthenticationData() async {
    await Future.wait([
      _preferences.remove(LocalStorage.logInStateKey),
      _preferences.remove(LocalStorage.tokenExpiryKey),
      _secureStorage.delete(key: LocalStorage.accessTokenKey),
      _secureStorage.delete(key: LocalStorage.refreshTokenKey),
    ]);
  }

  Future<bool> hasValidAccessToken() async {
    final accessToken = await getAccessToken();
    final expiryTimestamp = await getTokenExpiryTime();

    if (accessToken == null || accessToken.isEmpty || expiryTimestamp == null) {
      return false;
    }

    final currentTimestamp = DateTime.now().millisecondsSinceEpoch;

    return currentTimestamp < expiryTimestamp;
  }
}
