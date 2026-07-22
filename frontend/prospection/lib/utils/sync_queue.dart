// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:math';

import 'package:isar_community/isar.dart';

import '../models/etablissement.dart';
import '../models/fiche.dart';
import '../models/interet_filiere.dart';
import '../models/localStorage/local_storage.dart';
import '../models/pros.dart';
import '../models/relance.dart';
import '../models/source.dart';
import '../models/specialite.dart';
import '../services/translation_service.dart';
import '../utils/status.dart';
import '../services/api_service.dart';
import 'connection_checker.dart';

/// ✅ FIXED: Moteur de synchronisation hors-ligne -> Django avec gestion des dépendances
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

  // ✅ NEW: Track synced remote IDs to avoid orphaned data
  final Set<String> _syncedFicheIds = {};
  final Set<String> _syncedProspectIds = {};
  final Set<String> _syncedRelanceIds = {};

  final _queueStatusController = StreamController<bool>.broadcast();
  Stream<bool> get queueStatusStream => _queueStatusController.stream;

  final _progressController = StreamController<double>.broadcast();
  Stream<double> get progressStream => _progressController.stream;

  final _pauseStatusController = StreamController<bool>.broadcast();
  Stream<bool> get pauseStatusStream => _pauseStatusController.stream;

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

  // ✅ FIXED: Updated to include relances
  Future<int> getPendingCount() async {
    final byType = await getPendingItemsByType();
    return byType.values.fold<int>(0, (sum, c) => sum + c);
  }

  Future<bool> hasPendingItems() async => (await getPendingCount()) > 0;

  Future<Map<String, int>> getPendingItemsByType() async {
    try {
      final isar = _storage.isar;
      final results = await Future.wait<int>([
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
        // ✅ Include relances in pending count
        isar.relances
            .where()
            .filter()
            .syncStateBetween(SyncState.pending, SyncState.toUpdate)
            .count(),
      ]);

      return {
        'prospects': results[0],
        'fiches': results[1],
        'interets': results[2],
        'specialites': results[3],
        'etablissements': results[4],
        'sources': results[5],
        'relances': results[6],
      };
    } catch (e) {
      print('❌ Erreur getPendingItemsByType: $e');
      return {};
    }
  }

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
        isar.relances
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
        'relances': results[6],
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
      isar.relances
          .where()
          .filter()
          .syncStateEqualTo(SyncState.failed)
          .count(),
    ]);
    return {
      'prospects': results[0],
      'fiches': results[1],
      'interets': results[2],
      'specialites': results[3],
      'etablissements': results[4],
      'sources': results[5],
      'relances': results[6],
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
      isar.relances
          .where()
          .filter()
          .syncStateEqualTo(SyncState.synced)
          .count(),
    ]);
    return results.fold<int>(0, (sum, c) => sum + c);
  }

  Future<int> getPendingItemsCount() => getPendingCount();

  // ✅ CONTROL (pause / resume / retry failed items)
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
      for (final item in await isar.relances
          .where()
          .filter()
          .syncStateEqualTo(SyncState.failed)
          .findAll()) {
        item.syncState = SyncState.pending;
        await isar.relances.put(item);
        count++;
      }
    });

    print('🔁 $count élément(s) remis en attente pour nouvelle tentative');

    if (count > 0 && _connection.isConnected) {
      await processPendingItems();
    }
    return count;
  }

  // ✅ MAIN LOOP WITH DEPENDENCY MANAGEMENT
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
    
    // ✅ Clear synced IDs tracking at start of sync run
    _syncedFicheIds.clear();
    _syncedProspectIds.clear();
    _syncedRelanceIds.clear();
    
    _queueStatusController.add(true);
    _progressController.add(0.0);

    _syncEventController.add(SyncEvent(type: SyncEventType.started));

    print('🔄 Démarrage synchro : $_totalItemsThisRun élément(s) en attente '
        '(lots de $batchSize, $_concurrency en parallèle)');

    int passCount = 0;
    const int maxPasses = 10;
    int previousRemaining = _totalItemsThisRun;

    try {
      while (!_shouldStopSync && passCount < maxPasses) {
        passCount++;
        // ✅ Sync with dependency order
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

  // ✅ DEPENDENCY ORDER SYNC:
  // 1. Fiches (must sync before prospects that reference them)
  // 2. Prospects (must sync before interets and relances)
  // 3. Specialites (must sync before interets)
  // 4. Interets (depends on prospects & specialites)
  // 5. Relances (depends on prospects, only pending & toUpdate, no deletion)
  Future<void> _syncAllTypesInDependencyOrder() async {
    // Priority 1: Sync toUpdate items first (edits to existing records)
    await _syncUpdates();
    if (_shouldStopSync) return;

    // Priority 2: Establishment & source (foundational data)
    await _syncEtablissements();
    if (_shouldStopSync) return;

    await _syncSources();
    if (_shouldStopSync) return;

    // Priority 3: Fiches (needed by prospects)
    await _syncFiches();
    if (_shouldStopSync) return;

    // Priority 4: Prospects (needed by interets & relances)
    await _syncProspects();
    if (_shouldStopSync) return;

    // Priority 5: Specialites (needed by interets)
    await _syncSpecialites();
    if (_shouldStopSync) return;

    // Priority 6: Interets (depends on prospects & specialites)
    await _syncInterets();
    if (_shouldStopSync) return;

    // Priority 7: Relances (depends on prospects, must be LAST)
    await _syncRelances();
    if (_shouldStopSync) return;
  }

  // ✅ Sync toUpdate items (priority)
  Future<void> _syncUpdates() async {
    await _syncProspectsUpdates();
    if (_shouldStopSync) return;
    await _syncFichesUpdates();
    if (_shouldStopSync) return;
    await _syncInteretsUpdates();
    if (_shouldStopSync) return;
  }

  // ===== FICHE SYNC (must come before prospects) =====

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
            _syncedFicheIds.add(item.idFiche);
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
            _syncedFicheIds.add(item.idFiche);
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

  // ===== PROSPECT SYNC (must come after fiches) =====

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
        // ✅ CRITICAL: Check if fiche is synced before syncing prospect
        await item.fiche.load();
        if (item.fiche.value != null && !_syncedFicheIds.contains(item.fiche.value!.idFiche)) {
          print('⏳ Prospect ${item.idProspect} : sa fiche n\'est pas encore synchronisée, renvoi en attente');
          // Mark as still pending if fiche not synced
          return;
        }

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
            _syncedProspectIds.add(item.idProspect);
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
            _syncedProspectIds.add(item.idProspect);
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

  // ===== ESTABLISHMENT & SOURCE SYNC =====

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

  // ===== SPECIALITE & INTERET SYNC =====

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

  // ✅ RELANCE SYNC (must be LAST - after prospects are synced)
  // Critical: Only sync pending & toUpdate (no deletion), prevent duplicates
  Future<void> _syncRelances() async {
    while (true) {
      if (!_connection.isConnected || _shouldStopSync) return;

      final batch = await _storage.isar.relances
          .where()
          .filter()
          .syncStateBetween(SyncState.pending, SyncState.toUpdate)
          .limit(batchSize)
          .findAll();
      if (batch.isEmpty) return;

      print('📦 Relances à créer/mettre à jour : lot de ${batch.length}');
      
      // ✅ Filter: Only sync relances whose prospect is already synced
      final validBatch = <Relance>[];
      for (final relance in batch) {
        await relance.prospect.load();
        if (relance.prospect.value != null && 
            _syncedProspectIds.contains(relance.prospects.value!.idProspect)) {
          validBatch.add(relance);
        } else {
          print('⏳ Relance ${relance.idRelance} : son prospect n\'est pas encore synchronisé');
        }
      }

      if (validBatch.isEmpty) return;

      await _runBounded(validBatch, _syncSingleRelance);
      if (_shouldStopSync) return;
    }
  }

  /// ✅ CRITICAL: Sync a single relance (create or update)
  /// Prevents duplicate sends by checking sync state
  Future<void> _syncSingleRelance(Relance item) async {
    // ✅ Double-check the relance is not already synced (prevent duplicates)
    if (item.syncState == SyncState.synced) {
      print('⏭️ Relance ${item.idRelance} déjà synchronisée, passée');
      _syncedRelanceIds.add(item.idRelance);
      return;
    }

    await _syncSingle(
      label: 'relance',
      idOf: () => item.idRelance,
      send: () async {
        if (item.syncState == SyncState.pending) {
          return await _api.createRelance(item.toJsonApi());
        } else {
          // toUpdate
          return await _api.updateRelance(item.idRelance, item.toJsonApi());
        }
      },
      markSynced: () async {
        await _storage.isar.writeTxn(() async {
          item.syncState = SyncState.synced;
          await _storage.isar.relances.put(item);
        });
        _syncedRelanceIds.add(item.idRelance);
      },
      markFailed: () async {
        await _storage.isar.writeTxn(() async {
          item.syncState = SyncState.failed;
          await _storage.isar.relances.put(item);
        });
      },
    );
  }

  // ===== SHARED PRIMITIVES =====

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

  // GETTERS
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

// ✅ SYNC EVENT CLASSES
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
