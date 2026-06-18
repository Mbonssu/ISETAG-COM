// // lib/services/auto_sync_service.dart
// import 'dart:async';
// import 'package:connectivity_plus/connectivity_plus.dart';
// // import 'package:flutter/material.dart';
// import 'package:isar/isar.dart';
// import 'package:isetagcom/services/sync_service.dart';

// import '../models/fiche.dart';
// import '../models/interet_filiere.dart';
// import '../models/localStorage/local_storage.dart';
// import '../models/pros.dart';
// import '../models/specialite.dart';
// import '../utils/status.dart';

// class AutoSyncService {
//   static final AutoSyncService _instance = AutoSyncService._internal();
//   factory AutoSyncService() => _instance;
//   AutoSyncService._internal();

//   final SyncService _syncService = SyncService();
//   final Connectivity _connectivity = Connectivity();
  
//   StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription; // ✅ FIXED: List type
//   StreamSubscription? _syncStatusSubscription;
  
//   bool _isOnline = false;
//   bool _isInitialized = false;
//   Timer? _periodicSyncTimer;

//   // Callback for UI updates
//   Function(SyncStatus)? onSyncStatusChanged;
//   Function(double)? onSyncProgressChanged;

//   Future<void> init() async {
//     if (_isInitialized) return;

//     // Check initial connectivity
//     final result = await _connectivity.checkConnectivity();
//     _isOnline = result != ConnectivityResult.none;

//     // Listen to connectivity changes - ✅ FIXED: Proper type handling
//     _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
//       (List<ConnectivityResult> results) {
//         // connectivity_plus 5+ returns a list of results
//         final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
//         _onConnectivityChanged(result);
//       },
//     );

//     // Listen to sync status
//     _syncStatusSubscription = _syncService.statusStream.listen((status) {
//       onSyncStatusChanged?.call(status);
//     });

//     _syncService.progressStream.listen((progress) {
//       onSyncProgressChanged?.call(progress);
//     });

//     _isInitialized = true;

//     // Auto-sync on startup if online
//     if (_isOnline) {
//       await _triggerAutoSync();
//     }

//     // Periodic sync every 15 minutes
//     _periodicSyncTimer = Timer.periodic(
//       const Duration(minutes: 15),
//       (_) => _triggerAutoSync(),
//     );
//   }

//   void _onConnectivityChanged(ConnectivityResult result) {
//     final isNowOnline = result != ConnectivityResult.none;
    
//     if (isNowOnline && !_isOnline) {
//       // Connection restored!
//       print('🌐 Internet connection restored! Auto-syncing...');
//       _triggerAutoSync();
//     }
    
//     _isOnline = isNowOnline;
//   }

//   Future<void> _triggerAutoSync() async {
//     // Check if API is reachable before syncing
//     if (!await _isApiReachable()) {
//       print('⚠️ API not reachable, skipping sync');
//       return;
//     }

//     // Check if there are pending items
//     if (await _hasPendingItems()) {
//       print('🔄 Auto-sync triggered');
//       await _syncService.syncAll();
//     } else {
//       print('✅ No pending items to sync');
//     }
//   }

//   Future<bool> _isApiReachable() async {
//     try {
//       final result = await _syncService.checkApiHealth();
//       return result;
//     } catch (e) {
//       print('⚠️ API health check failed: $e');
//       return false;
//     }
//   }

//   Future<bool> _hasPendingItems() async {
//     // Check if there are any pending items in the queue
//     final localStorage = LocalStorage.instance;
    
//     try {
//       final pendingProspects = await localStorage.isar.prospects
//           .where()
//           .filter()
//           .syncStateEqualTo(SyncState.pending)
//           .count();
          
//       final pendingFiches = await localStorage.isar.fiches
//           .where()
//           .filter()
//           .syncStateEqualTo(SyncState.pending)
//           .count();
          
//       final pendingInterets = await localStorage.isar.interetFilieres
//           .where()
//           .filter()
//           .syncStateEqualTo(SyncState.pending)
//           .count();
          
//       final pendingSpecialites = await localStorage.isar.specialites
//           .where()
//           .filter()
//           .syncStateEqualTo(SyncState.pending)
//           .count();
      
//       return pendingProspects > 0 || 
//              pendingFiches > 0 || 
//              pendingInterets > 0 ||
//              pendingSpecialites > 0;
//     } catch (e) {
//       print('⚠️ Error checking pending items: $e');
//       return false;
//     }
//   }

//   // Manual sync trigger
//   Future<void> manualSync() async {
//     if (_isOnline) {
//       await _triggerAutoSync();
//     } else {
//       print('⚠️ Cannot sync: No internet connection');
//       throw Exception('No internet connection');
//     }
//   }

//   // Check API health
//   Future<bool> checkApiHealth() async {
//     return await _syncService.checkApiHealth();
//   }

//   // Dispose
//   void dispose() {
//     _connectivitySubscription?.cancel();
//     _syncStatusSubscription?.cancel();
//     _periodicSyncTimer?.cancel();
//   }

//   bool get isOnline => _isOnline;
//   bool get isSyncing => _syncService.isSyncing;
// }

// lib/services/auto_sync_service.dart
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:isetagcom/utils/sync_queue.dart';

class AutoSyncService {
  static final AutoSyncService _instance = AutoSyncService._internal();
  factory AutoSyncService() => _instance;
  AutoSyncService._internal();

  final SyncQueue _syncQueue = SyncQueue();
  final Connectivity _connectivity = Connectivity();
  
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isOnline = false;
  bool _isInitialized = false;
  Timer? _periodicSyncTimer;

  Future<void> init() async {
    if (_isInitialized) return;

    final result = await _connectivity.checkConnectivity();
    _isOnline = result != ConnectivityResult.none;

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (results) {
        final isNowOnline = results.any((r) => r != ConnectivityResult.none);
        _onConnectivityChanged(isNowOnline);
      },
    );

    _isInitialized = true;

    if (_isOnline) {
      await _checkAndSync();
    }

    // ✅ Periodic sync every 10 minutes
    _periodicSyncTimer = Timer.periodic(
      const Duration(minutes: 10),
      (_) => _checkAndSync(),
    );
  }

  void _onConnectivityChanged(bool isNowOnline) {
    if (isNowOnline && !_isOnline) {
      print('🌐 Connection restored! Checking for pending items...');
      _checkAndSync();
    }
    _isOnline = isNowOnline;
  }

  Future<void> _checkAndSync() async {
    // ✅ Check if there are pending items
    if (!await _syncQueue.hasPendingItems()) {
      print('✅ No pending items to sync');
      return;
    }

    // ✅ Start syncing
    print('🔄 Starting auto-sync...');
    await _syncQueue.processPendingItems();
  }

  Future<void> manualSync() async {
    if (!_isOnline) {
      throw Exception('No internet connection');
    }
    await _syncQueue.syncNow();
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    _periodicSyncTimer?.cancel();
  }

  bool get isOnline => _isOnline;
  bool get isSyncing => _syncQueue.isProcessing;
}