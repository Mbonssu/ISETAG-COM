import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:isetagcom/services/translation_service.dart';
import 'config/app_config.dart';
import 'routes/app_router.dart';
import 'screens/splash_screen.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'models/localStorage/local_storage.dart';
import 'services/auto_sync_service.dart';
import 'services/sync_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  try {
    // Annule toutes les tâches existantes avant d'initialiser
    // UNCOMMENT THIS IF YOU'RE USING OFFLINE QUEUE
    // await OfflineQueue().cancelAll();

    // Initialize timezone before anything else
    tz.initializeTimeZones();
    final location = tz.getLocation('Africa/Lagos');
    tz.setLocalLocation(location);

    // Initialize notification service
    // await NotificationService().init();

    // Initialize translation service
    await TranslationService.init();

    // Initialize LocalStorage (Isar database)
    await LocalStorage.instance.init();

    // Initialize sync service
    await SyncService().init();

    // Initialize auto-sync service
    await AutoSyncService().init();
    
  } catch (e) {
    print('Error during initialization: $e');
    // Continue anyway - the app might still work
  }

  runApp(const IsetagApp());
}

// If you only need to sync once

class IsetagApp extends StatelessWidget {
  const IsetagApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,

      // This makes the app follow the device's language automatically
      locale: null, // null = follow system locale

      // Supported locales (add more as needed)
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('fr', ''), // French
      ],

      // These provide automatic translations for Material widgets
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.transparent,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E7D34)),
        tabBarTheme: const TabBarThemeData(
          dividerColor: Colors.transparent,
          overlayColor: WidgetStatePropertyAll(Colors.transparent),
        ),
      ),

      // Start with splash screen
      home: const SplashScreen(),
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
