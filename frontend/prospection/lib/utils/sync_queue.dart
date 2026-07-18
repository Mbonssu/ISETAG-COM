// lib/utils/sync_queue.dart
import 'dart:async';
import 'package:isar/isar.dart';
import 'package:isetagcom/models/pros.dart';
import 'package:isetagcom/models/fiche.dart';
import 'package:isetagcom/models/interet_filiere.dart';
import 'package:isetagcom/models/localStorage/local_storage.dart';
import 'package:isetagcom/models/etablissement.dart';
import 'package:isetagcom/models/classe.dart';
import 'package:isetagcom/models/specialite.dart';
import 'package:isetagcom/models/source.dart';

import '../services/api_service.dart';
import 'connection_checker.dart';
import 'status.dart';

enum QueueItemType {
  etablissement,
  source,
  classe,
  specialite,
  fiche,
  prospect,
  interet,
}

class QueueItem {
  final String id;
  final QueueItemType type;
  final Map<String, dynamic> data;
  final DateTime createdAt;
  final int priority;

  QueueItem({
    required this.id,
    required this.type,
    required this.data,
    required this.createdAt,
    this.priority = 0,
  });
}

class SyncQueue {
  final LocalStorage _storage = LocalStorage.instance;
  final ApiService _api = ApiService();
  final ConnectionChecker _connection = ConnectionChecker();

  static const int BATCH_SIZE = 25;
  static const int MAX_RETRIES = 3;
  static const Duration RETRY_DELAY = Duration(seconds: 2);

  bool _isProcessing = false;
  int _currentPage = 0;
  int _totalItems = 0;
  bool _shouldStopSync = false;
  bool _isPaused = false;

  //  Track current batch
  String? _currentBatchType;
  int _currentBatchPage = 0;
  int _consecutiveFailures = 0;

  final _queueStatusController = StreamController<bool>.broadcast();
  Stream<bool> get queueStatusStream => _queueStatusController.stream;

  final _progressController = StreamController<double>.broadcast();
  Stream<double> get progressStream => _progressController.stream;

  final _pauseStatusController = StreamController<bool>.broadcast();
  Stream<bool> get pauseStatusStream => _pauseStatusController.stream;

  Future<void> init() async {
    await _connection.init();

    if (await hasPendingItems()) {
      print('📋 Found pending items on startup');
      _queueStatusController.add(true);

      if (_connection.isConnected) {
        await processPendingItems();
      }
    }

    _connection.apiReachableStream.listen((isReachable) {
      if (isReachable && !_isProcessing) {
        print('🌐 API reachable, resuming sync...');
        _isPaused = false;
        _pauseStatusController.add(false);
        _shouldStopSync = false;
        _consecutiveFailures = 0;
        processPendingItems();
      } else if (!isReachable && _isProcessing) {
        print('📴 Connection lost, pausing sync...');
        _isPaused = true;
        _pauseStatusController.add(true);
        _shouldStopSync = true;
      }
    });
  }

  // Get pending count from ALL data types
  Future<int> getPendingCount() async {
    try {
      final pendingProspects = await _storage.isar.prospects
          .where()
          .filter()
          .syncStateEqualTo(SyncState.pending)
          .count();

      final pendingFiches = await _storage.isar.fiches
          .where()
          .filter()
          .syncStateEqualTo(SyncState.pending)
          .count();

      final pendingInterets = await _storage.isar.interetFilieres
          .where()
          .filter()
          .syncStateEqualTo(SyncState.pending)
          .count();

      final pendingSpecialites = await _storage.isar.specialites
          .where()
          .filter()
          .syncStateEqualTo(SyncState.pending)
          .count();

      final pendingEtablissements = await _storage.isar.etablissements
          .where()
          .filter()
          .syncStateEqualTo(SyncState.pending)
          .count();

      final pendingClasses = await _storage.isar.classes
          .where()
          .filter()
          .syncStateEqualTo(SyncState.pending)
          .count();

      final pendingSources = await _storage.isar.sources
          .where()
          .filter()
          .syncStateEqualTo(SyncState.pending)
          .count();

      return pendingProspects +
          pendingFiches +
          pendingInterets +
          pendingSpecialites +
          pendingEtablissements +
          pendingClasses +
          pendingSources;
    } catch (e) {
      print(' Error getting pending count: $e');
      return 0;
    }
  }

