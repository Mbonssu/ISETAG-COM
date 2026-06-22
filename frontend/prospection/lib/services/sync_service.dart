// lib/services/sync_service.dart
// ignore_for_file: avoid_print

import 'dart:async';
// import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:isar/isar.dart';
// import 'package:isetagcom/models/agent_commercial.dart';
// import 'package:isetagcom/models/classe.dart';
// import 'package:isetagcom/models/etablissement.dart';
import 'package:isetagcom/models/fiche.dart';
import 'package:isetagcom/models/interet_filiere.dart';
import 'package:isetagcom/models/pros.dart';
// import 'package:isetagcom/models/source.dart';
// import 'package:isetagcom/models/specialite.dart';
// import 'package:isetagcom/models/user.dart';
import 'package:isetagcom/models/localStorage/local_storage.dart';
// import 'package:isetagcom/services/api_service.dart';
// import 'package:isetagcom/utils/sync_queue.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/status.dart';
import '../utils/sync_queue.dart';
import 'api_service.dart';

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

  final LocalStorage _storage = LocalStorage.instance;
  final ApiService _api = ApiService();
  final SyncQueue _queue = SyncQueue();

  SyncStatus _status = SyncStatus.idle;
  String? _lastError;
  double _progress = 0.0;
  int _totalItems = 0;
  int _syncedItems = 0;

  final _statusController = StreamController<SyncStatus>.broadcast();
  final _progressController = StreamController<double>.broadcast();

  Stream<SyncStatus> get statusStream => _statusController.stream;
  Stream<double> get progressStream => _progressController.stream;
  SyncStatus get status => _status;
  double get progress => _progress;
  bool get isSyncing => _status == SyncStatus.syncing;

  // Initialize sync service
  Future<void> init() async {
    await _queue.init();
    _listenToConnectivity();
  }

  // Listen to connectivity changes
  void _listenToConnectivity() {
    Connectivity().onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none) {
        _checkAndSync();
      }
    });
  }

  // Check and sync if needed
  Future<void> _checkAndSync() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSync = prefs.getString('last_sync_time');

    // Only sync if not syncing and last sync was more than 5 minutes ago
    if (_status != SyncStatus.syncing) {
      final now = DateTime.now();
      if (lastSync == null) {
        await syncAll();
      } else {
        final lastSyncTime = DateTime.parse(lastSync);
        if (now.difference(lastSyncTime).inMinutes > 5) {
          await syncAll();
        }
      }
    }
  }

  // Main sync method
  Future<void> syncAll({bool force = false}) async {
    if (_status == SyncStatus.syncing && !force) {
      print('Sync already in progress');
      return;
    }

    _status = SyncStatus.syncing;
    _statusController.add(_status);
    _progress = 0.0;
    _progressController.add(_progress);
    _lastError = null;

    try {
      // Check connectivity
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        throw Exception('No internet connection...');
      }

      // Get all pending items
      final pendingData = await _getPendingData();
      _totalItems = pendingData.length;
      _syncedItems = 0;

      if (pendingData.isEmpty) {
        _status = SyncStatus.completed;
        _statusController.add(_status);
        _progress = 1.0;
        _progressController.add(_progress);
        await _updateLastSyncTime();
        return;
      }

      // Process each item
      for (var item in pendingData) {
        try {
          await _syncItem(item);
          _syncedItems++;
          _progress = _syncedItems / _totalItems;
          _progressController.add(_progress);
        } catch (e) {
          print('Error syncing item: $e');
          // Don't stop the sync for one item, continue with others
        }
      }

      // After all data is synced, update statuses
      await _updateSyncedStatus();

      _status = SyncStatus.completed;
      _statusController.add(_status);
      await _updateLastSyncTime();
    } catch (e) {
      _status = SyncStatus.failed;
      _lastError = e.toString();
      _statusController.add(_status);
      print('Sync failed: $e');
      rethrow;
    }
  }

  // Get all pending data
  Future<List<Map<String, dynamic>>> _getPendingData() async {
    final pendingData = <Map<String, dynamic>>[];

    try {
      // 1. Get pending Prospects
      final pendingProspects = await _storage.isar.prospects
          .where()
          .filter()
          .syncStateEqualTo(SyncState.pending)
          .findAll();

      for (final prospect in pendingProspects) {
        await prospect.interets.load();
        pendingData.add({
          'type': 'prospect',
          'data': prospect,
        });
      }

      // 2. Get pending Fiches
      final pendingFiches = await _storage.isar.fiches
          .where()
          .filter()
          .syncStateEqualTo(SyncState.pending)
          .findAll();

      for (final fiche in pendingFiches) {
        await fiche.prospects.load();
        pendingData.add({
          'type': 'fiche',
          'data': fiche,
        });
      }

      // 3. Get pending Interets
      final pendingInterets = await _storage.isar.interetFilieres
          .where()
          .filter()
          .syncStateEqualTo(SyncState.pending)
          .findAll();

      for (final interet in pendingInterets) {
        await interet.prospect.load();
        await interet.specialite.load();
        pendingData.add({
          'type': 'interet',
          'data': interet,
        });
      }

      // 4. Get pending Etablissements
      // If you have syncState on Etablissement, add it here

      // 5. Get pending Classes
      // If you have syncState on Classe, add it here
    } catch (e) {
      print('Error getting pending data: $e');
    }

    return pendingData;
  }

  // Sync individual item
  Future<void> _syncItem(Map<String, dynamic> item) async {
    final type = item['type'] as String;
    final data = item['data'];

    switch (type) {
      case 'prospect':
        await _syncProspect(data as Prospect);
        break;
      case 'fiche':
        await _syncFiche(data as Fiche);
        break;
      case 'interet':
        await _syncInteret(data as InteretFiliere);
        break;
      default:
        print('Unknown sync type: $type');
    }
  }

  // Sync Prospect
  Future<void> _syncProspect(Prospect prospect) async {
    try {
      // Prepare data for API
      final apiData = prospect.toJsonApi();

      // Add interests data
      if (prospect.interets.isNotEmpty) {
        apiData['interets'] =
            prospect.interets.map((i) => i.toApiJson()).toList();
      }

      // Send to API
      final response = await _api.createProspect(apiData);

      if (response['success'] == true) {
        // Update sync state
        await _storage.isar.writeTxn(() async {
          prospect.syncState = SyncState.synced;
          await _storage.isar.prospects.put(prospect);
        });
      } else {
        throw Exception('API returned error: ${response['message']}');
      }
    } catch (e) {
      print('Error syncing prospect ${prospect.idProspect}: $e');
      rethrow;
    }
  }

  // Sync Fiche
  Future<void> _syncFiche(Fiche fiche) async {
    try {
      final apiData = fiche.toJsonApi();

      // Add prospects data
      if (fiche.prospects.isNotEmpty) {
        apiData['prospects'] =
            fiche.prospects.map((p) => p.toJsonApi()).toList();
      }

      final response = await _api.createFiche(apiData);

      if (response['success'] == true) {
        await _storage.isar.writeTxn(() async {
          fiche.syncState = SyncState.synced;
          await _storage.isar.fiches.put(fiche);
        });
      } else {
        throw Exception('API returned error: ${response['message']}');
      }
    } catch (e) {
      print('Error syncing fiche ${fiche.idFiche}: $e');
      rethrow;
    }
  }

  // Sync Interet
  Future<void> _syncInteret(InteretFiliere interet) async {
    try {
      final apiData = interet.toApiJson();

      final response = await _api.createInteret(apiData);

      if (response['success'] == true) {
        await _storage.isar.writeTxn(() async {
          interet.syncState = SyncState.synced;
          await _storage.isar.interetFilieres.put(interet);
        });
      } else {
        throw Exception('API returned error: ${response['message']}');
      }
    } catch (e) {
      print('Error syncing interet ${interet.idInteret}: $e');
      rethrow;
    }
  }

  // Update all synced statuses
  Future<void> _updateSyncedStatus() async {
    try {
      await _storage.isar.writeTxn(() async {
        // Update prospects
        final pendingProspects = await _storage.isar.prospects
            .where()
            .filter()
            .syncStateEqualTo(SyncState.pending)
            .findAll();

        for (final prospect in pendingProspects) {
          prospect.syncState = SyncState.synced;
          await _storage.isar.prospects.put(prospect);
        }

        // Update fiches
        final pendingFiches = await _storage.isar.fiches
            .where()
            .filter()
            .syncStateEqualTo(SyncState.pending)
            .findAll();

        for (final fiche in pendingFiches) {
          fiche.syncState = SyncState.synced;
          await _storage.isar.fiches.put(fiche);
        }

        // Update interets
        final pendingInterets = await _storage.isar.interetFilieres
            .where()
            .filter()
            .syncStateEqualTo(SyncState.pending)
            .findAll();

        for (final interet in pendingInterets) {
          interet.syncState = SyncState.synced;
          await _storage.isar.interetFilieres.put(interet);
        }
      });
    } catch (e) {
      print('Error updating synced status: $e');
    }
  }

  // Update last sync time
  Future<void> _updateLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_sync_time', DateTime.now().toIso8601String());
  }

  // Manual sync trigger
  Future<void> manualSync() async {
    await syncAll(force: true);
  }

  // Add to SyncService class
  Future<bool> checkApiHealth() async {
    try {
      final result = await _api.healthCheck();
      return result['success'] == true;
    } catch (e) {
      return false;
    }
  }

  // Dispose
  void dispose() {
    _statusController.close();
    _progressController.close();
  }
}
