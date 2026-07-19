// lib/utils/sync_queue.dart

// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:math';

import 'package:isar_community/isar.dart';

import '../models/etablissement.dart';
import '../models/fiche.dart';
import '../models/interet_filiere.dart';
import '../models/localStorage/local_storage.dart';
import '../models/pros.dart';
import '../models/source.dart';
import '../models/specialite.dart';
import '../services/translation_service.dart';
import '../utils/status.dart';
import '../services/api_service.dart';
import 'connection_checker.dart';

/// Moteur de synchronisation hors-ligne -> Django.
class SyncQueue {
  static final SyncQueue _instance = SyncQueue._internal();
  factory SyncQueue() => _instance;
  SyncQueue._internal();

  final LocalStorage _storage = LocalStorage.instance;
  final ApiService _api = ApiService();
  final ConnectionChecker _connection = ConnectionChecker();

  int batchSize = 10;

  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  bool _isProcessing = false;
  bool _isPaused = false;
  bool _shouldStopSync = false;
  StreamSubscription<bool>? _apiReachableSub;

  int _totalItemsThisRun = 0;
  int _syncedItemsThisRun = 0;

  final _queueStatusController = StreamController<bool>.broadcast();
  Stream<bool> get queueStatusStream => _queueStatusController.stream;

  final _progressController = StreamController<double>.broadcast();
  Stream<double> get progressStream => _progressController.stream;

  final _pauseStatusController = StreamController<bool>.broadcast();
  Stream<bool> get pauseStatusStream => _pauseStatusController.stream;

  // ✅ Event stream for sync events
  final _syncEventController = StreamController<SyncEvent>.broadcast();
  Stream<SyncEvent> get syncEventStream => _syncEventController.stream;

  void setBatchSize(int size) {
    batchSize = size.clamp(1, 50);
    print('⚙️ Taille de lot réglée à $batchSize');
  }

  int get _concurrency => min(5, batchSize);

  Future<void> init() async {
    await _connection.init();

    _apiReachableSub ??=
        _connection.apiReachableStream.listen((reachable) async {
      if (reachable && !_isProcessing) {
        if (await hasPendingItems()) {
          print('🌐 API joignable, reprise automatique...');
          _resumeInternal();
          await processPendingItems();
        }
      } else if (!reachable && _isProcessing) {
        print('📴 Connexion/API perdue, mise en pause...');
        _pauseInternal();
      }
    });

    if (await hasPendingItems()) {
      _queueStatusController.add(true);
      if (_connection.isConnected) {
        await processPendingItems();
      }
    }
  }

  // ---------------------------------------------------------------------
  // Comptages - Updated to include toUpdate
  // ---------------------------------------------------------------------

  Future<int> getPendingCount() async {
    final byType = await getPendingItemsByType();
    return byType.values.fold<int>(0, (sum, c) => sum + c);
  }

  Future<bool> hasPendingItems() async => (await getPendingCount()) > 0;

  Future<Map<String, int>> getPendingItemsByType() async {
    try {
      final isar = _storage.isar;
      final results = await Future.wait<int>([
        // ✅ Count both pending and toUpdate for each type
        isar.prospects
            .where()
            .filter()
            .syncStateEqualTo(SyncState.pending)
            .or()
            .syncStateEqualTo(SyncState.toUpdate)
            .count(),
        isar.fiches
            .where()
            .filter()
            .syncStateEqualTo(SyncState.pending)
            .or()
            .syncStateEqualTo(SyncState.toUpdate)
            .count(),
        isar.interetFilieres
            .where()
            .filter()
            .syncStateEqualTo(SyncState.pending)
            .or()
            .syncStateEqualTo(SyncState.toUpdate)
            .count(),
        isar.specialites
            .where()
            .filter()
            .syncStateEqualTo(SyncState.pending)
            .or()
            .syncStateEqualTo(SyncState.toUpdate)
            .count(),
        isar.etablissements
            .where()
            .filter()
            .syncStateEqualTo(SyncState.pending)
            .or()
            .syncStateEqualTo(SyncState.toUpdate)
            .count(),
        isar.sources
            .where()
            .filter()
            .syncStateEqualTo(SyncState.pending)
            .or()
            .syncStateEqualTo(SyncState.toUpdate)
            .count(),
      ]);

      return {
        'prospects': results[0],
        'fiches': results[1],
        'interets': results[2],
        'specialites': results[3],
        'etablissements': results[4],
        'sources': results[5],
      };
    } catch (e) {
      print('❌ Erreur getPendingItemsByType: $e');
      return {};
    }
  }