  // Check if there are pending items
  Future<bool> hasPendingItems() async {
    try {
      final count = await getPendingCount();
      return count > 0;
    } catch (e) {
      return false;
    }
  }

  //  Resume sync after connection restored
  Future<void> resumeSync() async {
    if (_isPaused && _connection.isConnected) {
      print('🔄 Resuming sync...');
      _isPaused = false;
      _pauseStatusController.add(false);
      _shouldStopSync = false;
      _consecutiveFailures = 0;
      await processPendingItems();
    }
  }

  //  Pause sync
  Future<void> pauseSync() async {
    if (_isProcessing) {
      print('⏸️ Pausing sync...');
      _isPaused = true;
      _pauseStatusController.add(true);
      _shouldStopSync = true;
    }
  }

  // Main method: Process ALL pending items with pagination
  Future<void> processPendingItems() async {
    _shouldStopSync = false;
    _consecutiveFailures = 0;

    if (_isProcessing) {
      print('⏳ Sync already in progress');
      return;
    }

    if (!_connection.isConnected) {
      print('📴 No connection, cannot process pending items');
      return;
    }

    if (!await hasPendingItems()) {
      print(' No pending items to sync');
      _queueStatusController.add(false);
      return;
    }

    _isProcessing = true;
    _currentPage = 0;
    _totalItems = await getPendingCount();
    _currentBatchPage = 0;

    print('🔄 Starting sync: $_totalItems total pending items');
    _queueStatusController.add(true);

    try {
      await _syncAllTypes();

      if (!_shouldStopSync) {
        final remaining = await getPendingCount();
        if (remaining == 0) {
          print(' All items synced successfully!');
          _queueStatusController.add(false);
          _progressController.add(1.0);
        } else {
          print('⏳ $remaining items remaining, will retry later');
          _queueStatusController.add(true);
        }
      } else {
        print('⏸️ Sync paused due to connection loss');
      }
    } catch (e) {
      print(' Sync error: $e');
    } finally {
      _isProcessing = false;
    }
  }

  // Sync all data types in priority order
  Future<void> _syncAllTypes() async {
    // 1. Etablissements
    await _syncEtablissements();
    if (_shouldStopSync) return;

    // 2. Sources
    await _syncSources();
    if (_shouldStopSync) return;

    // 3. Specialites
    await _syncSpecialites();
    if (_shouldStopSync) return;

    // 4. Prospects
    await _syncProspects();
    if (_shouldStopSync) return;

    // 5. Interets
    await _syncInterets();
  }

  //  Helper: Check connection with immediate stop and retry logic
  Future<bool> _checkConnectionOrStop() async {
    if (_consecutiveFailures >= MAX_RETRIES) {
      print(' Too many consecutive failures, pausing sync');
      _shouldStopSync = true;
      return false;
    }
    
    if (!_connection.isConnected || _shouldStopSync) {
      _shouldStopSync = true;
      print('📴 Connection lost - stopping sync');
      return false;
    }
    return true;
  }

  // Sync Etablissements
  Future<void> _syncEtablissements() async {
    try {
      int page = 0;

      while (true) {
        if (!await _checkConnectionOrStop()) break;

        final items = await _storage.isar.etablissements
            .where()
            .filter()
            .syncStateEqualTo(SyncState.pending)
            .offset(page * BATCH_SIZE)
            .limit(BATCH_SIZE)
            .findAll();

        if (items.isEmpty) break;

        print('📦 Syncing ${items.length} etablissements (batch ${page + 1})');

        for (final item in items) {
          if (!await _checkConnectionOrStop()) {
            return;
          }

          try {
            await _api.createEtablissement(item.toJsonApi());
            await _storage.isar.writeTxn(() async {
              await _storage.isar.etablissements.put(item);
            });
            print(' Synced: etablissement (${item.idEtablissement})');
            _consecutiveFailures = 0; // Reset on success
            _updateProgress();
          } catch (e) {
            if (_isConnectionError(e)) {
              print('📴 Connection error detected - pausing sync');
              _shouldStopSync = true;
              return;
            }
            _consecutiveFailures++;
            print(' Error syncing etablissement ${item.idEtablissement}: $e (attempt $_consecutiveFailures)');
            if (_consecutiveFailures >= MAX_RETRIES) {
              print(' Max retries reached, pausing sync');
              _shouldStopSync = true;
              return;
            }
            await Future.delayed(RETRY_DELAY);
          }

          await Future.delayed(const Duration(milliseconds: 100));
        }

        page++;
      }
    } catch (e) {
      if (_isConnectionError(e)) {
        _shouldStopSync = true;
        return;
      }
      print(' Error syncing etablissements: $e');
    }
  }

