/// Configuration centralisée de l'application
class AppConfig {
  // API Configuration
  static const String apiBaseUrl = 'http://192.168.30.106:8000';
  static const String sch = '/ISETAG_COM';
  static const String typeApi = '_api/';
  static const String addUsers = '.users/';
  static const String addProspect = '.prospects/';
  static const String addSpeciality = '.specialite/';
  static const String addEts = '.etablissement/';
  static const String addClasses = '.classes/';
  static const String addInteret = '.classes/';


  static const int apiTimeout = 30;

  // POST, GET
  static const String prospect = '${apiBaseUrl}prosospect$typeApi$sch$addProspect';
  static const String speciality = '${apiBaseUrl}specialite$typeApi$sch$addSpeciality';
  static const String classes = '${apiBaseUrl}classe$typeApi$sch$addClasses';
  static const String ets = '${apiBaseUrl}etablissement$typeApi$sch$addEts';
  static const String users = '${apiBaseUrl}users$typeApi$sch$addUsers';
  static const String interest = '${apiBaseUrl}interest$typeApi$sch$addInteret';


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
// class AppRoutes {
//   static const String login = '/login';
//   static const String home = '/home';
//   static const String prospectDetail = '/prospect/:id';
//   static const String settings = '/settings';
//   static const String profile = '/profile';
// }
