// // // lib/services/sync_service.dart
// // // ignore_for_file: avoid_print

// // import 'dart:async';
// // // import 'package:flutter/material.dart';
// // import 'package:connectivity_plus/connectivity_plus.dart';
// // import 'package:isar_community/isar.dart';
// // // import 'package:isetagcom/models/agent_commercial.dart';
// // // import 'package:isetagcom/models/classe.dart';
// // // import 'package:isetagcom/models/etablissement.dart';
// // import 'package:isetagcom/models/fiche.dart';
// // import 'package:isetagcom/models/interet_filiere.dart';
// // import 'package:isetagcom/models/pros.dart';
// // // import 'package:isetagcom/models/source.dart';
// // // import 'package:isetagcom/models/specialite.dart';
// // // import 'package:isetagcom/models/user.dart';
// // import 'package:isetagcom/models/localStorage/local_storage.dart';
// // // import 'package:isetagcom/services/api_service.dart';
// // // import 'package:isetagcom/utils/sync_queue.dart';
// // import 'package:shared_preferences/shared_preferences.dart';

// // import '../utils/status.dart';
// // import '../utils/sync_queue.dart';
// // import 'api_service.dart';

// // enum SyncStatus {
// //   idle,
// //   syncing,
// //   completed,
// //   failed,
// // }

// // class SyncService {
// //   static final SyncService _instance = SyncService._internal();
// //   factory SyncService() => _instance;
// //   SyncService._internal();

// //   final LocalStorage _storage = LocalStorage.instance;
// //   final ApiService _api = ApiService();
// //   final SyncQueue _queue = SyncQueue();

// //   SyncStatus _status = SyncStatus.idle;
// //   String? _lastError;
// //   double _progress = 0.0;
// //   int _totalItems = 0;
// //   int _syncedItems = 0;

// //   final _statusController = StreamController<SyncStatus>.broadcast();
// //   final _progressController = StreamController<double>.broadcast();

// //   Stream<SyncStatus> get statusStream => _statusController.stream;
// //   Stream<double> get progressStream => _progressController.stream;
// //   SyncStatus get status => _status;
// //   double get progress => _progress;
// //   bool get isSyncing => _status == SyncStatus.syncing;

// //   // Initialize sync service
// //   Future<void> init() async {
// //     await _queue.init();
// //     _listenToConnectivity();
// //   }

// //   // Listen to connectivity changes
// //   void _listenToConnectivity() {
// //     Connectivity().onConnectivityChanged.listen((result) {
// //       if (result != ConnectivityResult.none) {
// //         _checkAndSync();
// //       }
// //     });
// //   }

// //   // Check and sync if needed
// //   Future<void> _checkAndSync() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     final lastSync = prefs.getString('last_sync_time');

// //     // Only sync if not syncing and last sync was more than 5 minutes ago
// //     if (_status != SyncStatus.syncing) {
// //       final now = DateTime.now();
// //       if (lastSync == null) {
// //         await syncAll();
// //       } else {
// //         final lastSyncTime = DateTime.parse(lastSync);
// //         if (now.difference(lastSyncTime).inMinutes > 5) {
// //           await syncAll();
// //         }
// //       }
// //     }
// //   }

// //   // Main sync method
// //   Future<void> syncAll({bool force = false}) async {
// //     if (_status == SyncStatus.syncing && !force) {
// //       print('Sync already in progress');
// //       return;
// //     }

// //     _status = SyncStatus.syncing;
// //     _statusController.add(_status);
// //     _progress = 0.0;
// //     _progressController.add(_progress);
// //     _lastError = null;

// //     try {
// //       // Check connectivity
// //       final connectivityResult = await Connectivity().checkConnectivity();
// //       if (connectivityResult == ConnectivityResult.none) {
// //         throw Exception('No internet connection...');
// //       }

// //       // Get all pending items
// //       final pendingData = await _getPendingData();
// //       _totalItems = pendingData.length;
// //       _syncedItems = 0;

