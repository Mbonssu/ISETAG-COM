/// Constantes globales de l'application
class AppConstants {
  // Timing
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration shortAnimationDuration = Duration(milliseconds: 150);

  // Spacing
  static const double paddingXSmall = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  // Border radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;

  // Icon sizes
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXLarge = 48.0;

  // Font sizes
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeLarge = 16.0;
  static const double fontSizeXLarge = 20.0;
  static const double fontSizeTitle = 24.0;
  static const double fontSizeHeading = 28.0;
}

/// Messages d'erreur et de succès
class AppMessages {
  static const String errorTitle = 'Erreur';
  static const String successTitle = 'Succès';
  static const String warningTitle = 'Attention';
  static const String infoTitle = 'Information';

  // Erreurs communes
  static const String errorNetwork = 'Erreur de connexion réseau';
  static const String errorServer = 'Erreur serveur';
  static const String errorTimeout = 'Délai d\'attente dépassé';
  static const String errorUnknown = 'Une erreur inconnue s\'est produite';

  // Validation
  static const String errorEmptyField = 'Ce champ ne peut pas être vide';
  static const String errorInvalidEmail = 'Email invalide';
  static const String errorPasswordTooShort = 'Le mot de passe est trop court';
  static const String errorPasswordMismatch = 'Les mots de passe ne correspondent pas';
}
