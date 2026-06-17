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
  final int priority; // Higher = process first

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
  
  final List<QueueItem> _queue = [];
  bool _isProcessing = false;
  final int _maxRetries = 3;
  final Duration _retryDelay = const Duration(seconds: 10);

  // Get priority based on type (higher = sync first)
  int _getPriority(QueueItemType type) {
    switch (type) {
      case QueueItemType.etablissement:
        return 100; // Highest priority - must sync first
      case QueueItemType.source:
        return 90;
      case QueueItemType.classe:
        return 80;
      case QueueItemType.specialite:
        return 70;
      case QueueItemType.fiche:
        return 60;
      case QueueItemType.prospect:
        return 50;
      case QueueItemType.interet:
        return 10; // Lowest priority - sync last
    }
  }

  Future<void> init() async {
    await _loadPendingItems();
  }

  // Add item to queue with priority
  Future<void> addItem(QueueItem item) async {
    _queue.add(item);
    // Sort by priority (highest first)
    _queue.sort((a, b) => b.priority.compareTo(a.priority));
    if (!_isProcessing) {
      _processQueue();
    }
  }

  // Add multiple items with correct priority
  Future<void> addItems(List<QueueItem> items) async {
    _queue.addAll(items);
    _queue.sort((a, b) => b.priority.compareTo(a.priority));
    if (!_isProcessing) {
      _processQueue();
    }
  }

  // Add prospect with all its dependencies
  Future<void> addCompleteProspect({
    required Prospect prospect,
    required Fiche fiche,
    required Classe classe,
    required Etablissement etablissement,
    required Source source,
    required List<Specialite> specialites,
    required List<InteretFiliere> interets,
  }) async {
    final now = DateTime.now();
    
    // Add items in dependency order (highest priority first)
    final items = [
      // 1. Etablissement (must sync first)
      QueueItem(
        id: etablissement.idEtablissement,
        type: QueueItemType.etablissement,
        data: etablissement.toJsonApi(),
        createdAt: now,
        priority: 100,
      ),
      
      // 2. Source (must sync before Fiche)
      QueueItem(
        id: source.idSource,
        type: QueueItemType.source,
        data: source.toJsonApi(),
        createdAt: now,
        priority: 90,
      ),
      
      // 3. Classe (must sync before Prospect)
      QueueItem(
        id: classe.idClasse,
        type: QueueItemType.classe,
        data: classe.toJsonApi(),
        createdAt: now,
        priority: 80,
      ),
      
      // 4. Specialites (must sync before Interets)
      ...specialites.map((spec) => QueueItem(
        id: spec.idSpecialite,
        type: QueueItemType.specialite,
        data: spec.toLocalJson(),
        createdAt: now,
        priority: 70,
      )),
      
      // 5. Fiche (must sync before Prospect)
      QueueItem(
        id: fiche.idFiche,
        type: QueueItemType.fiche,
        data: fiche.toJsonApi(),
        createdAt: now,
        priority: 60,
      ),
      
      // 6. Prospect (must sync before Interets)
      QueueItem(
        id: prospect.idProspect,
        type: QueueItemType.prospect,
        data: prospect.toJsonApi(),
        createdAt: now,
        priority: 50,
      ),
      
      // 7. Interets (sync last)
      ...interets.map((interet) => QueueItem(
        id: interet.idInteret,
        type: QueueItemType.interet,
        data: interet.toApiJson(),
        createdAt: now,
        priority: 10,
      )),
    ];
    
    await addItems(items);
  }

  // Process queue
  Future<void> _processQueue() async {
    if (_isProcessing || _queue.isEmpty) return;

    _isProcessing = true;

    while (_queue.isNotEmpty) {
      final item = _queue.removeAt(0);
      
      // Check if dependencies are synced before processing
      if (!await _dependenciesAreSynced(item)) {
        // Put back at the end and try later
        _queue.add(item);
        await Future.delayed(_retryDelay);
        continue;
      }
      
      try {
        await _processItem(item);
        // Mark as synced in database
        await _markAsSynced(item);
      } catch (e) {
        print('Error processing item ${item.id}: $e');
        // Add back to queue for retry
        _queue.add(item);
        await Future.delayed(_retryDelay);
      }
    }

    _isProcessing = false;
  }

  // Process individual item
  Future<void> _processItem(QueueItem item) async {
    switch (item.type) {
      case QueueItemType.prospect:
        await _api.createProspect(item.data);
        break;
      case QueueItemType.fiche:
        await _api.createFiche(item.data);
        break;
      case QueueItemType.interet:
        await _api.createInteret(item.data);
        break;
      case QueueItemType.etablissement:
        await _api.createEtablissement(item.data);
        break;
      case QueueItemType.classe:
        await _api.createClasse(item.data);
        break;
      case QueueItemType.specialite:
        await _api.createSpecialite(item.data);
        break;
      case QueueItemType.source:
        await _api.createSource(item.data);
        break;
    }
  }

  // Check if all dependencies are synced
  Future<bool> _dependenciesAreSynced(QueueItem item) async {
    try {
      switch (item.type) {
        case QueueItemType.prospect:
          // Prospect depends on Fiche and Classe
          final ficheId = item.data['idfiche'];
          final classeId = item.data['idClass'];
          
          final fiche = await _storage.isar.fiches
              .where()
              .idFicheEqualTo(ficheId)
              .findFirst();
          final classe = await _storage.isar.classes
              .where()
              .idClasseEqualTo(classeId)
              .findFirst();
              
          return (fiche?.syncState == SyncState.synced) && 
                 (classe?.syncState == SyncState.synced);
                 
        case QueueItemType.fiche:
          // Fiche depends on Source
          final sourceId = item.data['idSrc'];
          final source = await _storage.isar.sources
              .where()
              .idSourceEqualTo(sourceId)
              .findFirst();
          return source?.syncState == SyncState.synced;
          
        case QueueItemType.classe:
          // Classe depends on Etablissement
          final etsId = item.data['idEts'];
          final ets = await _storage.isar.etablissements
              .where()
              .idEtablissementEqualTo(etsId)
              .findFirst();
          return ets?.syncState == SyncState.synced;
          
        case QueueItemType.interet:
          // Interet depends on Prospect and Specialite
          final prospectId = item.data['idProspect'];
          final specialiteId = item.data['idSpecialite'];
          
          final prospect = await _storage.isar.prospects
              .where()
              .idProspectEqualTo(prospectId)
              .findFirst();
          final specialite = await _storage.isar.specialites
              .where()
              .idSpecialiteEqualTo(specialiteId)
              .findFirst();
              
          return (prospect?.syncState == SyncState.synced) && 
                 (specialite?.syncState == SyncState.synced);
                 
        case QueueItemType.etablissement:
        case QueueItemType.source:
        case QueueItemType.specialite:
          // No dependencies
          return true;
          
        default:
          return true;
      }
    } catch (e) {
      print('Error checking dependencies for ${item.type}: $e');
      return false;
    }
  }

  // Mark item as synced in database
  Future<void> _markAsSynced(QueueItem item) async {
    await _storage.isar.writeTxn(() async {
      switch (item.type) {
        case QueueItemType.prospect:
          final prospect = await _storage.isar.prospects
              .where()
              .idProspectEqualTo(item.id)
              .findFirst();
          if (prospect != null) {
            prospect.syncState = SyncState.synced;
            await _storage.isar.prospects.put(prospect);
          }
          break;
          
        case QueueItemType.fiche:
          final fiche = await _storage.isar.fiches
              .where()
              .idFicheEqualTo(item.id)
              .findFirst();
          if (fiche != null) {
            fiche.syncState = SyncState.synced;
            await _storage.isar.fiches.put(fiche);
          }
          break;
          
        case QueueItemType.interet:
          final interet = await _storage.isar.interetFilieres
              .where()
              .idInteretEqualTo(item.id)
              .findFirst();
          if (interet != null) {
            interet.syncState = SyncState.synced;
            await _storage.isar.interetFilieres.put(interet);
          }
          break;
          
        case QueueItemType.etablissement:
          final ets = await _storage.isar.etablissements
              .where()
              .idEtablissementEqualTo(item.id)
              .findFirst();
          if (ets != null) {
            // Add syncState to Etablissement model
            // ets.syncState = SyncState.synced;
            await _storage.isar.etablissements.put(ets);
          }
          break;
          
        case QueueItemType.classe:
          final classe = await _storage.isar.classes
              .where()
              .idClasseEqualTo(item.id)
              .findFirst();
          if (classe != null) {
            // classe.syncState = SyncState.synced;
            await _storage.isar.classes.put(classe);
          }
          break;
          
        case QueueItemType.specialite:
          final spec = await _storage.isar.specialites
              .where()
              .idSpecialiteEqualTo(item.id)
              .findFirst();
          if (spec != null) {
            spec.syncState = SyncState.synced;
            await _storage.isar.specialites.put(spec);
          }
          break;
          
        case QueueItemType.source:
          final source = await _storage.isar.sources
              .where()
              .idSourceEqualTo(item.id)
              .findFirst();
          if (source != null) {
            // source.syncState = SyncState.synced;
            await _storage.isar.sources.put(source);
          }
          break;
      }
    });
  }

  // Load pending items from storage
  Future<void> _loadPendingItems() async {
    try {
      final now = DateTime.now();
      final items = <QueueItem>[];

      // 1. Load pending Etablissements (highest priority)
      final pendingEts = await _storage.isar.etablissements.where().findAll();
      // Filter pending if you have syncState on Etablissement
      
      // 2. Load pending Sources
      final pendingSources = await _storage.isar.sources.where().findAll();
      
      // 3. Load pending Classes
      final pendingClasses = await _storage.isar.classes.where().findAll();
      
      // 4. Load pending Specialites
      final pendingSpecialites = await _storage.isar.specialites
          .where()
          .filter()
          .syncStateEqualTo(SyncState.pending)
          .findAll();
      
      // 5. Load pending Fiches
      final pendingFiches = await _storage.isar.fiches
          .where()
          .filter()
          .syncStateEqualTo(SyncState.pending)
          .findAll();
      
      // 6. Load pending Prospects
      final pendingProspects = await _storage.isar.prospects
          .where()
          .filter()
          .syncStateEqualTo(SyncState.pending)
          .findAll();
      
      // 7. Load pending Interets
      final pendingInterets = await _storage.isar.interetFilieres
          .where()
          .filter()
          .syncStateEqualTo(SyncState.pending)
          .findAll();

      // Add all items with proper priorities
      // ... (add items with _getPriority)

      if (_queue.isNotEmpty) {
        _queue.sort((a, b) => b.priority.compareTo(a.priority));
        _processQueue();
      }
    } catch (e) {
      print('Error loading pending items: $e');
    }
  }

  // Get queue size
  int get size => _queue.length;
  bool get isEmpty => _queue.isEmpty;
  bool get isProcessing => _isProcessing;
}