// //       if (pendingData.isEmpty) {
// //         _status = SyncStatus.completed;
// //         _statusController.add(_status);
// //         _progress = 1.0;
// //         _progressController.add(_progress);
// //         await _updateLastSyncTime();
// //         return;
// //       }

// //       // Process each item
// //       for (var item in pendingData) {
// //         try {
// //           await _syncItem(item);
// //           _syncedItems++;
// //           _progress = _syncedItems / _totalItems;
// //           _progressController.add(_progress);
// //         } catch (e) {
// //           print('Error syncing item: $e');
// //           // Don't stop the sync for one item, continue with others
// //         }
// //       }

// //       // After all data is synced, update statuses
// //       await _updateSyncedStatus();

// //       _status = SyncStatus.completed;
// //       _statusController.add(_status);
// //       await _updateLastSyncTime();
// //     } catch (e) {
// //       _status = SyncStatus.failed;
// //       _lastError = e.toString();
// //       _statusController.add(_status);
// //       print('Sync failed: $e');
// //       rethrow;
// //     }
// //   }

// //   // Get all pending data
// //   Future<List<Map<String, dynamic>>> _getPendingData() async {
// //     final pendingData = <Map<String, dynamic>>[];

// //     try {
// //       // 1. Get pending Prospects
// //       final pendingProspects = await _storage.isar.prospects
// //           .where()
// //           .filter()
// //           .syncStateEqualTo(SyncState.pending)
// //           .findAll();

// //       for (final prospect in pendingProspects) {
// //         await prospect.interets.load();
// //         pendingData.add({
// //           'type': 'prospect',
// //           'data': prospect,
// //         });
// //       }

// //       // 2. Get pending Fiches
// //       final pendingFiches = await _storage.isar.fiches
// //           .where()
// //           .filter()
// //           .syncStateEqualTo(SyncState.pending)
// //           .findAll();

// //       for (final fiche in pendingFiches) {
// //         await fiche.prospects.load();
// //         pendingData.add({
// //           'type': 'fiche',
// //           'data': fiche,
// //         });
// //       }

// //       // 3. Get pending Interets
// //       final pendingInterets = await _storage.isar.interetFilieres
// //           .where()
// //           .filter()
// //           .syncStateEqualTo(SyncState.pending)
// //           .findAll();

// //       for (final interet in pendingInterets) {
// //         await interet.prospect.load();
// //         await interet.specialite.load();
// //         pendingData.add({
// //           'type': 'interet',
// //           'data': interet,
// //         });
// //       }

// //       // 4. Get pending Etablissements
// //       // If you have syncState on Etablissement, add it here

// //       // 5. Get pending Classes
// //       // If you have syncState on Classe, add it here
// //     } catch (e) {
// //       print('Error getting pending data: $e');
// //     }

// //     return pendingData;
// //   }

// //   // Sync individual item
// //   Future<void> _syncItem(Map<String, dynamic> item) async {
// //     final type = item['type'] as String;
// //     final data = item['data'];

// //     switch (type) {
// //       case 'prospect':
// //         await _syncProspect(data as Prospect);
// //         break;
// //       case 'fiche':
// //         await _syncFiche(data as Fiche);
// //         break;
// //       case 'interet':
// //         await _syncInteret(data as InteretFiliere);
// //         break;
// //       default:
// //         print('Unknown sync type: $type');
// //     }
// //   }

// //   // Sync Prospect
// //   Future<void> _syncProspect(Prospect prospect) async {
// //     try {
// //       // Prepare data for API
// //       final apiData = prospect.toJsonApi();

// //       // Add interests data
// //       if (prospect.interets.isNotEmpty) {
// //         apiData['interets'] =
// //             prospect.interets.map((i) => i.toApiJson()).toList();
// //       }

// //       // Send to API
// //       final response = await _api.createProspect(apiData);

