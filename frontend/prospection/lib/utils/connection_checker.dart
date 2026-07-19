// // // // lib/utils/connection_checker.dart
// // // import 'dart:async';
// // // import 'package:connectivity_plus/connectivity_plus.dart';
// // // // import 'package:http/http.dart' as http;
// // // import 'package:isetagcom/services/api_service.dart';

// // // class ConnectionChecker {
// // //   static final ConnectionChecker _instance = ConnectionChecker._internal();
// // //   factory ConnectionChecker() => _instance;
// // //   ConnectionChecker._internal();

// // //   final Connectivity _connectivity = Connectivity();
// // //   final ApiService _api = ApiService();
  
// // //   bool _hasConnection = false;
// // //   bool _isApiReachable = false;
  
// // //   // Stream for connection status changes
// // //   final _connectionController = StreamController<bool>.broadcast();
// // //   Stream<bool> get connectionStream => _connectionController.stream;
  
// // //   // Stream for API reachability changes
// // //   final _apiReachableController = StreamController<bool>.broadcast();
// // //   Stream<bool> get apiReachableStream => _apiReachableController.stream;

// // //   // Getters
// // //   bool get hasConnection => _hasConnection;
// // //   bool get isApiReachable => _isApiReachable;
// // //   bool get isConnected => _hasConnection && _isApiReachable;

// // //   // Initialize the checker
// // //   Future<void> init() async {
// // //     // Check initial connection
// // //     await _checkConnection();
    
// // //     // Listen to connectivity changes
// // //     _connectivity.onConnectivityChanged.listen((results) {
// // //       _checkConnection();
// // //     });
// // //   }

// // //   // Check connection status
// // //   Future<void> _checkConnection() async {
// // //     try {
// // //       final results = await _connectivity.checkConnectivity();
// // //       final bool wasConnected = _hasConnection;
// // //       final bool wasApiReachable = _isApiReachable;
      
// // //       // Check if any connection exists
// // //       _hasConnection = results.any((r) => r != ConnectivityResult.none);
      
// // //       // If we have connection, check API
// // //       if (_hasConnection) {
// // //         _isApiReachable = await _checkApiHealth();
// // //       } else {
// // //         _isApiReachable = false;
// // //       }
      
// // //       // Notify listeners if status changed
// // //       if (wasConnected != _hasConnection) {
// // //         _connectionController.add(_hasConnection);
// // //       }
      
// // //       if (wasApiReachable != _isApiReachable) {
// // //         _apiReachableController.add(_isApiReachable);
// // //       }
      
// // //       print('🌐 Connection: ${_hasConnection ? 'ONLINE' : 'OFFLINE'}');
// // //       print('📡 API: ${_isApiReachable ? 'REACHABLE' : 'NOT REACHABLE'}');
      
// // //     } catch (e) {
// // //       print('⚠️ Connection check error: $e');
// // //       _hasConnection = false;
// // //       _isApiReachable = false;
// // //     }
// // //   }

// // //   // Check if API is reachable
// // //   Future<bool> _checkApiHealth() async {
// // //     try {
// // //       final result = await _api.healthCheck();
// // //       return result['success'] == true;
// // //     } catch (e) {
// // //       print('⚠️ API health check failed: $e');
// // //       return false;
// // //     }
// // //   }

// // //   // Quick check for internet connection
// // //   Future<bool> hasInternet() async {
// // //     try {
// // //       final results = await _connectivity.checkConnectivity();
// // //       return results.any((r) => r != ConnectivityResult.none);
// // //     } catch (e) {
// // //       return false;
// // //     }
// // //   }

// // //   // Quick check for API reachability
// // //   Future<bool> isApiCanBeReached() async {
// // //     if (!await hasInternet()) return false;
// // //     return await _checkApiHealth();
// // //   }

// // //   // Check both connection and API
// // //   Future<bool> isFullyConnected() async {
// // //     if (!await hasInternet()) return false;
// // //     return await isApiCanBeReached();
// // //   }

// // //   // Dispose
// // //   void dispose() {
// // //     _connectionController.close();
// // //     _apiReachableController.close();
// // //   }
// // // }



// // import 'dart:async';
// // import 'package:connectivity_plus/connectivity_plus.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:isetagcom/services/api_service.dart';

