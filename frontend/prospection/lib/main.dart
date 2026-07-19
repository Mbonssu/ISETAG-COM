import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'config/app_config.dart';
import 'provider/auth_provider.dart';
import 'routes/app_router.dart';
import 'screens/splash_screen.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz;

import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  // print("Calling healtcheck");
  // final ApiService _api = ApiService();
  // await _api.healthCheck();
  // ✅ ONLY initialize timezone here (lightweight)
  // tz.initializeTimeZones();
  // final location = tz.getLocation('Africa/Lagos');
  // tz.setLocalLocation(location);
  await NotificationService.instance.initialize();
  final authProvider = AuthProvider();
  await authProvider.init();
  //print("Generating tests data....");
  // ✅ Générer les données de test
  // await TestDataGenerator.generate500Prospects();
  // ✅ Run app immediately - splash screen shows quickly
  runApp( MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(
          value: authProvider,
        ),
      ],
      child: const IsetagApp(),
    ),);
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
      home: const SplashScreen(), //,SyncScreen(),
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