  // ✅ Get items that need update (toUpdate status)
  Future<Map<String, int>> getUpdateItemsByType() async {
    try {
      final isar = _storage.isar;
      final results = await Future.wait<int>([
        isar.prospects
            .where()
            .filter()
            .syncStateEqualTo(SyncState.toUpdate)
            .count(),
        isar.fiches
            .where()
            .filter()
            .syncStateEqualTo(SyncState.toUpdate)
            .count(),
        isar.interetFilieres
            .where()
            .filter()
            .syncStateEqualTo(SyncState.toUpdate)
            .count(),
        isar.specialites
            .where()
            .filter()
            .syncStateEqualTo(SyncState.toUpdate)
            .count(),
        isar.etablissements
            .where()
            .filter()
            .syncStateEqualTo(SyncState.toUpdate)
            .count(),
        isar.sources
            .where()
            .filter()
            .syncStateEqualTo(SyncState.toUpdate)
            .count(),
      ]);

      return {
        'prospects': results[0],
        'fiches': results[1],
        'interets': results[2],
        'specialites': results[3],
        'etablissements': results[4],
        'sources': results[5],
      };
    } catch (e) {
      print('❌ Erreur getUpdateItemsByType: $e');
      return {};
    }
  }

  Future<int> getFailedCount() async {
    final byType = await getFailedItemsByType();
    return byType.values.fold<int>(0, (sum, c) => sum + c);
  }

  Future<Map<String, int>> getFailedItemsByType() async {
    final isar = _storage.isar;
    final results = await Future.wait<int>([
      isar.prospects
          .where()
          .filter()
          .syncStateEqualTo(SyncState.failed)
          .count(),
      isar.fiches.where().filter().syncStateEqualTo(SyncState.failed).count(),
      isar.interetFilieres
          .where()
          .filter()
          .syncStateEqualTo(SyncState.failed)
          .count(),
      isar.specialites
          .where()
          .filter()
          .syncStateEqualTo(SyncState.failed)
          .count(),
      isar.etablissements
          .where()
          .filter()
          .syncStateEqualTo(SyncState.failed)
          .count(),
      isar.sources.where().filter().syncStateEqualTo(SyncState.failed).count(),
    ]);
    return {
      'prospects': results[0],
      'fiches': results[1],
      'interets': results[2],
      'specialites': results[3],
      'etablissements': results[4],
      'sources': results[5],
    };
  }

  Future<int> getSyncedCount() async {
    final isar = _storage.isar;
    final results = await Future.wait<int>([
      isar.prospects
          .where()
          .filter()
          .syncStateEqualTo(SyncState.synced)
          .count(),
      isar.fiches.where().filter().syncStateEqualTo(SyncState.synced).count(),
      isar.interetFilieres
          .where()
          .filter()
          .syncStateEqualTo(SyncState.synced)
          .count(),
      isar.specialites
          .where()
          .filter()
          .syncStateEqualTo(SyncState.synced)
          .count(),
      isar.etablissements
          .where()
          .filter()
          .syncStateEqualTo(SyncState.synced)
          .count(),
      isar.sources.where().filter().syncStateEqualTo(SyncState.synced).count(),
    ]);
    return results.fold<int>(0, (sum, c) => sum + c);
  }

  Future<int> getPendingItemsCount() => getPendingCount();

  // ---------------------------------------------------------------------
  // Contrôle (pause / reprise / relance des échecs)
  // ---------------------------------------------------------------------