  // Sync Sources
  Future<void> _syncSources() async {
    try {
      int page = 0;

      while (true) {
        if (!await _checkConnectionOrStop()) break;

        final items = await _storage.isar.sources
            .where()
            .filter()
            .syncStateEqualTo(SyncState.pending)
            .offset(page * BATCH_SIZE)
            .limit(BATCH_SIZE)
            .findAll();

        if (items.isEmpty) break;

        print('📦 Syncing ${items.length} sources (batch ${page + 1})');

        for (final item in items) {
          if (!await _checkConnectionOrStop()) return;

          try {
            await _api.createSource(item.toJsonApi());
            await _storage.isar.writeTxn(() async {
              await _storage.isar.sources.put(item);
            });
            print(' Synced: source (${item.idSource})');
            _consecutiveFailures = 0;
            _updateProgress();
          } catch (e) {
            if (_isConnectionError(e)) {
              _shouldStopSync = true;
              return;
            }
            _consecutiveFailures++;
            print(' Error syncing source ${item.idSource}: $e');
            if (_consecutiveFailures >= MAX_RETRIES) {
              _shouldStopSync = true;
              return;
            }
            await Future.delayed(RETRY_DELAY);
          }

          await Future.delayed(const Duration(milliseconds: 100));
        }

        page++;
      }
    } catch (e) {
      if (_isConnectionError(e)) {
        _shouldStopSync = true;
        return;
      }
      print(' Error syncing sources: $e');
    }
  }

  // Sync Specialites
  Future<void> _syncSpecialites() async {
    try {
      int page = 0;

      while (true) {
        if (!await _checkConnectionOrStop()) break;

        final items = await _storage.isar.specialites
            .where()
            .filter()
            .syncStateEqualTo(SyncState.pending)
            .offset(page * BATCH_SIZE)
            .limit(BATCH_SIZE)
            .findAll();

        if (items.isEmpty) break;

        print('📦 Syncing ${items.length} specialites (batch ${page + 1})');

        for (final item in items) {
          if (!await _checkConnectionOrStop()) return;

          try {
            await _api.createSpecialite(item.toLocalJson());
            await _storage.isar.writeTxn(() async {
              item.syncState = SyncState.synced;
              await _storage.isar.specialites.put(item);
            });
            print(' Synced: specialite (${item.idSpecialite})');
            _consecutiveFailures = 0;
            _updateProgress();
          } catch (e) {
            if (_isConnectionError(e)) {
              _shouldStopSync = true;
              return;
            }
            _consecutiveFailures++;
            print(' Error syncing specialite ${item.idSpecialite}: $e');
            if (_consecutiveFailures >= MAX_RETRIES) {
              _shouldStopSync = true;
              return;
            }
            await Future.delayed(RETRY_DELAY);
          }

          await Future.delayed(const Duration(milliseconds: 100));
        }

        page++;
      }
    } catch (e) {
      if (_isConnectionError(e)) {
        _shouldStopSync = true;
        return;
      }
      print(' Error syncing specialites: $e');
    }
  }

  // Sync Prospects
  Future<void> _syncProspects() async {
    try {
      int page = 0;

      while (true) {
        if (!await _checkConnectionOrStop()) break;

        final items = await _storage.isar.prospects
            .where()
            .filter()
            .syncStateEqualTo(SyncState.pending)
            .offset(page * BATCH_SIZE)
            .limit(BATCH_SIZE)
            .findAll();

        if (items.isEmpty) break;

        print('📦 Syncing ${items.length} prospects (batch ${page + 1})');

        for (final item in items) {
          if (!await _checkConnectionOrStop()) return;

          try {
            await item.interets.load();
            await _api.createProspect(item.toJsonApi());
            await _storage.isar.writeTxn(() async {
              item.syncState = SyncState.synced;
              await _storage.isar.prospects.put(item);
            });
            print(' Synced: prospect (${item.idProspect})');
            _consecutiveFailures = 0;
            _updateProgress();
          } catch (e) {
            if (_isConnectionError(e)) {
              _shouldStopSync = true;
              return;
            }
            _consecutiveFailures++;
            print(' Error syncing prospect ${item.idProspect}: $e');
            if (_consecutiveFailures >= MAX_RETRIES) {
              _shouldStopSync = true;
              return;
            }
            await Future.delayed(RETRY_DELAY);
          }

          await Future.delayed(const Duration(milliseconds: 100));
        }

        page++;
      }
    } catch (e) {
      if (_isConnectionError(e)) {
        _shouldStopSync = true;
        return;
      }
      print(' Error syncing prospects: $e');
    }
  }

