// ignore_for_file: constant_identifier_names

/// Configuration centralisée de l'application
class AppConfig {
  // API Configuration
  // static const String apiBaseUrl = 'http://192.168.137.243:8000/';
  // static const String apiBaseUrl = 'http://192.168.30.33:8000/';
  static const String apiBaseUrl = 'https://cake-reset-smoky.ngrok-free.dev/';
  // static const String apiBaseUrl = 'http://10.102.214.178:8000/';
  // static const String apiBaseUrl = 'http://192.168.43.234:8000/';
  static const String sch = 'ISETAG_COM';
  static const String typeApi = '_api/';
  static const String token = '';
  static const String addUsers = '.users/';
  static const String addProspect = '.prospects/';
  static const String addSpeciality = '.specialites/';
  static const String addEts = '.etablissements/';
  static const String addClasses = '.classes/';
  static const String addInteret = '.interetspecialites/';
  static const String addSrc = '.sources/';
  static const String add_fiche = '.fiches-sortie/';
  static const String addLogin = 'authentification/login/';
  static const String addLogout ='authentification/logout/';
  static const String addParticaipation ='ma-sortie-active/';
  // Endpoint dédié aux relances (prospect_api/ISETAG_COM.relances/)
  static const String addRelance = '.relances/';


  static const int apiTimeout = 30;

  // POST, GET
  static const String users = '${apiBaseUrl}users$typeApi$sch$addUsers';
  static const String src = '${apiBaseUrl}campagne$typeApi$sch$addSrc';
  static const String fiche_sortie = '${apiBaseUrl}campagne$typeApi$sch$add_fiche';
  static const String ets = '${apiBaseUrl}campagne$typeApi$sch$addEts';
  static const String classes = '${apiBaseUrl}classe$typeApi$sch$addClasses';
  static const String prospect = '${apiBaseUrl}prospect$typeApi$sch$addProspect';
  static const String speciality = '${apiBaseUrl}specialite$typeApi$sch$addSpeciality';
  static const String interest = '${apiBaseUrl}specialite$typeApi$sch$addInteret';
  static const String login = '$apiBaseUrl$addLogin';
  static const String logout = '$apiBaseUrl$addLogout';
  static const String participation = '${apiBaseUrl}campagne$typeApi$addParticaipation';
  static const String relance = '${apiBaseUrl}prospect$typeApi$sch$addRelance';


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