  void _pauseInternal() {
    _isPaused = true;
    _shouldStopSync = true;
    _pauseStatusController.add(true);
  }

  void _resumeInternal() {
    _isPaused = false;
    _shouldStopSync = false;
    _pauseStatusController.add(false);
  }

  Future<void> pauseSync() async {
    if (_isProcessing) {
      print('⏸️ Pause de la synchro demandée...');
      _pauseInternal();
    }
  }

  Future<void> resumeSync() async {
    if (_isPaused && _connection.isConnected) {
      print('▶️ Reprise de la synchro...');
      _resumeInternal();
      await processPendingItems();
    }
  }

  Future<void> togglePause() async {
    if (_isPaused) {
      await resumeSync();
    } else {
      await pauseSync();
    }
  }

  Future<int> retryFailedItems() async {
    final isar = _storage.isar;
    var count = 0;

    await isar.writeTxn(() async {
      // Reset failed items to pending for retry
      for (final item in await isar.etablissements
          .where()
          .filter()
          .syncStateEqualTo(SyncState.failed)
          .findAll()) {
        item.syncState = SyncState.pending;
        await isar.etablissements.put(item);
        count++;
      }
      for (final item in await isar.sources
          .where()
          .filter()
          .syncStateEqualTo(SyncState.failed)
          .findAll()) {
        item.syncState = SyncState.pending;
        await isar.sources.put(item);
        count++;
      }
      for (final item in await isar.fiches
          .where()
          .filter()
          .syncStateEqualTo(SyncState.failed)
          .findAll()) {
        item.syncState = SyncState.pending;
        await isar.fiches.put(item);
        count++;
      }
      for (final item in await isar.specialites
          .where()
          .filter()
          .syncStateEqualTo(SyncState.failed)
          .findAll()) {
        item.syncState = SyncState.pending;
        await isar.specialites.put(item);
        count++;
      }
      for (final item in await isar.prospects
          .where()
          .filter()
          .syncStateEqualTo(SyncState.failed)
          .findAll()) {
        item.syncState = SyncState.pending;
        await isar.prospects.put(item);
        count++;
      }
      for (final item in await isar.interetFilieres
          .where()
          .filter()
          .syncStateEqualTo(SyncState.failed)
          .findAll()) {
        item.syncState = SyncState.pending;
        await isar.interetFilieres.put(item);
        count++;
      }
    });

    print('🔁 $count élément(s) remis en attente pour nouvelle tentative');

    if (count > 0 && _connection.isConnected) {
      await processPendingItems();
    }
    return count;
  }

  // ---------------------------------------------------------------------
  // Boucle principale - Updated to handle toUpdate first
  // ---------------------------------------------------------------------

  Future<void> syncNow({int? overrideBatchSize}) async {
    if (overrideBatchSize != null) setBatchSize(overrideBatchSize);

    if (!_connection.isConnected) {
      print('📴 Pas de connexion, synchro impossible');
      throw Exception('No internet connection');
    }
    if (_isProcessing) {
      print('⏳ Synchro déjà en cours');
      return;
    }
    _resumeInternal();
    await processPendingItems();
  }