// // class ConnectionChecker {
// //   static final ConnectionChecker _instance = ConnectionChecker._internal();
// //   factory ConnectionChecker() => _instance;
// //   ConnectionChecker._internal();

// //   final Connectivity _connectivity = Connectivity();
// //   final ApiService _api = ApiService();
  
// //   bool _hasConnection = false;
// //   bool _isApiReachable = false;
  
// //   // Cache mechanism to prevent spamming the health check
// //   DateTime _lastApiCheckTime = DateTime.now().subtract(const Duration(minutes: 5));
// //   static const Duration API_CHECK_COOLDOWN = Duration(seconds: 5);
// //   static const Duration API_CHECK_TIMEOUT = Duration(seconds: 2); // CRITICAL: 2 sec max

// //   final _connectionController = StreamController<bool>.broadcast();
// //   Stream<bool> get connectionStream => _connectionController.stream;
  
// //   final _apiReachableController = StreamController<bool>.broadcast();
// //   Stream<bool> get apiReachableStream => _apiReachableController.stream;

// //   bool get hasConnection => _hasConnection;
// //   bool get isApiReachable => _isApiReachable;
// //   bool get isConnected => _hasConnection && _isApiReachable;

// //   Future<void> init() async {
// //     await _checkConnection();
// //     _connectivity.onConnectivityChanged.listen((_) {
// //       _checkConnection();
// //     });
// //   }

// //   Future<void> _checkConnection() async {
// //     try {
// //       final results = await _connectivity.checkConnectivity();
// //       final bool wasConnected = _hasConnection;
// //       final bool wasApiReachable = _isApiReachable;
      
// //       _hasConnection = results.any((r) => r != ConnectivityResult.none);
      
// //       // Only check API if we have internet AND enough time has passed since last check
// //       if (_hasConnection) {
// //         final now = DateTime.now();
// //         if (now.difference(_lastApiCheckTime) >= API_CHECK_COOLDOWN) {
// //           _lastApiCheckTime = now;
// //           _isApiReachable = await _checkApiHealth();
// //         }
// //       } else {
// //         _isApiReachable = false;
// //       }
      
// //       if (wasConnected != _hasConnection) _connectionController.add(_hasConnection);
// //       if (wasApiReachable != _isApiReachable) _apiReachableController.add(_isApiReachable);
      
// //       print('🌐 Connection: ${_hasConnection ? 'ONLINE' : 'OFFLINE'}');
// //       print('📡 API: ${_isApiReachable ? 'REACHABLE' : 'NOT REACHABLE'}');
      
// //     } catch (e) {
// //       print('⚠️ Connection check error: $e');
// //       _hasConnection = false;
// //       _isApiReachable = false;
// //     }
// //   }

// //   // Direct lightweight health check with a 2-second hard deadline
// //   Future<bool> _checkApiHealth() async {
// //     try {
// //       // We bypass ApiService here to guarantee a short timeout. 
// //       // Replace the IP with your PC's IP. 
// //       final response = await http
// //           .get(
// //               Uri.parse('http://192.168.43.100:8000/campagne_api/ISETAG_COM.etablissements'))
// //           .timeout(API_CHECK_TIMEOUT);

// //       return response.statusCode == 200;
// //     } catch (e) {
// //       // If it times out, it's definitely a local network issue
// //       print('⚠️ API health check failed (Timeout or Unreachable): $e');
// //       return false;
// //     }
// //   }

// //   Future<bool> hasInternet() async {
// //     try {
// //       final results = await _connectivity.checkConnectivity();
// //       return results.any((r) => r != ConnectivityResult.none);
// //     } catch (_) { return false; }
// //   }

// //   Future<bool> isFullyConnected() async {
// //     if (!await hasInternet()) return false;
// //     return await _checkApiHealth();
// //   }

// //   void dispose() {
// //     _connectionController.close();
// //     _apiReachableController.close();
// //   }
// // }


// // lib/utils/connection_checker.dart
// // import 'dart:async';
// // import '../config/app_config.dart';
// // import '../services/api_service.dart';

// // class ConnectionChecker {
// //   static final ConnectionChecker _instance = ConnectionChecker._internal();
// //   factory ConnectionChecker() => _instance;
// //   ConnectionChecker._internal();

// //   bool _isConnected = false;
// //   bool _isApiReachable = false;
// //   Timer? _healthCheckTimer;
// //   final ApiService _api = ApiService();

