// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:isetagcom/models/source.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/fiche.dart';
import '../models/initializer.dart';
import '../models/localStorage/local_storage.dart';
import '../routes/app_router.dart';
import '../services/translation_service.dart';
import '../utils/status.dart';
import '../services/sync_service.dart';
import '../services/auto_sync_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  String _loadingMessage = 'Initialisation...';
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();

    // Start animations immediately
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();

    //  Initialize app in background
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Step 1: Initialize LocalStorage
      _updateProgress('Initialisation de la base de données...', 0.2);
      await LocalStorage.instance.init();

      // Step 2: Initialize Translation
      _updateProgress('Chargement des traductions...', 0.4);
      await TranslationService.init();

      // Step 3: Initialize Sync Service (async, don't block)
      _updateProgress('Initialisation du service de synchronisation...', 0.6);
      await SyncService().init();

      // Step 4: Initialize Auto-Sync Service (async, don't block)
      _updateProgress(
          'Initialisation de la synchronisation automatique...', 0.8);
      await AutoSyncService().init();

      // Step 5: Set source and fiche
      _updateProgress('Préparation des données...', 0.9);
      await setSource_fiche();

      // Step 6: Check login status
      _updateProgress('Vérification de la session...', 1.0);
      await _navigateToNextScreen();
    } catch (e) {
      print('Error during initialization: $e');
      // Even if there's an error, navigate to home
      await _navigateToNextScreen();
    }
  }

  void _updateProgress(String message, double progress) {
    if (mounted) {
      setState(() {
        _loadingMessage = message;
        _progress = progress;
      });
    }
  }

  Future<void> setSource_fiche() async {
    try {
      // Check if source already exists
      final existingSource =
          await LocalStorage.instance.getSourceByLabel('Sur le terrain');

      if (existingSource != null) {
        // Source exists, check if fiche exists
        final existingFiche = await LocalStorage.instance.getLastRecFiche();
        if (existingFiche != null) {
          return; // Already set up
        }
      }

      // Create new source and fiche
      final source = Source(
        idSource: 'source_${DateTime.now().millisecondsSinceEpoch}',
        libelleSource: 'Sur le terrain',
        createdAt: DateTime.now(),
        syncState: SyncState.pending,
      );

      final fiche = Fiche(
        idFiche: 'fiche_${DateTime.now().millisecondsSinceEpoch}',
        idSrc: source.idSource,
        dateCollecte: DateTime.now(),
        createdAt: DateTime.now(),
        isCurrent: true,
        syncState: SyncState.pending,
      );

      final init = Initializer(src: source, fiche: fiche);
      init.setSourceAndFiche();
    } catch (e) {
      print('Error setting source and fiche: $e');
    }
  }

  Future<void> _navigateToNextScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

    if (mounted) {
      // Use a small delay to ensure the loading message is visible
      await Future.delayed(const Duration(milliseconds: 500));

      if (isLoggedIn) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      } else {
        // For now, always go to home
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        // Navigator.of(context).pushReplacementNamed(AppRoutes.login);
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2E7D32),
              Color(0xFF1B5E20),
              Color(0xFF0A3D13),
            ],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //  Image with rounded borders - No orange container
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                          image: const DecorationImage(
                            image: AssetImage('assets/images/app_icon.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'ISETAG',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Prospection & Communication',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Progress indicator with message
                      Column(
                        children: [
                          SizedBox(
                            width: 200,
                            child: LinearProgressIndicator(
                              value: _progress,
                              backgroundColor: Colors.white24,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFFF9A825),
                              ),
                              minHeight: 4,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _loadingMessage,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
