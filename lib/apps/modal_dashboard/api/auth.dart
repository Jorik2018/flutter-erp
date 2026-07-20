import 'package:dio/dio.dart';

import '../env/config_base.dart';
import '../models/models.dart';
import '../utils/dio_error_util.dart';

class AuthApi {
  AuthApi() {
    _dio.options.contentType = 'application/x-www-form-urlencoded';
    _dio.options.baseUrl = '${AppConfig.authEndpoint}/$_apiVersion';
    _dio.interceptors.add(LogInterceptor());
  }

  static const _apiVersion = 'v1';

  final _dio = Dio();

  Future<Token> generateToken(TokenRequest tokenRequest) {
    return Future.delayed(
      const Duration(seconds: 2),
      () => Token(
        accessToken: 'accessToken',
        tokenType: 'tokenType',
        expiresAt: 71237012830128,
        refreshToken: 'expiresAt',
      ),
    );
  }

  Future<Token> generateTokenFromRefreshToken(
    RefreshTokenRequest request,
  ) async {
    return Future.delayed(
      const Duration(seconds: 2),
      () => Token(
        accessToken: 'accessToken',
        tokenType: 'tokenType',
        expiresAt: 71237012830128,
        refreshToken: 'expiresAt',
      ),
    );
  }

  Future<GenericResponse> recoverPassword(String email) async {
    await Future.delayed(const Duration(seconds: 2));

    return GenericResponse(success: true);
  }
}