// //   final _connectionController = StreamController<bool>.broadcast();
// //   final _apiReachableController = StreamController<bool>.broadcast();

// //   Stream<bool> get connectionStream => _connectionController.stream;
// //   Stream<bool> get apiReachableStream => _apiReachableController.stream;

// //   bool get isConnected => _isConnected;
// //   bool get isApiReachable => _isApiReachable;

// //   // ✅ Méthode d'initialisation
// //   Future<void> init() async {
// //     await checkConnection();
// //     _startPeriodicCheck();
// //   }

// //   // ✅ Vérification complète de la connexion
// //   Future<void> checkConnection() async {
// //     try {
// //       // Vérifier d'abord la connectivité réseau
// //       final networkAvailable = await _checkNetworkConnectivity();
      
// //       if (networkAvailable) {
// //         // Si réseau disponible, vérifier l'API
// //         final apiReachable = await _checkApiReachability();
// //         _isApiReachable = apiReachable;
// //         _isConnected = apiReachable; // Maintenant connecté = API accessible
// //       } else {
// //         _isConnected = false;
// //         _isApiReachable = false;
// //       }

// //       _connectionController.add(_isConnected);
// //       _apiReachableController.add(_isApiReachable);

// //       print('📶 Connection status - Network: $networkAvailable, API: ${_isApiReachable}');
// //     } catch (e) {
// //       print('❌ Error checking connection: $e');
// //       _isConnected = false;
// //       _isApiReachable = false;
// //       _connectionController.add(false);
// //       _apiReachableController.add(false);
// //     }
// //   }

// //   // ✅ Vérification de la connectivité réseau
// //   Future<bool> _checkNetworkConnectivity() async {
// //     try {
// //       // Utiliser un ping simple ou vérifier la connectivité
// //       // Vous pouvez utiliser connectivity_plus ici
// //       return true; // Temporairement true, à remplacer par votre logique
// //     } catch (e) {
// //       return false;
// //     }
// //   }

// //   // ✅ Vérification de l'accessibilité de l'API
// //   Future<bool> _checkApiReachability() async {
// //     try {
// //       // Utiliser la méthode healthCheck de l'API
// //       final response = await _api.healthCheck();
// //       return response == 200; // Ou vérifier le contenu
// //     } catch (e) {
// //       print('❌ API unreachable: $e');
// //       return false;
// //     }
// //   }

// //   // ✅ Vérification périodique
// //   void _startPeriodicCheck() {
// //     _healthCheckTimer?.cancel();
// //     _healthCheckTimer = Timer.periodic(
// //       const Duration(seconds: 30),
// //       (_) => checkConnection(),
// //     );
// //   }

// //   // ✅ Forcer une vérification
// //   Future<void> refresh() async {
// //     await checkConnection();
// //   }

// //   // ✅ Nettoyage
// //   void dispose() {
// //     _healthCheckTimer?.cancel();
// //     _connectionController.close();
// //     _apiReachableController.close();
// //   }
// // }


// // lib/utils/connection_checker.dart
// // ignore_for_file: avoid_print
// import 'dart:async';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import '../services/api_service.dart';

// /// Détecte à la fois :
// ///  1. la présence d'un lien réseau (WiFi OU données mobiles OU ethernet...)
// ///  2. la joignabilité RÉELLE du serveur Django (le lien réseau seul ne
// ///     suffit pas : on peut être en WiFi captif, ou l'API peut être down).
// ///
// /// On ne fait JAMAIS de distinction entre WiFi et données mobiles : les deux
// /// sont traités de façon strictement identique (`isConnected` ne dépend que
// /// de la présence d'un lien + de la réponse de l'API), ce qui garantit que
// /// la synchronisation fonctionne quel que soit le type de connexion.
// class ConnectionChecker {
//   static final ConnectionChecker _instance = ConnectionChecker._internal();
//   factory ConnectionChecker() => _instance;
//   ConnectionChecker._internal();

//   final Connectivity _connectivity = Connectivity();
//   final ApiService _api = ApiService();

//   static const Duration _healthCheckTimeout = Duration(seconds: 5);
//   static const Duration _periodicCheckInterval = Duration(seconds: 20);

//   bool _hasNetwork = false;
//   bool _isApiReachable = false;
//   bool _initialized = false;

