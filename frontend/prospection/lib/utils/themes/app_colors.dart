// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

/// Couleurs extraites de la maquette ISETAG (image 3)
class AppColors {
  // ==================== COULEURS PRIMAIRES ====================
  
  /// Vert principal ISETAG - Fond du header
  static const Color primaryGreen = Color(0xFF2E7D32);
  
  /// Vert secondaire - Header gradient
  static const Color secondaryGreen = Color(0xFF1B5E20);
  
  /// Vert clair pour les accents
  static const Color lightGreen = Color(0xFF4CAF50);
  
  /// Vert très clair pour les fonds
  static const Color softGreen = Color(0xFFE8F5E9);
  
  
  // ==================== COULEURS D'ACCENT ====================
  
  /// Jaune/Orange pour les statistiques "À relancer"
  static const Color accentOrange = Color(0xFFF57F17);
  
  /// Orange pour le badge de notification
  static const Color badgeOrange = Color(0xFFE65100);
  
  /// Jaune pour le score d'intérêt
  static const Color starYellow = Color(0xFFF9A825);
  
  
  // ==================== COULEURS DE TEXTE ====================
  
  /// Texte principal - presque noir
  static const Color textPrimary = Color(0xFF1A1A1A);
  
  /// Texte secondaire - gris moyen
  static const Color textSecondary = Color(0xFF5A5A5A);
  
  /// Texte tertiaire - gris clair
  static const Color textTertiary = Color(0xFF9E9E9E);
  
  /// Texte blanc sur fond vert
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  
  /// Texte blanc 70% d'opacité
  static const Color textWhite70 = Color(0xB3FFFFFF);
  
  
  // ==================== COULEURS DE FOND ====================
  
  /// Fond blanc
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  
  /// Fond gris clair pour les cartes
  static const Color backgroundGrey = Color(0xFFF5F5F5);
  
  /// Fond vert très clair pour les statistiques
  static const Color backgroundSoftGreen = Color(0xFFE8F5E9);
  
  
  // ==================== COULEURS DE BORDURE ====================
  
  /// Bordure grise claire
  static const Color borderLight = Color(0xFFEEEEEE);
  
  /// Bordure grise moyenne
  static const Color borderMedium = Color(0xFFE0E0E0);
  
  
  // ==================== COULEURS DE STATUT ====================
  
  /// Vert pour les badges "Nouveau"
  static const Color statusNew = Color(0xFF2E7D32);
  
  /// Orange pour les badges "À relancer"
  static const Color statusPending = Color(0xFFE65100);
  
  /// Bleu pour les badges "Contacté"
  static const Color statusContacted = Color(0xFF1565C0);
  
  
  // ==================== COULEURS DE STATISTIQUES ====================
  
  /// Vert pour "Prospects ajoutés"
  static const Color statGreen = Color(0xFF2E7D32);
  
  /// Orange pour "À relancer"
  static const Color statOrange = Color(0xFFF57F17);
  
  /// Bleu pour "Visites effectuées"
  static const Color statBlue = Color(0xFF1565C0);
  
  /// Jaune pour "Nouveaux établis"
  static const Color statYellow = Color(0xFFF9A825);
  
  
  // ==================== GRADIENTS ====================
  
  /// Gradient du header
  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryGreen, secondaryGreen],
  );
  
  /// Gradient des statistiques "À relancer"
  static const LinearGradient statOrangeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF57F17), Color(0xFFEF6C00)],
  );
  
  /// Gradient des cartes prospects
  static LinearGradient getProspectGradient(int color) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(color).withOpacity(0.85),
        Color(color).withOpacity(0.55),
      ],
    );
  }
  
  
  // ==================== OMBRES ====================
  
  /// Ombre légère pour les cartes
  static List<BoxShadow> lightShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
  
  /// Ombre moyenne pour les éléments en relief
  static List<BoxShadow> mediumShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];
  
  
  // ==================== MÉTHODES UTILITAIRES ====================
  
  /// Obtenir la couleur d'un badge selon le statut
  static Color getBadgeColor(String status) {
    switch (status.toLowerCase()) {
      case 'relancer':
        return statusPending;
      case 'nouveau':
        return statusNew;
      case 'contacte':
        return statusContacted;
      default:
        return Colors.grey;
    }
  }
  
  /// Obtenir la couleur d'une statistique selon le label
  static Color getStatColor(String label) {
    switch (label) {
      case 'Prospects ajoutés':
        return statGreen;
      case 'À relancer':
        return statOrange;
      case 'Visites effectuées':
        return statBlue;
      case 'Nouveaux établis':
        return statYellow;
      default:
        return primaryGreen;
    }
  }
}