  Future<void> processPendingItems() async {
    if (_isProcessing) return;
    if (!_connection.isConnected) return;
    if (!await hasPendingItems()) {
      _queueStatusController.add(false);
      return;
    }

    _isProcessing = true;
    _shouldStopSync = false;
    _totalItemsThisRun = await getPendingCount();
    _syncedItemsThisRun = 0;
    _queueStatusController.add(true);
    _progressController.add(0.0);

    // ✅ Emit started event
    _syncEventController.add(SyncEvent(type: SyncEventType.started));

    print('🔄 Démarrage synchro : $_totalItemsThisRun élément(s) en attente '
        '(lots de $batchSize, $_concurrency en parallèle)');

    int passCount = 0;
    const int maxPasses = 10;
    int previousRemaining = _totalItemsThisRun;

    try {
      while (!_shouldStopSync && passCount < maxPasses) {
        passCount++;
        // ✅ Sync toUpdate items first (priority)
        await _syncAllTypesInDependencyOrder();
        if (_shouldStopSync) break;

        final remaining = await getPendingCount();
        if (remaining == 0) {
          print('✅ Tout est synchronisé !');
          _syncEventController.add(SyncEvent(type: SyncEventType.completed));
          break;
        }

        if (passCount > 1 && remaining == previousRemaining) {
          print(
              '⚠️ $remaining élément(s) bloqués (aucune progression) - arrêt');
          break;
        }

        print(
            '⏳ $remaining élément(s) restants, nouvelle passe #$passCount...');
        previousRemaining = remaining;
        _totalItemsThisRun = remaining;
      }

      if (passCount >= maxPasses) {
        print('⚠️ Nombre maximum de passes atteint ($maxPasses) - arrêt');
      }
    } catch (e) {
      print('❌ Erreur fatale de synchro: $e');
      _syncEventController.add(SyncEvent(
        type: SyncEventType.error,
        message: e.toString(),
      ));
    } finally {
      _isProcessing = false;
    }

    final remaining = await getPendingCount();
    if (remaining == 0) {
      _queueStatusController.add(false);
      _progressController.add(1.0);
    } else if (!_isPaused) {
      _queueStatusController.add(true);
    }
  }

  Future<void> _syncAllTypesInDependencyOrder() async {
    // ✅ 1. Sync toUpdate items first (priority)
    await _syncUpdates();
    if (_shouldStopSync) return;

    // ✅ 2. Then sync pending items
    await _syncFiches();
    if (_shouldStopSync) return;

    await _syncEtablissements();
    if (_shouldStopSync) return;

    await _syncProspects();
    if (_shouldStopSync) return;

    await _syncSpecialites();
    if (_shouldStopSync) return;

    await _syncInterets();
  }

  // ---------------------------------------------------------------------
  // Sync Updates (toUpdate items - priority)
  // ---------------------------------------------------------------------

  Future<void> _syncUpdates() async {
    // ✅ Sync prospects toUpdate first
    await _syncProspectsUpdates();
    if (_shouldStopSync) return;

    // ✅ Sync fiches toUpdate
    await _syncFichesUpdates();
    if (_shouldStopSync) return;

    // ✅ Sync interets toUpdate
    await _syncInteretsUpdates();
    if (_shouldStopSync) return;
  }

  // ---------------------------------------------------------------------
  // Sync by type - with update support
  // ---------------------------------------------------------------------

  Future<void> _syncSources() async {
    while (true) {
      if (!_connection.isConnected || _shouldStopSync) return;

      final batch = await _storage.isar.sources
          .where()
          .filter()
          .syncStateEqualTo(SyncState.pending)
          .limit(batchSize)
          .findAll();
      if (batch.isEmpty) return;

      print('📦 Sources : lot de ${batch.length}');
      await _runBounded(batch, (item) async {
        await _syncSingle(
          label: 'source',
          idOf: () => item.idSource,
          send: () => _api.createSource(item.toJsonApi()),
          markSynced: () async {
            await _storage.isar.writeTxn(() async {
              item.syncState = SyncState.synced;
              await _storage.isar.sources.put(item);
            });
          },
          markFailed: () async {
            await _storage.isar.writeTxn(() async {
              item.syncState = SyncState.failed;
              await _storage.isar.sources.put(item);
            });
          },
        );
      });

      if (_shouldStopSync) return;
    }
  }

  // ✅ Sync fiches pending
  Future<void> _syncFiches() async {
    while (true) {
      if (!_connection.isConnected || _shouldStopSync) return;

      final batch = await _storage.isar.fiches
          .where()
          .filter()
          .syncStateEqualTo(SyncState.pending)
          .limit(batchSize)
          .findAll();
      if (batch.isEmpty) return;

      print('📦 Fiches : lot de ${batch.length}');
      await _runBounded(batch, (item) async {
        await _syncSingle(
          label: 'fiche',
          idOf: () => item.idFiche,
          send: () async {
            final payload = await item.toJsonApi();
            payload['idSrc'] = item.idSrc;
            return _api.createFiche(payload);
          },
          markSynced: () async {
            await _storage.isar.writeTxn(() async {
              item.syncState = SyncState.synced;
              await _storage.isar.fiches.put(item);
            });
          },
          markFailed: () async {
            await _storage.isar.writeTxn(() async {
              item.syncState = SyncState.failed;
              await _storage.isar.fiches.put(item);
            });
          },
        );
      });

      if (_shouldStopSync) return;
    }
  }