//   Timer? _periodicTimer;
//   StreamSubscription<List<ConnectivityResult>>? _connectivitySub;

//   final _connectionController = StreamController<bool>.broadcast();
//   final _apiReachableController = StreamController<bool>.broadcast();

//   /// Émet à chaque changement de présence réseau (WiFi/mobile/aucun).
//   Stream<bool> get connectionStream => _connectionController.stream;

//   /// Émet à chaque changement de joignabilité réelle de l'API Django.
//   Stream<bool> get apiReachableStream => _apiReachableController.stream;

//   bool get hasNetwork => _hasNetwork;
//   bool get isApiReachable => _isApiReachable;

//   /// "Vraiment connecté" = un lien réseau existe ET le serveur répond.
//   bool get isConnected => _hasNetwork && _isApiReachable;

//   Future<void> init() async {
//     if (_initialized) return;
//     _initialized = true;

//     await checkConnection();

//     _connectivitySub = _connectivity.onConnectivityChanged.listen(
//       (results) => _onConnectivityChanged(results),
//     );

//     _periodicTimer ??= Timer.periodic(
//       _periodicCheckInterval,
//       (_) => checkConnection(),
//     );
//   }

//   Future<void> _onConnectivityChanged(List<ConnectivityResult> results) async {
//     final hasNetwork = _resultsIndicateNetwork(results);
//     _setHasNetwork(hasNetwork);

//     if (hasNetwork) {
//       await _refreshApiReachability();
//     } else {
//       _setApiReachable(false);
//     }
//   }

//   /// `results` peut contenir plusieurs valeurs simultanément (ex: WiFi +
//   /// VPN). On considère qu'il y a un réseau dès qu'AU MOINS un des
//   /// résultats n'est pas `none` — WiFi et données mobiles sont traités de
//   /// façon strictement égale ici.
//   bool _resultsIndicateNetwork(List<ConnectivityResult> results) {
//     return results.any((r) => r != ConnectivityResult.none);
//   }

//   /// Vérification complète (réseau + API), à appeler manuellement si besoin
//   /// (pull-to-refresh, avant de lancer une synchro, etc).
//   Future<void> checkConnection() async {
//     try {
//       final results = await _connectivity.checkConnectivity();
//       final hasNetwork = _resultsIndicateNetwork(results);
//       _setHasNetwork(hasNetwork);

//       if (hasNetwork) {
//         await _refreshApiReachability();
//       } else {
//         _setApiReachable(false);
//       }

//       print(
//         '📶 Réseau: ${_hasNetwork ? "présent" : "absent"} · '
//         'API: ${_isApiReachable ? "joignable" : "injoignable"}',
//       );
//     } catch (e) {
//       print('❌ Erreur de vérification de connexion: $e');
//       _setHasNetwork(false);
//       _setApiReachable(false);
//     }
//   }

//   Future<void> _refreshApiReachability() async {
//     final reachable = await _pingApi();
//     _setApiReachable(reachable);
//   }

//   /// Ping court (timeout dur de 5s) vers l'endpoint santé de l'API.
//   /// On réutilise `ApiService.healthCheck()` (même URL de base que le
//   /// reste de l'app) plutôt que de re-coder une URL en dur ici.
//   Future<bool> _pingApi() async {
//     try {
//       final result = await _api.healthCheck().timeout(_healthCheckTimeout);
//       return result['success'] == true;
//     } catch (e) {
//       print('⚠️ Health check API échoué: $e');
//       return false;
//     }
//   }

//   void _setHasNetwork(bool value) {
//     if (value != _hasNetwork) {
//       _hasNetwork = value;
//       _connectionController.add(_hasNetwork);
//     }
//   }

//   void _setApiReachable(bool value) {
//     if (value != _isApiReachable) {
//       _isApiReachable = value;
//       _apiReachableController.add(_isApiReachable);
//     }
//   }

//   /// Vérification légère : réseau seul (pas d'appel API).
//   Future<bool> hasInternet() async {
//     final results = await _connectivity.checkConnectivity();
//     return _resultsIndicateNetwork(results);
//   }

//   /// Vérification complète à la demande, retourne le résultat.
//   Future<bool> isFullyConnected() async {
//     await checkConnection();
//     return isConnected;
//   }

//   Future<void> refresh() => checkConnection();

