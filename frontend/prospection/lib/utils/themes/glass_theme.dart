import 'dart:ui';
import 'package:flutter/material.dart';

// ─── Palette ISETAG Liquid Glass (mode clair) ───────────────────────────────
class G {
  // Couleurs blanches personnalisées
  static const Color white18 = Color(0x2DFFFFFF);
  static const Color white15 = Color(0x26FFFFFF);

  // Fond dégradé principal de chaque page
  static const Gradient pageBg = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFD4EEDA), Color(0xFFB8E2C4), Color(0xFFCCE8D8), Color(0xFFD8EFC0)],
    stops: [0.0, 0.3, 0.65, 1.0],
  );

  // Couleurs de marque
  static const Color green        = Color(0xFF1E7D34);
  static const Color greenDark    = Color(0xFF0E501E);
  static const Color greenLight   = Color(0xFF2E9D46);
  static const Color yellow       = Color(0xFFF5C518);

  // Texte
  static const Color textDark     = Color(0xFF1A1A1A);
  static const Color textMedium   = Color(0xFF5A5A5A);
  static const Color textLight    = Color(0xFF9E9E9E);

  // Surfaces verre
  static const Color glassCard    = Color(0x73FFFFFF); // 45%
  static const Color glassInput   = Color(0x8CFFFFFF); // 55%
  static const Color glassStat    = Color(0x7AFFFFFF); // 48%
  static const Color glassBorder  = Color(0xA6FFFFFF); // 65%
  static const Color glassDivider = Color(0x0F000000); // 6%

  // Header vert glass
  static const Color headerBg     = Color(0xBF1E7D34); // 75%
  static const Color headerBorder = Color(0x33FFFFFF);

  // Bouton primaire vert glass
  static const Color btnPrimaryBg     = Color(0xE01E7D34);
  static const Color btnPrimaryBorder = Color(0x6650DC64);
  static const Color btnOutlineBorder = Color(0x8C1E7D34);

  // Bottom nav
  static const Color navBg     = Color(0xA6FFFFFF);
  static const Color navBorder = Color(0xCCFFFFFF);

  // Badges
  static const Color badgeRelancerBg   = Color(0x33FF7828);
  static const Color badgeRelancerText = Color(0xFFC45000);
  static const Color badgeRelancerBdr  = Color(0x4DFF7828);

  static const Color badgeNouveauBg    = Color(0x261E7D34);
  static const Color badgeNouveauText  = Color(0xFF1E7D34);
  static const Color badgeNouveauBdr   = Color(0x4D1E7D34);

  static const Color badgeContacteBg   = Color(0x261565C0);
  static const Color badgeContacteText = Color(0xFF1565C0);
  static const Color badgeContacteBdr  = Color(0x401565C0);

  static const Color badgeYellowBg     = Color(0xE6F5C518);
  static const Color badgeYellowText   = Color(0xFF7A4F00);
  static const Color badgeYellowBdr    = Color(0x80C89B00);
}

// ─── Widget de fond page ──────────────────────────────────────────────────────
class PageBackground extends StatelessWidget {
  final Widget child;
  const PageBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: G.pageBg),
      child: Stack(children: [
        // blob haut-gauche vert
        Positioned(
          top: -50, left: -40,
          child: _Blob(size: 200, color: G.green.withValues(alpha: 0.18)),
        ),
        // blob bas-droite jaune
        Positioned(
          bottom: 80, right: -30,
          child: _Blob(size: 160, color: G.yellow.withValues(alpha: 0.20)),
        ),
        // blob milieu-droite vert
        Positioned(
          top: 260, right: 10,
          child: _Blob(size: 100, color: G.green.withValues(alpha: 0.12)),
        ),
        child,
      ]),
    );
  }
}

class _Blob extends StatelessWidget {
  final double size;
  final Color color;
  const _Blob({required this.size, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    width: size, height: size,
    decoration: BoxDecoration(shape: BoxShape.circle,
      gradient: RadialGradient(colors: [color, Colors.transparent]),
    ),
  );
}

// ─── GlassBox : widget générique ─────────────────────────────────────────────
class GlassBox extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final double blur;
  final Color bgColor;
  final Color borderColor;
  final List<BoxShadow>? shadows;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  const GlassBox({
    super.key,
    required this.child,
    this.borderRadius = 14,
    this.padding,
    this.blur = 16,
    this.bgColor = G.glassCard,
    this.borderColor = G.glassBorder,
    this.shadows,
    this.width,
    this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget box = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width, height: height, padding: padding,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: shadows ?? [
              BoxShadow(color: Colors.black.withValues(alpha: 0.07),
                  blurRadius: 20, offset: const Offset(0, 4)),
              BoxShadow(color: Colors.white.withValues(alpha: 0.8),
                  blurRadius: 0, offset: const Offset(0, 1)),
            ],
          ),
          child: child,
        ),
      ),
    );
    if (onTap != null) return GestureDetector(onTap: onTap, child: box);
    return box;
  }
}

/// Widget helper pour afficher un badge de statut
/// Utilise des strings pour rester indépendant de l'import de models
class StatusBadge extends StatelessWidget {
  final String status;
  
  const StatusBadge({super.key, required this.status});

  Color get _backgroundColor {
    return switch(status.toLowerCase()) {
      'relancer' => G.badgeRelancerBg,
      'nouveau' => G.badgeNouveauBg,
      'contacte' => G.badgeContacteBg,
      _ => Colors.grey.withValues(alpha: 0.3),
    };
  }

  Color get _textColor {
    return switch(status.toLowerCase()) {
      'relancer' => G.badgeRelancerText,
      'nouveau' => G.badgeNouveauText,
      'contacte' => G.badgeContacteText,
      _ => Colors.grey,
    };
  }

  Color get _borderColor {
    return switch(status.toLowerCase()) {
      'relancer' => G.badgeRelancerBdr,
      'nouveau' => G.badgeNouveauBdr,
      'contacte' => G.badgeContacteBdr,
      _ => Colors.grey.withValues(alpha: 0.5),
    };
  }

  String get _label {
    return switch(status.toLowerCase()) {
      'relancer' => 'À relancer',
      'nouveau' => 'Nouveau',
      'contacte' => 'Contacté',
      _ => status,
    };
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
          decoration: BoxDecoration(
            color: _backgroundColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _borderColor),
          ),
          child: Text(
            _label,
            style: TextStyle(
              fontSize: 10,
              color: _textColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