  // ✅ Sync fiches toUpdate (priority)
  Future<void> _syncFichesUpdates() async {
    while (true) {
      if (!_connection.isConnected || _shouldStopSync) return;

      final batch = await _storage.isar.fiches
          .where()
          .filter()
          .syncStateEqualTo(SyncState.toUpdate)
          .limit(batchSize)
          .findAll();
      if (batch.isEmpty) return;

      print('📦 Fiches à mettre à jour : lot de ${batch.length}');
      await _runBounded(batch, (item) async {
        await _syncSingle(
          label: 'fiche (update)',
          idOf: () => item.idFiche,
          send: () async {
            final payload = await item.toJsonApi();
            payload['idSrc'] = item.idSrc;
            return _api.updateFiche(item.idFiche, payload);
          },
          markSynced: () async {
            await _storage.isar.writeTxn(() async {
              item.syncState = SyncState.synced;
              await _storage.isar.fiches.put(item);
            });
          },
          markFailed: () async {
            await _storage.isar.writeTxn(() async {
              item.syncState = SyncState.failed;
              await _storage.isar.fiches.put(item);
            });
          },
        );
      });

      if (_shouldStopSync) return;
    }
  }

  Future<void> _syncEtablissements() async {
    while (true) {
      if (!_connection.isConnected || _shouldStopSync) return;

      final batch = await _storage.isar.etablissements
          .where()
          .filter()
          .syncStateEqualTo(SyncState.pending)
          .limit(batchSize)
          .findAll();
      if (batch.isEmpty) return;

      print('📦 Étab. : lot de ${batch.length}');
      await _runBounded(batch, (item) async {
        await _syncSingle(
          label: 'etablissement',
          idOf: () => item.idEtablissement,
          send: () => _api.createEtablissement(item.toJsonApi()),
          markSynced: () async {
            await _storage.isar.writeTxn(() async {
              item.syncState = SyncState.synced;
              await _storage.isar.etablissements.put(item);
            });
          },
          markFailed: () async {
            await _storage.isar.writeTxn(() async {
              item.syncState = SyncState.failed;
              await _storage.isar.etablissements.put(item);
            });
          },
        );
      });

      if (_shouldStopSync) return;
    }
  }

  // ✅ Sync prospects pending
  Future<void> _syncProspects() async {
    while (true) {
      if (!_connection.isConnected || _shouldStopSync) return;

      final batch = await _storage.isar.prospects
          .where()
          .filter()
          .syncStateEqualTo(SyncState.pending)
          .limit(batchSize)
          .findAll();
      if (batch.isEmpty) return;

      print('📦 Prospects : lot de ${batch.length}');
      await _runBounded(batch, (item) async {
        await item.interets.load();
        await _syncSingle(
          label: 'prospect',
          idOf: () => item.idProspect,
          send: () => _api.createProspect(item.toJsonApi()),
          markSynced: () async {
            await _storage.isar.writeTxn(() async {
              item.syncState = SyncState.synced;
              await _storage.isar.prospects.put(item);
            });
          },
          markFailed: () async {
            await _storage.isar.writeTxn(() async {
              item.syncState = SyncState.failed;
              await _storage.isar.prospects.put(item);
            });
          },
        );
      });

      if (_shouldStopSync) return;
    }
  }

