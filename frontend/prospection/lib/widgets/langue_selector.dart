import 'package:flutter/material.dart';
import 'package:isetagcom/services/translation_service.dart';

import '../screens/splash_screen.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language, color: Colors.white),
      onSelected: (Locale locale) async {
        await TranslationService.setLocale(locale);
        // Recharger l'app pour appliquer la langue
        if (context.mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const SplashScreen()),
          );
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: Locale('fr', 'FR'),
          child: Row(
            children: [
              Icon(Icons.flag, color: Colors.blue),
              SizedBox(width: 8),
              Text('Français'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: Locale('en', 'US'),
          child: Row(
            children: [
              Icon(Icons.flag, color: Colors.red),
              SizedBox(width: 8),
              Text('English'),
            ],
          ),
        ),
      ],
    );
  }
}