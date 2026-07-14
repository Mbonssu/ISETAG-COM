import 'package:flutter/material.dart';
import 'package:isetagcom/models/prospectData.dart';
import 'package:isetagcom/screens/add_prospect_screen.dart';
import 'package:isetagcom/screens/forgot_password.dart';
import 'package:isetagcom/screens/prospect_detail_screen.dart';
import 'package:isetagcom/screens/fiche_list_screen.dart';
import 'package:isetagcom/screens/register_screen.dart';
import 'package:isetagcom/screens/relances_screen.dart';
// import '../screens/fiche_detail_screen.dart';
import '../models/fiche.dart';
import '../screens/fiche_detail_screen.dart';
import '../screens/fiche_preview_screen.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/prospects_list_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/sync_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String prospects = '/prospects';
  static const String prospectDetails = '/prospect-details';
  static const String fiches = '/fiches';
  static const String ficheDetail = '/fiche-detail';
  static const String addProspect = '/add-prospect';
  static const String settings = '/settings';
  static const String relances = '/relances';
  static const String preview_fiche = '/preview';
  static const String prospectsList = '/prospects-list';
  static const String syncRoute = '/sync';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case AppRoutes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());

      case AppRoutes.addProspect:
        return MaterialPageRoute(builder: (_) => const AddProspectScreen());

      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());

      case AppRoutes.fiches:
        return MaterialPageRoute(builder: (_) => const FicheListScreen());

      case AppRoutes.relances:
        return MaterialPageRoute(builder: (_) => const RelancesScreen());

      case AppRoutes.ficheDetail:
        final args = settings.arguments as Map<String, dynamic>;
        final ficheId = args['ficheId'] as String;
        return MaterialPageRoute(
          builder: (_) => FicheDetailScreen(ficheId: ficheId),
        );

      case AppRoutes.prospectDetails:
        final args = settings.arguments as ProspectDetails;
        // final ficheId = args['ficheId'] as String;
        return MaterialPageRoute(
          builder: (_) => ProspectDetailScreen(
            prospect: args,
          ),
        );

      case AppRoutes.preview_fiche:
        final args = settings.arguments as Map<String, dynamic>;

        // Extract both arguments using the exact types required by FichePreviewScreen
        final fiche = args['fiche'] as Fiche;
        final prospectsList = args['prospectsList'] as List<ProspectDetails>;

        return MaterialPageRoute(
          builder: (_) => FichePreviewScreen(
            fiche: fiche,
            prospectsList: prospectsList,
          ),
        );

      case AppRoutes.prospectsList:
        final args = settings.arguments as Map<String, dynamic>;

        // Extract both arguments using the exact types required by FichePreviewScreen
        final prospectsList = args['prospectsList'] as List<ProspectDetails>;

        return MaterialPageRoute(
          builder: (_) => ProspectsListScreen(allProspects: prospectsList),
        );

      case AppRoutes.syncRoute:
        return MaterialPageRoute(
          builder: (_) => const SyncScreen(),
        );
      // case AppRoutes.fiches:
      //   return MaterialPageRoute(builder: (_) => const FicheListScreen());

      // case AppRoutes.ficheDetail:
      //   final args = settings.arguments as Map<String, dynamic>;
      //   return MaterialPageRoute(
      //     builder: (_) => FicheDetailScreen(fiche: args['fiche']),
      //   );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route not found: ${settings.name}'),
            ),
          ),
        );
    }
  }
}
