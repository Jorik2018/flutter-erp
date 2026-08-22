abstract final class Environment {
  static const String apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://localhost:3000',
  );

  static const String appEnv = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'development',
  );

  static const bool debug = bool.fromEnvironment('DEBUG', defaultValue: false);

  static bool get isProduction => appEnv == 'production';
}