// //       if (response['success'] == true) {
// //         // Update sync state
// //         await _storage.isar.writeTxn(() async {
// //           prospect.syncState = SyncState.synced;
// //           await _storage.isar.prospects.put(prospect);
// //         });
// //       } else {
// //         throw Exception('API returned error: ${response['message']}');
// //       }
// //     } catch (e) {
// //       print('Error syncing prospect ${prospect.idProspect}: $e');
// //       rethrow;
// //     }
// //   }

// //   // Sync Fiche
// //   Future<void> _syncFiche(Fiche fiche) async {
// //     try {
// //       final apiData = fiche.toJsonApi();

// //       // Add prospects data
// //       if (fiche.prospects.isNotEmpty) {
// //         apiData['prospects'] =
// //             fiche.prospects.map((p) => p.toJsonApi()).toList();
// //       }

// //       final response = await _api.createFiche(apiData);

// //       if (response['success'] == true) {
// //         await _storage.isar.writeTxn(() async {
// //           fiche.syncState = SyncState.synced;
// //           await _storage.isar.fiches.put(fiche);
// //         });
// //       } else {
// //         throw Exception('API returned error: ${response['message']}');
// //       }
// //     } catch (e) {
// //       print('Error syncing fiche ${fiche.idFiche}: $e');
// //       rethrow;
// //     }
// //   }

// //   // Sync Interet
// //   Future<void> _syncInteret(InteretFiliere interet) async {
// //     try {
// //       final apiData = interet.toApiJson();

// //       final response = await _api.createInteret(apiData);

// //       if (response['success'] == true) {
// //         await _storage.isar.writeTxn(() async {
// //           interet.syncState = SyncState.synced;
// //           await _storage.isar.interetFilieres.put(interet);
// //         });
// //       } else {
// //         throw Exception('API returned error: ${response['message']}');
// //       }
// //     } catch (e) {
// //       print('Error syncing interet ${interet.idInteret}: $e');
// //       rethrow;
// //     }
// //   }

// //   // Update all synced statuses
// //   Future<void> _updateSyncedStatus() async {
// //     try {
// //       await _storage.isar.writeTxn(() async {
// //         // Update prospects
// //         final pendingProspects = await _storage.isar.prospects
// //             .where()
// //             .filter()
// //             .syncStateEqualTo(SyncState.pending)
// //             .findAll();

// //         for (final prospect in pendingProspects) {
// //           prospect.syncState = SyncState.synced;
// //           await _storage.isar.prospects.put(prospect);
// //         }

// //         // Update fiches
// //         final pendingFiches = await _storage.isar.fiches
// //             .where()
// //             .filter()
// //             .syncStateEqualTo(SyncState.pending)
// //             .findAll();

// //         for (final fiche in pendingFiches) {
// //           fiche.syncState = SyncState.synced;
// //           await _storage.isar.fiches.put(fiche);
// //         }

// //         // Update interets
// //         final pendingInterets = await _storage.isar.interetFilieres
// //             .where()
// //             .filter()
// //             .syncStateEqualTo(SyncState.pending)
// //             .findAll();

// //         for (final interet in pendingInterets) {
// //           interet.syncState = SyncState.synced;
// //           await _storage.isar.interetFilieres.put(interet);
// //         }
// //       });
// //     } catch (e) {
// //       print('Error updating synced status: $e');
// //     }
// //   }

// //   // Update last sync time
// //   Future<void> _updateLastSyncTime() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     await prefs.setString('last_sync_time', DateTime.now().toIso8601String());
// //   }

// //   // Manual sync trigger
// //   Future<void> manualSync() async {
// //     await syncAll(force: true);
// //   }

// //   // Add to SyncService class
// //   Future<bool> checkApiHealth() async {
// //     try {
// //       final result = await _api.healthCheck();
// //       return result['success'] == true;
// //     } catch (e) {
// //       return false;
// //     }
// //   }

// //   // Dispose
// //   void dispose() {
// //     _statusController.close();
// //     _progressController.close();
// //   }
// // }