  // ✅ Sync prospects toUpdate (priority)
  Future<void> _syncProspectsUpdates() async {
    while (true) {
      if (!_connection.isConnected || _shouldStopSync) return;

      final batch = await _storage.isar.prospects
          .where()
          .filter()
          .syncStateEqualTo(SyncState.toUpdate)
          .limit(batchSize)
          .findAll();
      if (batch.isEmpty) return;

      print('📦 Prospects à mettre à jour : lot de ${batch.length}');
      await _runBounded(batch, (item) async {
        await item.interets.load();
        await _syncSingle(
          label: 'prospect (update)',
          idOf: () => item.idProspect,
          send: () => _api.updateProspect(item.idProspect, item.toJsonApi()),
          markSynced: () async {
            await _storage.isar.writeTxn(() async {
              item.syncState = SyncState.synced;
              await _storage.isar.prospects.put(item);
            });
          },
          markFailed: () async {
            await _storage.isar.writeTxn(() async {
              item.syncState = SyncState.failed;
              await _storage.isar.prospects.put(item);
            });
          },
        );
      });

      if (_shouldStopSync) return;
    }
  }

  Future<void> _syncSpecialites() async {
    while (true) {
      if (!_connection.isConnected || _shouldStopSync) return;

      final batch = await _storage.isar.specialites
          .where()
          .filter()
          .syncStateEqualTo(SyncState.pending)
          .limit(batchSize)
          .findAll();
      if (batch.isEmpty) return;

      print('📦 Spécialités : lot de ${batch.length}');
      await _runBounded(batch, (item) async {
        await _syncSingle(
          label: 'specialite',
          idOf: () => item.idSpecialite,
          send: () => _api.createSpecialite(item.toJsonApi()),
          markSynced: () async {
            await _storage.isar.writeTxn(() async {
              item.syncState = SyncState.synced;
              await _storage.isar.specialites.put(item);
            });
          },
          markFailed: () async {
            await _storage.isar.writeTxn(() async {
              item.syncState = SyncState.failed;
              await _storage.isar.specialites.put(item);
            });
          },
        );
      });

      if (_shouldStopSync) return;
    }
  }

  // ✅ Sync interets pending
  Future<void> _syncInterets() async {
    while (true) {
      if (!_connection.isConnected || _shouldStopSync) return;

      final batch = await _storage.isar.interetFilieres
          .where()
          .filter()
          .syncStateEqualTo(SyncState.pending)
          .limit(batchSize)
          .findAll();
      if (batch.isEmpty) return;

      print('📦 Intérêts filière : lot de ${batch.length}');
      await _runBounded(batch, (item) async {
        await item.prospect.load();
        await item.specialite.load();
        await _syncSingle(
          label: 'interet',
          idOf: () => item.idInteret,
          send: () => _api.createInteret(item.toJsonApi()),
          markSynced: () async {
            await _storage.isar.writeTxn(() async {
              item.syncState = SyncState.synced;
              await _storage.isar.interetFilieres.put(item);
            });
          },
          markFailed: () async {
            await _storage.isar.writeTxn(() async {
              item.syncState = SyncState.failed;
              await _storage.isar.interetFilieres.put(item);
            });
          },
        );
      });

      if (_shouldStopSync) return;
    }
  }

  // ✅ Sync interets toUpdate (priority)
  Future<void> _syncInteretsUpdates() async {
    while (true) {
      if (!_connection.isConnected || _shouldStopSync) return;

      final batch = await _storage.isar.interetFilieres
          .where()
          .filter()
          .syncStateEqualTo(SyncState.toUpdate)
          .limit(batchSize)
          .findAll();
      if (batch.isEmpty) return;

      print('📦 Intérêts filière à mettre à jour : lot de ${batch.length}');
      await _runBounded(batch, (item) async {
        await item.prospect.load();
        await item.specialite.load();
        await _syncSingle(
          label: 'interet (update)',
          idOf: () => item.idInteret,
          send: () => _api.updateInteret(item.idInteret, item.toJsonApi()),
          markSynced: () async {
            await _storage.isar.writeTxn(() async {
              item.syncState = SyncState.synced;
              await _storage.isar.interetFilieres.put(item);
            });
          },
          markFailed: () async {
            await _storage.isar.writeTxn(() async {
              item.syncState = SyncState.failed;
              await _storage.isar.interetFilieres.put(item);
            });
          },
        );
      });

      if (_shouldStopSync) return;
    }
  }

