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
  
  bool _isProcessing = false;
  int _currentPage = 0;
  int _totalItems = 0;
  
  final _queueStatusController = StreamController<bool>.broadcast();
  Stream<bool> get queueStatusStream => _queueStatusController.stream;
  
  final _progressController = StreamController<double>.broadcast();
  Stream<double> get progressStream => _progressController.stream;

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
      print('❌ Error getting pending count: $e');
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
        print('🌐 API reachable, checking for pending items...');
        processPendingItems();
      }
    });
  }

  // Main method: Process ALL pending items with pagination
  Future<void> processPendingItems() async {
    if (_isProcessing) {
      print('⏳ Sync already in progress');
      return;
    }

    if (!_connection.isConnected) {
      print('📴 No connection, cannot process pending items');
      return;
    }

    if (!await hasPendingItems()) {
      print('✅ No pending items to sync');
      _queueStatusController.add(false);
      return;
    }

    _isProcessing = true;
    _currentPage = 0;
    _totalItems = await getPendingCount();
    
    print('🔄 Starting sync: $_totalItems total pending items');
    _queueStatusController.add(true);

    try {
      // Sync in priority order (highest priority first)
      await _syncAllTypes();
      
      // Final check
      final remaining = await getPendingCount();
      if (remaining == 0) {
        print('✅ All items synced successfully!');
        _queueStatusController.add(false);
        _progressController.add(1.0);
      } else {
        print('⏳ $remaining items remaining, will retry later');
        _queueStatusController.add(true);
      }

    } catch (e) {
      print('❌ Sync error: $e');
    } finally {
      _isProcessing = false;
    }
  }

  // Sync all data types in priority order
  Future<void> _syncAllTypes() async {
    // 1. Etablissements (highest priority)
    await _syncEtablissements();

    // 2. Sources
    // await _syncSources(); // The agent do not need to sync source, cause it come from db once connected to the app

    // 3. Classes
    await _syncClasses();

    // 4. Specialites
    await _syncSpecialites();

    // 5. Fiches
    // await _syncFiches();// The agent do not need to sync fiche, cause it come from db once connected to the app

    // 6. Prospects
    await _syncProspects();

    // 7. Interets (lowest priority)
    await _syncInterets();
  }

  //  Sync Etablissements
  Future<void> _syncEtablissements() async {
    try {
      int page = 0;
      
      while (true) {
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
          try {
            await _api.createEtablissement(item.toJsonApi());
            
            // Mark as synced
            await _storage.isar.writeTxn(() async {
              // item.syncState = SyncState.synced;
              await _storage.isar.etablissements.put(item);
            });
            
            print('✅ Synced: etablissement (${item.idEtablissement})');
            
          } catch (e) {
            print('❌ Error syncing etablissement ${item.idEtablissement}: $e');
          }
          
          await Future.delayed(const Duration(milliseconds: 100));
        }
        
        page++;
        
        if (!_connection.isConnected) {
          print('📴 Connection lost, pausing etablissement sync');
          break;
        }
      }
      
    } catch (e) {
      print('❌ Error syncing etablissements: $e');
    }
  }

  //  Sync Sources
  Future<void> _syncSources() async {
    try {
      int page = 0;
      
      while (true) {
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
          try {
            await _api.createSource(item.toJsonApi());
            
            await _storage.isar.writeTxn(() async {
              // item.syncState = SyncState.synced;
              await _storage.isar.sources.put(item);
            });
            
            print('✅ Synced: source (${item.idSource})');
            
          } catch (e) {
            print('❌ Error syncing source ${item.idSource}: $e');
          }
          
          await Future.delayed(const Duration(milliseconds: 100));
        }
        
        page++;
        
        if (!_connection.isConnected) {
          print('📴 Connection lost, pausing source sync');
          break;
        }
      }
      
    } catch (e) {
      print('❌ Error syncing sources: $e');
    }
  }

  //  Sync Classes
  Future<void> _syncClasses() async {
    try {
      int page = 0;
      
      while (true) {
        final items = await _storage.isar.classes
            .where()
            .filter()
            .syncStateEqualTo(SyncState.pending)
            .offset(page * BATCH_SIZE)
            .limit(BATCH_SIZE)
            .findAll();
        
        if (items.isEmpty) break;
        
        print('📦 Syncing ${items.length} classes (batch ${page + 1})');
        
        for (final item in items) {
          try {
            await _api.createClasse(item.toJsonApi());
            
            await _storage.isar.writeTxn(() async {
              // item.syncState = SyncState.synced;
              await _storage.isar.classes.put(item);
            });
            
            print('✅ Synced: classe (${item.idClasse})');
            
          } catch (e) {
            print('❌ Error syncing classe ${item.idClasse}: $e');
          }
          
          await Future.delayed(const Duration(milliseconds: 100));
        }
        
        page++;
        
        if (!_connection.isConnected) {
          print('📴 Connection lost, pausing classe sync');
          break;
        }
      }
      
    } catch (e) {
      print('❌ Error syncing classes: $e');
    }
  }

  //  Sync Specialites
  Future<void> _syncSpecialites() async {
    try {
      int page = 0;
      
      while (true) {
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
          try {
            await _api.createSpecialite(item.toLocalJson());
            
            await _storage.isar.writeTxn(() async {
              item.syncState = SyncState.synced;
              await _storage.isar.specialites.put(item);
            });
            
            print('✅ Synced: specialite (${item.idSpecialite})');
            
          } catch (e) {
            print('❌ Error syncing specialite ${item.idSpecialite}: $e');
          }
          
          await Future.delayed(const Duration(milliseconds: 100));
        }
        
        page++;
        
        if (!_connection.isConnected) {
          print('📴 Connection lost, pausing specialite sync');
          break;
        }
      }
      
    } catch (e) {
      print('❌ Error syncing specialites: $e');
    }
  }

  //  Sync Fiches
  Future<void> _syncFiches() async {
    try {
      int page = 0;
      
      while (true) {
        final items = await _storage.isar.fiches
            .where()
            .filter()
            .syncStateEqualTo(SyncState.pending)
            .offset(page * BATCH_SIZE)
            .limit(BATCH_SIZE)
            .findAll();
        
        if (items.isEmpty) break;
        
        print('📦 Syncing ${items.length} fiches (batch ${page + 1})');
        
        for (final item in items) {
          try {
            await _api.createFiche(item.toJsonApi());
            
            await _storage.isar.writeTxn(() async {
              item.syncState = SyncState.synced;
              await _storage.isar.fiches.put(item);
            });
            
            print('✅ Synced: fiche (${item.idFiche})');
            
          } catch (e) {
            print('❌ Error syncing fiche ${item.idFiche}: $e');
          }
          
          await Future.delayed(const Duration(milliseconds: 100));
        }
        
        page++;
        
        if (!_connection.isConnected) {
          print('📴 Connection lost, pausing fiche sync');
          break;
        }
      }
      
    } catch (e) {
      print('❌ Error syncing fiches: $e');
    }
  }

  //  Sync Prospects
  Future<void> _syncProspects() async {
    try {
      int page = 0;
      
      while (true) {
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
          try {
            // Load linked data
            await item.interets.load();
            
            await _api.createProspect(item.toJsonApi());
            
            await _storage.isar.writeTxn(() async {
              item.syncState = SyncState.synced;
              await _storage.isar.prospects.put(item);
            });
            
            print('✅ Synced: prospect (${item.idProspect})');
            
          } catch (e) {
            print('❌ Error syncing prospect ${item.idProspect}: $e');
          }
          
          await Future.delayed(const Duration(milliseconds: 100));
        }
        
        page++;
        
        if (!_connection.isConnected) {
          print('📴 Connection lost, pausing prospect sync');
          break;
        }
      }
      
    } catch (e) {
      print('❌ Error syncing prospects: $e');
    }
  }

  //  Sync Interets
  Future<void> _syncInterets() async {
    try {
      int page = 0;
      
      while (true) {
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
          try {
            // Load linked data
            await item.prospect.load();
            await item.specialite.load();
            
            await _api.createInteret(item.toApiJson());
            
            await _storage.isar.writeTxn(() async {
              item.syncState = SyncState.synced;
              await _storage.isar.interetFilieres.put(item);
            });
            
            print('✅ Synced: interet (${item.idInteret})');
            
          } catch (e) {
            print('❌ Error syncing interet ${item.idInteret}: $e');
          }
          
          await Future.delayed(const Duration(milliseconds: 100));
        }
        
        page++;
        
        if (!_connection.isConnected) {
          print('📴 Connection lost, pausing interet sync');
          break;
        }
      }
      
    } catch (e) {
      print('❌ Error syncing interets: $e');
    }
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
}