// // lib/services/sync_service.dart
// // ignore_for_file: avoid_print
// //
// // NOTE DE MIGRATION
// // ------------------
// // Toute la logique de synchronisation (ordre de dépendance, lots de 25,
// // retries, pause/reprise réseau) vit maintenant dans `utils/sync_queue.dart`
// // (classe SyncQueue). Cette classe SyncService devient une FAÇADE fine qui
// // ne fait que traduire les évènements de SyncQueue vers l'ancienne API
// // (`SyncStatus`, `statusStream`, `progressStream`, `isSyncing`,
// // `checkApiHealth()`) pour ne pas casser `main.dart`, `auto_sync_service.dart`
// // et `widgets/sync_toast.dart` qui en dépendent encore.
// //
// // ⚠️ Recommandation : `AutoSyncService` fait aujourd'hui doublon avec la
// // gestion de connectivité déjà prise en charge par `SyncQueue`/
// // `ConnectionChecker` (et contient un bug de cast avec
// // `connectivity_plus` v6+ sur `onConnectivityChanged`, qui émet désormais
// // une `List<ConnectivityResult>`). Le plus propre serait de supprimer
// // `AutoSyncService` et de laisser `SyncService.init()` (ci-dessous) gérer
// // entièrement la synchro automatique. Je n'ai pas touché à ce fichier car
// // il ne faisait pas partie de ceux que tu m'as donnés — dis-moi si tu veux
// // que je le nettoie aussi.

// import 'dart:async';

// import '../utils/sync_queue.dart';
// import '../utils/connection_checker.dart';

// enum SyncStatus {
//   idle,
//   syncing,
//   completed,
//   failed,
// }

// class SyncService {
//   static final SyncService _instance = SyncService._internal();
//   factory SyncService() => _instance;
//   SyncService._internal();

//   final SyncQueue _queue = SyncQueue();
//   final ConnectionChecker _connection = ConnectionChecker();

//   SyncStatus _status = SyncStatus.idle;
//   String? _lastError;

//   final _statusController = StreamController<SyncStatus>.broadcast();
//   final _progressController = StreamController<double>.broadcast();

//   StreamSubscription<bool>? _queueStatusSub;
//   StreamSubscription<double>? _progressSub;

//   Stream<SyncStatus> get statusStream => _statusController.stream;
//   Stream<double> get progressStream => _progressController.stream;

//   SyncStatus get status => _status;
//   bool get isSyncing => _status == SyncStatus.syncing;
//   String? get lastError => _lastError;

//   Future<void> init() async {
//     // SyncQueue.init() démarre déjà : la vérification de connexion, la
//     // synchro auto au retour du réseau, et la synchro immédiate s'il reste
//     // des éléments en attente au démarrage de l'app.
//     await _queue.init();

//     _queueStatusSub ??= _queue.queueStatusStream.listen((isProcessing) {
//       if (isProcessing) {
//         _setStatus(SyncStatus.syncing);
//       } else if (_status == SyncStatus.syncing) {
//         _setStatus(SyncStatus.completed);
//       }
//     });

//     _progressSub ??= _queue.progressStream.listen((progress) {
//       _progressController.add(progress);
//     });
//   }

//   void _setStatus(SyncStatus status) {
//     _status = status;
//     _statusController.add(_status);
//   }

//   /// Lance une synchronisation complète (utilisé par AutoSyncService et
//   /// par tout code existant qui appelait `SyncService().syncAll()`).
//   Future<void> syncAll({bool force = false}) async {
//     try {
//       _lastError = null;
//       if (!_connection.isConnected) {
//         throw Exception('No internet connection');
//       }
//       _setStatus(SyncStatus.syncing);
//       await _queue.syncNow();
//       _setStatus(SyncStatus.completed);
//     } catch (e) {
//       _lastError = e.toString();
//       _setStatus(SyncStatus.failed);
//       print('❌ Sync failed: $e');
//       rethrow;
//     }
//   }