  // ---------------------------------------------------------------------
  // Primitives partagées
  // ---------------------------------------------------------------------

  Future<void> _runBounded<T>(
    List<T> items,
    Future<void> Function(T item) task,
  ) async {
    final iterator = items.iterator;

    Future<void> worker() async {
      while (iterator.moveNext()) {
        if (_shouldStopSync) return;
        await task(iterator.current);
      }
    }

    await Future.wait(List.generate(_concurrency, (_) => worker()));
  }

  Future<void> _syncSingle({
    required String label,
    required String Function() idOf,
    required Future<Map<String, dynamic>> Function() send,
    required Future<void> Function() markSynced,
    required Future<void> Function() markFailed,
  }) async {
    var attempts = 0;

    while (attempts < maxRetries) {
      if (!_connection.isConnected || _shouldStopSync) return;
      attempts++;

      try {
        final response = await send();

        final isSuccess = response['statusCode'] == 200 ||
            response['statusCode'] == 201 ||
            response['statusCode'] == 204 ||
            response['success'] == true;

        if (isSuccess) {
          await markSynced();
          _syncedItemsThisRun++;
          _updateProgress();
          print('✅ Synchronisé : $label (${idOf()})');
          return;
        }

        final statusCode =
            response['statusCode'] ?? response['code'] ?? 'unknown';
        final message =
            response['message'] ?? response['error'] ?? 'Erreur inconnue';

        if (statusCode == 400 || statusCode == 404) {
          print(
              '❌ Erreur validation ($statusCode) : $label (${idOf()}) → $message');
          await markFailed();
          return;
        }

        print(
            '❌ Rejeté par le serveur : $label (${idOf()}) → Code $statusCode : $message');
        await markFailed();
        return;
      } catch (e) {
        if (_isConnectionError(e)) {
          print('📴 Connexion perdue pendant l\'envoi de $label (${idOf()})');
          _pauseInternal();
          _syncEventController.add(SyncEvent(
            type: SyncEventType.error,
            message: 'connection_lost_during_sync'.tr,
          ));
          return;
        }

        print(
            '⚠️ Erreur sur $label (${idOf()}), tentative $attempts/$maxRetries : $e');
        if (attempts >= maxRetries) {
          await markFailed();
          _syncEventController.add(SyncEvent(
            type: SyncEventType.error,
            message: e.toString(),
          ));
          return;
        }
        await Future.delayed(retryDelay * attempts);
      }
    }
  }

  bool _isConnectionError(dynamic error) {
    final s = error.toString().toLowerCase();
    return s.contains('connection') ||
        s.contains('network') ||
        s.contains('unreachable') ||
        s.contains('timeout') ||
        s.contains('socket') ||
        s.contains('host') ||
        s.contains('clientexception');
  }

  void _updateProgress() {
    if (_totalItemsThisRun == 0) return;
    _progressController.add(_syncedItemsThisRun / _totalItemsThisRun);
  }

  // ---------------------------------------------------------------------
  // Getters
  // ---------------------------------------------------------------------

  bool get isProcessing => _isProcessing;
  bool get isConnected => _connection.isConnected;
  bool get isPaused => _isPaused;
  int get totalItemsThisRun => _totalItemsThisRun;
  int get syncedItemsThisRun => _syncedItemsThisRun;

  void dispose() {
    _apiReachableSub?.cancel();
    _queueStatusController.close();
    _progressController.close();
    _pauseStatusController.close();
    _syncEventController.close();
  }
}

// ✅ SyncEvent classes
enum SyncEventType {
  started,
  progress,
  completed,
  error,
  paused,
  resumed,
}

class SyncEvent {
  final SyncEventType type;
  final String? message;
  final int? progress;

  SyncEvent({required this.type, this.message, this.progress});
}