//   void dispose() {
//     _connectivitySub?.cancel();
//     _periodicTimer?.cancel();
//     _connectionController.close();
//     _apiReachableController.close();
//     _initialized = false;
//   }
// }






// lib/utils/connection_checker.dart
// ignore_for_file: avoid_print
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/api_service.dart';

/// Détecte la connexion réseau (WiFi et/ou données mobiles) ET la
/// joignabilité réelle de l'API Django, en suivant ce schéma :
///
///  1. Lister les ressources réseau ACTIVES (WiFi, données mobiles,
///     ethernet, VPN...) — il peut y en avoir plusieurs en même temps.
///  2. Les ordonner par priorité (WiFi d'abord, puis données mobiles,
///     puis le reste).
///  3. Tester la joignabilité de l'API sur la 1ère ressource, avec
///     [maxAttemptsPerResource] tentatives (3 par défaut).
///  4. Si elle échoue après ses tentatives, basculer sur la ressource
///     active suivante et recommencer le cycle de tentatives.
///  5. Dès qu'une tentative réussit (peu importe la ressource), l'API est
///     considérée joignable.
///
/// NB : sans code natif spécifique, Dart ne peut pas forcer une requête
/// HTTP à emprunter une interface réseau précise quand plusieurs sont
/// actives — c'est l'OS qui choisit la route. Ce mécanisme reproduit donc
/// fidèlement la LOGIQUE demandée (tentatives + bascule), mais chaque
/// tentative est un vrai appel réseau, pas une simulation.
class ConnectionChecker {
  static final ConnectionChecker _instance = ConnectionChecker._internal();
  factory ConnectionChecker() => _instance;
  ConnectionChecker._internal();

  final Connectivity _connectivity = Connectivity();
  final ApiService _api = ApiService();

  static const Duration healthCheckTimeout = Duration(seconds: 5);
  static const Duration retryDelay = Duration(seconds: 2);
  static const Duration periodicCheckInterval = Duration(seconds: 20);

  /// Nombre de tentatives sur une ressource avant de basculer sur la
  /// suivante.
  int maxAttemptsPerResource = 3;

  /// Ordre de préférence quand plusieurs ressources sont actives en même
  /// temps.
  static const List<ConnectivityResult> _resourcePriority = [
    ConnectivityResult.wifi,
    ConnectivityResult.mobile,
    ConnectivityResult.ethernet,
    ConnectivityResult.vpn,
    ConnectivityResult.other,
  ];

  bool _hasNetwork = false;
  bool _isApiReachable = false;
  bool _initialized = false;
  bool _isChecking = false;

  /// La ressource sur laquelle l'API a effectivement répondu la dernière
  /// fois (utile pour l'affichage : "Connecté via WiFi", etc.)
  ConnectivityResult? _activeResource;

  Timer? _periodicTimer;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;

  final _connectionController = StreamController<bool>.broadcast();
  final _apiReachableController = StreamController<bool>.broadcast();

  /// Émet à chaque changement de présence réseau (WiFi/mobile/aucun).
  Stream<bool> get connectionStream => _connectionController.stream;

  /// Émet à chaque changement de joignabilité réelle de l'API Django.
  Stream<bool> get apiReachableStream => _apiReachableController.stream;

  bool get hasNetwork => _hasNetwork;
  bool get isApiReachable => _isApiReachable;

  /// "Vraiment connecté" = un lien réseau existe ET le serveur répond.
  bool get isConnected => _hasNetwork && _isApiReachable;

  ConnectivityResult? get activeResource => _activeResource;

  String get activeResourceLabel =>
      _activeResource == null ? 'Aucune' : _labelFor(_activeResource!);

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    await checkConnection();

    _connectivitySub = _connectivity.onConnectivityChanged.listen(
      (results) => _onConnectivityChanged(results),
    );