//   Future<void> manualSync() => syncAll(force: true);

//   /// Conservé pour compatibilité (`AutoSyncService._isApiReachable()`
//   /// l'appelle) : vérifie que le serveur Django répond réellement, pas
//   /// seulement qu'un réseau WiFi/mobile est présent.
//   Future<bool> checkApiHealth() async {
//     await _connection.refresh();
//     return _connection.isApiReachable;
//   }

//   void dispose() {
//     _queueStatusSub?.cancel();
//     _progressSub?.cancel();
//     _statusController.close();
//     _progressController.close();
//   }
// }

// lib/services/sync_service.dart
// ignore_for_file: avoid_print
//
// Façade fine : la vraie logique (ordre de dépendance, lots configurables,
// retries, pause/reprise réseau) vit dans `utils/sync_queue.dart`
// (SyncQueue). Cette classe ne fait que traduire les évènements de
// SyncQueue vers l'ancienne API (`SyncStatus`, `statusStream`,
// `progressStream`, `isSyncing`, `checkApiHealth()`) pour ne pas casser
// `main.dart`, `auto_sync_service.dart` et `widgets/sync_toast.dart`.
//
// ⚠️ Toujours valable : `AutoSyncService` fait doublon avec la gestion de
// connectivité de `SyncQueue`/`ConnectionChecker` et contient un bug de
// cast avec `connectivity_plus` v6+ (`onConnectivityChanged` émet
// désormais une `List<ConnectivityResult>`). Envoie-le-moi si tu veux que
// je le nettoie aussi.

import 'dart:async';

import '../utils/sync_queue.dart';
import '../utils/connection_checker.dart';

enum SyncStatus {
  idle,
  syncing,
  completed,
  failed,
}

class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  final SyncQueue _queue = SyncQueue();
  final ConnectionChecker _connection = ConnectionChecker();

  SyncStatus _status = SyncStatus.idle;
  String? _lastError;

  final _statusController = StreamController<SyncStatus>.broadcast();
  final _progressController = StreamController<double>.broadcast();

  StreamSubscription<bool>? _queueStatusSub;
  StreamSubscription<double>? _progressSub;

  Stream<SyncStatus> get statusStream => _statusController.stream;
  Stream<double> get progressStream => _progressController.stream;

  SyncStatus get status => _status;
  bool get isSyncing => _status == SyncStatus.syncing;
  String? get lastError => _lastError;

  Future<void> init() async {
    await _queue.init();

    _queueStatusSub ??= _queue.queueStatusStream.listen((isProcessing) {
      if (isProcessing) {
        _setStatus(SyncStatus.syncing);
      } else if (_status == SyncStatus.syncing) {
        _setStatus(SyncStatus.completed);
      }
    });

    _progressSub ??= _queue.progressStream.listen((progress) {
      _progressController.add(progress);
    });
  }

  void _setStatus(SyncStatus status) {
    _status = status;
    _statusController.add(_status);
  }

  Future<void> syncAll({bool force = false}) async {
    try {
      _lastError = null;
      if (!_connection.isConnected) {
        throw Exception('No internet connection');
      }
      _setStatus(SyncStatus.syncing);
      await _queue.syncNow();
      _setStatus(SyncStatus.completed);
    } catch (e) {
      _lastError = e.toString();
      _setStatus(SyncStatus.failed);
      print('❌ Sync failed: $e');
      rethrow;
    }
  }

  Future<void> manualSync() => syncAll(force: true);

  /// Conservé pour compatibilité (`AutoSyncService._isApiReachable()`) :
  /// vérifie que le serveur Django répond réellement.
  Future<bool> checkApiHealth() async {
    await _connection.refresh();
    return _connection.isApiReachable;
  }

  void dispose() {
    _queueStatusSub?.cancel();
    _progressSub?.cancel();
    _statusController.close();
    _progressController.close();
  }
}
