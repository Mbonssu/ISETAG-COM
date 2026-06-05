/// Configuration centralisée de l'application
class AppConfig {
  // API Configuration
  static const String apiBaseUrl = 'http://localhost:8000/api';
  static const String apiTimeout = '30s';

  // App Configuration
  static const String appName = 'ISETAG Prospection';
  static const String appVersion = '1.0.0';

  // Feature flags
  static const bool enableDebugMode = true;
  static const bool enableLogging = true;

  // Database
  static const String databaseName = 'isetag_prospection.db';

  // Validation Rules
  static const int minPasswordLength = 8;
  static const int minNameLength = 2;
  static const int maxNameLength = 100;
}

/// Routes de l'application
class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String prospectDetail = '/prospect/:id';
  static const String settings = '/settings';
  static const String profile = '/profile';
}
