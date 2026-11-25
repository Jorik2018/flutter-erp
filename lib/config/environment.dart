abstract final class Env {
  static const String apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://localhost:3000',
  );

  static const String appEnv = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'development',
  );

  static const String oauthClientId = String.fromEnvironment('OAUTH_CLIENT_ID');

  static const bool debug = bool.fromEnvironment('DEBUG', defaultValue: false);

  static bool get isProduction => appEnv == 'production';
}