  // Sync Interets
  Future<void> _syncInterets() async {
    try {
      int page = 0;

      while (true) {
        if (!await _checkConnectionOrStop()) break;

        final items = await _storage.isar.interetFilieres
            .where()
            .filter()
            .syncStateEqualTo(SyncState.pending)
            .offset(page * BATCH_SIZE)
            .limit(BATCH_SIZE)
            .findAll();

        if (items.isEmpty) break;

        print('📦 Syncing ${items.length} interets (batch ${page + 1})');

        for (final item in items) {
          if (!await _checkConnectionOrStop()) return;

          try {
            await item.prospect.load();
            await item.specialite.load();
            await _api.createInteret(item.toApiJson());
            await _storage.isar.writeTxn(() async {
              item.syncState = SyncState.synced;
              await _storage.isar.interetFilieres.put(item);
            });
            print(' Synced: interet (${item.idInteret})');
            _consecutiveFailures = 0;
            _updateProgress();
          } catch (e) {
            if (_isConnectionError(e)) {
              _shouldStopSync = true;
              return;
            }
            _consecutiveFailures++;
            print(' Error syncing interet ${item.idInteret}: $e');
            if (_consecutiveFailures >= MAX_RETRIES) {
              _shouldStopSync = true;
              return;
            }
            await Future.delayed(RETRY_DELAY);
          }

          await Future.delayed(const Duration(milliseconds: 100));
        }

        page++;
      }
    } catch (e) {
      if (_isConnectionError(e)) {
        _shouldStopSync = true;
        return;
      }
      print(' Error syncing interets: $e');
    }
  }

  //  Helper: Check if error is connection-related
  bool _isConnectionError(dynamic error) {
    final errorString = error.toString().toLowerCase();
    return errorString.contains('connection') ||
           errorString.contains('network') ||
           errorString.contains('unreachable') ||
           errorString.contains('timeout') ||
           errorString.contains('socket') ||
           errorString.contains('host') ||
           errorString.contains('failed to create') ||
           errorString.contains('clientexception');
  }

  //  Helper: Update progress
  void _updateProgress() {
    // Simple progress update
  }

  // Manual sync trigger
  Future<void> syncNow() async {
    if (!_connection.isConnected) {
      print('📴 No connection, cannot sync');
      throw Exception('No internet connection');
    }

    if (_isProcessing) {
      print('⏳ Sync already in progress');
      return;
    }

    _isPaused = false;
    _pauseStatusController.add(false);
    _shouldStopSync = false;
    _consecutiveFailures = 0;

    await processPendingItems();
  }

  // Get pending count from Isar
  Future<int> getPendingItemsCount() async {
    return await getPendingCount();
  }

  // Get all pending items (for debugging)
  Future<Map<String, int>> getPendingItemsByType() async {
    try {
      return {
        'prospects': await _storage.isar.prospects
            .where()
            .filter()
            .syncStateEqualTo(SyncState.pending)
            .count(),
        'fiches': await _storage.isar.fiches
            .where()
            .filter()
            .syncStateEqualTo(SyncState.pending)
            .count(),
        'interets': await _storage.isar.interetFilieres
            .where()
            .filter()
            .syncStateEqualTo(SyncState.pending)
            .count(),
        'specialites': await _storage.isar.specialites
            .where()
            .filter()
            .syncStateEqualTo(SyncState.pending)
            .count(),
        'etablissements': await _storage.isar.etablissements
            .where()
            .filter()
            .syncStateEqualTo(SyncState.pending)
            .count(),
        'classes': await _storage.isar.classes
            .where()
            .filter()
            .syncStateEqualTo(SyncState.pending)
            .count(),
        'sources': await _storage.isar.sources
            .where()
            .filter()
            .syncStateEqualTo(SyncState.pending)
            .count(),
      };
    } catch (e) {
      return {};
    }
  }

  // Getters
  bool get isProcessing => _isProcessing;
  bool get isConnected => _connection.isConnected;
  bool get isPaused => _isPaused;
}