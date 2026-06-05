import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/prospect_detail_screen.dart';
import '../config/app_config.dart';
import '../models/prospect.dart';

/// Navigation centralisée de l'application
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case AppRoutes.prospectDetail:
        final prospect = settings.arguments as ProspectData?;
        return MaterialPageRoute(
          builder: (_) => ProspectDetailScreen(prospect: prospect ?? kProspects.first),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route non trouvée: ${settings.name}')),
          ),
        );
    }
  }

  /// Navigation simple
  static void goToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.home,
      (route) => false,
    );
  }

  static void goToLogin(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  static void goToProspectDetail(BuildContext context, {required String id}) {
    Navigator.pushNamed(context, AppRoutes.prospectDetail);
  }
}