    _periodicTimer ??= Timer.periodic(
      periodicCheckInterval,
      (_) => checkConnection(),
    );
  }

  Future<void> _onConnectivityChanged(List<ConnectivityResult> results) async {
    await _evaluate(results);
  }

  /// Vérification complète (réseau + API), à appeler manuellement si besoin
  /// (pull-to-refresh, avant de lancer une synchro, etc).
  Future<void> checkConnection() async {
    try {
      final results = await _connectivity.checkConnectivity();
      await _evaluate(results);
    } catch (e) {
      print('❌ Erreur de vérification de connexion: $e');
      _setHasNetwork(false);
      _setApiReachable(false);
      _activeResource = null;
    }
  }

  Future<void> _evaluate(List<ConnectivityResult> results) async {
    if (_isChecking) return; // évite les vérifications qui se chevauchent
    _isChecking = true;

    try {
      final activeResources = _orderedActiveResources(results);

      if (activeResources.isEmpty) {
        _setHasNetwork(false);
        _setApiReachable(false);
        _activeResource = null;
        print('📴 Aucune ressource réseau active (ni WiFi ni données mobiles)');
        return;
      }

      _setHasNetwork(true);
      print('📶 Ressources actives : ${activeResources.map(_labelFor).join(", ")}');

      final reachable = await _tryReachApiAcrossResources(activeResources);
      _setApiReachable(reachable);
    } finally {
      _isChecking = false;
    }
  }

  List<ConnectivityResult> _orderedActiveResources(List<ConnectivityResult> results) {
    final active = results.where((r) => r != ConnectivityResult.none).toSet();
    return [
      for (final r in _resourcePriority) if (active.contains(r)) r,
      ...active.where((r) => !_resourcePriority.contains(r)),
    ];
  }

  /// Essaie de joindre l'API en utilisant chaque ressource active, dans
  /// l'ordre de priorité : [maxAttemptsPerResource] tentatives sur la
  /// première ressource disponible, puis bascule sur la suivante si toutes
  /// ont échoué.
  Future<bool> _tryReachApiAcrossResources(List<ConnectivityResult> resources) async {
    for (final resource in resources) {
      print('📡 Test de l\'API via ${_labelFor(resource)}...');

      for (var attempt = 1; attempt <= maxAttemptsPerResource; attempt++) {
        final ok = await _pingApi();
        if (ok) {
          _activeResource = resource;
          print('✅ API joignable via ${_labelFor(resource)} (tentative $attempt/$maxAttemptsPerResource)');
          return true;
        }

        print('⚠️ Échec via ${_labelFor(resource)} — tentative $attempt/$maxAttemptsPerResource');
        if (attempt < maxAttemptsPerResource) {
          await Future.delayed(retryDelay);
        }
      }

      print('❌ ${_labelFor(resource)} épuisé après $maxAttemptsPerResource tentatives'
          '${resources.last == resource ? "" : ", bascule sur la ressource suivante..."}');
    }

    _activeResource = null;
    return false;
  }

  /// Ping court vers l'endpoint santé de l'API (même client que le reste
  /// de l'app, pour rester cohérent avec la config d'URL/headers).
  Future<bool> _pingApi() async {
    try {
      final result = await _api.healthCheck().timeout(healthCheckTimeout);
      return result['success'] == true;
    } catch (e) {
      print('⚠️ Health check échoué: $e');
      return false;
    }
  }

  String _labelFor(ConnectivityResult r) {
    switch (r) {
      case ConnectivityResult.wifi:
        return 'WiFi';
      case ConnectivityResult.mobile:
        return 'données mobiles';
      case ConnectivityResult.ethernet:
        return 'Ethernet';
      case ConnectivityResult.vpn:
        return 'VPN';
      case ConnectivityResult.bluetooth:
        return 'Bluetooth';
      default:
        return r.name;
    }
  }

  void _setHasNetwork(bool value) {
    if (value != _hasNetwork) {
      _hasNetwork = value;
      _connectionController.add(_hasNetwork);
    }
  }

  void _setApiReachable(bool value) {
    if (value != _isApiReachable) {
      _isApiReachable = value;
      _apiReachableController.add(_isApiReachable);
    }
  }

  /// Vérification légère : réseau seul (pas d'appel API).
  Future<bool> hasInternet() async {
    final results = await _connectivity.checkConnectivity();
    return _orderedActiveResources(results).isNotEmpty;
  }

  /// Vérification complète à la demande, retourne le résultat.
  Future<bool> isFullyConnected() async {
    await checkConnection();
    return isConnected;
  }

  Future<void> refresh() => checkConnection();

  void dispose() {
    _connectivitySub?.cancel();
    _periodicTimer?.cancel();
    _connectionController.close();
    _apiReachableController.close();
    _initialized = false;
  }
}