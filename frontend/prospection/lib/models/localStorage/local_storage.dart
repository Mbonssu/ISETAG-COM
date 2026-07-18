// ignore_for_file: avoid_print

import 'dart:math';

import 'package:isar/isar.dart';
import 'package:isetagcom/models/prospectData.dart';
import 'package:path_provider/path_provider.dart';
import '../../utils/status.dart';
import '../pros.dart';
import '../fiche.dart';
import '../interet_filiere.dart';
import '../source.dart';
import '../etablissement.dart';
import '../classe.dart';
import '../specialite.dart';
import '../user.dart';
import '../agent_commercial.dart';

// ==================== PAGINATION CLASSES ====================

/// Paginated result wrapper
class PaginatedResult<T> {
  final List<T> items;
  final int totalCount;
  final bool hasMore;
  final int currentPage;
  final int pageSize;

  PaginatedResult({
    required this.items,
    required this.totalCount,
    required this.hasMore,
    this.currentPage = 0,
    this.pageSize = 50,
  });

  @override
  String toString() {
    return 'PaginatedResult(items: ${items.length}, totalCount: $totalCount, hasMore: $hasMore, page: $currentPage)';
  }
}

/// Pagination controller for managing page state
class ProspectPaginationController {
  int _currentOffset = 0;
  final int _pageSize;
  bool _hasMore = true;
  bool _isLoading = false;
  int _totalCount = 0;
  int _currentPage = 0;

  ProspectPaginationController({int pageSize = 50}) : _pageSize = pageSize;

  int get pageSize => _pageSize;
  int get currentOffset => _currentOffset;
  bool get hasMore => _hasMore;
  bool get isLoading => _isLoading;
  int get totalCount => _totalCount;
  int get currentPage => _currentPage;

  void reset() {
    _currentOffset = 0;
    _hasMore = true;
    _isLoading = false;
    _totalCount = 0;
    _currentPage = 0;
  }

  void updateState({
    required int newOffset,
    required bool hasMore,
    required int totalCount,
    bool isLoading = false,
  }) {
    _currentOffset = newOffset;
    _hasMore = hasMore;
    _totalCount = totalCount;
    _isLoading = isLoading;
    if (newOffset > 0) {
      _currentPage = (newOffset / _pageSize).floor();
    }
  }

  void setLoading(bool loading) {
    _isLoading = loading;
  }

  void incrementOffset() {
    _currentOffset += _pageSize;
    _currentPage++;
  }
}

class LocalStorage {
  static final LocalStorage instance = LocalStorage._internal();
  LocalStorage._internal();

  late Isar _isar;
  bool _initialized = false;

  Future<void> init() async {
    // Prevent multiple initialization
    if (_initialized) {
      print("Isar already initialized");
      return;
    }

    final isOpened = Isar.getInstance();

    if (isOpened != null) {
      print("Isar is already opened");
      _isar = isOpened;
      _initialized = true;
      return;
    }

    print("Opening Isar....");
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [
        ProspectSchema,
        FicheSchema,
        InteretFiliereSchema,
        SourceSchema,
        EtablissementSchema,
        ClasseSchema,
        SpecialiteSchema,
        UserSchema,
        AgentCommercialSchema,
      ],
      directory: dir.path,
      inspector: true,
    );
    print("Isar's path doc: ${dir.path}");
    _initialized = true;
    print("Isar Opened");
  }

  Isar get isar {
    if (!_initialized) {
      throw Exception("Isar not initialized. Call init() first.");
    }
    return _isar;
  }

  // ==================== WATCH METHODS WITH INCREMENTAL SUPPORT ====================

  /// Watch etablissements in real-time, only returning items not already in the provided list.
  Stream<List<Etablissement>> watchEtablissementsIncremental(
      List<Etablissement> existing) {
    final existingIds = existing.map((e) => e.idEtablissement).toSet();
    bool isFirst = true;

    return _isar.etablissements
        .where()
        .watch(fireImmediately: true)
        .asyncMap((_) async {
      final all = await _isar.etablissements.where().findAll();
      if (isFirst) {
        isFirst = false;
        if (existingIds.isEmpty) {
          return all;
        } else {
          return all
              .where((e) => !existingIds.contains(e.idEtablissement))
              .toList();
        }
      } else {
        return all
            .where((e) => !existingIds.contains(e.idEtablissement))
            .toList();
      }
    });
  }

  /// Watch classes in real-time, only returning items not already in the provided list.
  Stream<List<Classe>> watchClassesIncremental(List<Classe> existing) {
    final existingIds = existing.map((c) => c.idClasse).toSet();
    bool isFirst = true;

    return _isar.classes
        .where()
        .watch(fireImmediately: true)
        .asyncMap((_) async {
      final all = await _isar.classes.where().findAll();
      if (isFirst) {
        isFirst = false;
        if (existingIds.isEmpty) {
          return all;
        } else {
          return all.where((c) => !existingIds.contains(c.idClasse)).toList();
        }
      } else {
        return all.where((c) => !existingIds.contains(c.idClasse)).toList();
      }
    });
  }

  /// Watch specialites in real-time, only returning items not already in the provided list.
  Stream<List<Specialite>> watchSpecialitesIncremental(
      List<Specialite> existing) {
    final existingIds = existing.map((s) => s.idSpecialite).toSet();
    bool isFirst = true;

    return _isar.specialites
        .where()
        .watch(fireImmediately: true)
        .asyncMap((_) async {
      final all = await _isar.specialites.where().findAll();
      if (isFirst) {
        isFirst = false;
        if (existingIds.isEmpty) {
          return all;
        } else {
          return all
              .where((s) => !existingIds.contains(s.idSpecialite))
              .toList();
        }
      } else {
        return all.where((s) => !existingIds.contains(s.idSpecialite)).toList();
      }
    });
  }

  /// Generate 1500 dummy prospects with all relationships
  Future<void> generateDummyProspects() async {
    try {
      print('🔄 Generating 1500 dummy prospects...');
      final now = DateTime.now();

      // 1. Sources (10) - These represent the source_infos options
      final sources = <Source>[];
      final sourceInfos = [
        'Réseaux sociaux',
        'Recommandation',
        'Site web',
        'Événement',
        'Prospection terrain',
        'Partenariat',
        'Campagne email',
        'Publicité',
        'Salon professionnel',
        'Bouche à oreille',
      ];

      for (int i = 0; i < sourceInfos.length; i++) {
        final source = Source(
          idSource: 'src_${i + 1}_${now.millisecondsSinceEpoch}',
          libelleSource: sourceInfos[i],
          createdAt: now,
          syncState: SyncState.pending,
        );
        sources.add(source);
        await saveSource(source);
      }
      print(' ${sources.length} sources created');

      // 2. Etablissements (15)
      final etablissements = <Etablissement>[];
      final etablissementNames = [
        'Lycée de Biyem-Assi',
        'Lycée Technique d\'Efouan',
        'Institut Confucius',
        'Lycée Général Leclerc',
        'Collège Vogt',
        'Lycée de Mvog-Mbi',
        'Lycée de Nkolndongo',
        'Lycée de Mendong',
        'Lycée de Ngoa-Ekelle',
        'Lycée de Mbalmayo',
        'Lycée de Soa',
        'Collège de la Retraite',
        'Lycée de Nlongkak',
        'Institut Siantou',
        'Lycée de Bafoussam',
      ];

      for (int i = 0; i < etablissementNames.length; i++) {
        final ets = Etablissement(
          idEtablissement: 'ets_${i + 1}_${now.millisecondsSinceEpoch}',
          nomEtablissement: etablissementNames[i],
          typeEtablissement: ['Secondary', 'University', 'Secondary'][i % 3],
          adresse: 'Adresse ${i + 1}, Cameroun',
          telephone:
              '+237 6${(10000000 + i * 10000).toString().padLeft(7, '0')}',
          ville: ['Yaoundé', 'Douala', 'Bafoussam', 'Bamenda'][i % 4],
          region: ['Centre', 'Littoral', 'Ouest', 'Nord-Ouest'][i % 4],
          createdAt: now,
          syncState: SyncState.pending,
        );
        etablissements.add(ets);
        await saveEtablissement(ets);
      }
      print(' ${etablissements.length} etablissements created');

      // 3. Classes (25)
      final classes = <Classe>[];
      final classNames = [
        'Terminale C',
        'Terminale D',
        'Terminale A4',
        'Terminale TI',
        'BTS 1',
        'BTS 2',
        'Licence 1',
        'Licence 2',
        'Licence 3',
        'Master 1',
        'Master 2',
        'Licence',
      ];

      for (int i = 0; i < classNames.length; i++) {
        final etsIndex = i % etablissements.length;
        final clse = Classe(
          idClasse: 'classe_${i + 1}_${now.millisecondsSinceEpoch}',
          idEts: etablissements[etsIndex].idEtablissement,
          libelleClasse: classNames[i],
          createdAt: now,
          syncState: SyncState.pending,
        );
        classes.add(clse);
        await saveClasse(clse);
      }
      print(' ${classes.length} classes created');

      // 4. Specialites (25)
      final specialites = <Specialite>[];
      final specialiteNames = [
        'Génie Logiciel',
        'Génie Civil',
        'Génie Mécanique',
        'Marketing',
        'Finance',
        'Comptabilité',
        'Réseaux et Télécoms',
        'Cybersécurité',
        'Intelligence Artificielle',
        'Ressources Humaines',
        'Logistique',
        'Communication',
        'Design UI/UX',
        'Développement Mobile',
        'Data Science',
        'DevOps',
        'Cloud Computing',
        'Blockchain',
        'Énergies Renouvelables',
        'Biotechnologie',
        'Robotique',
        'Aéronautique',
        'Agronomie',
        'Architecture',
        'Médecine',
      ];

      for (int i = 0; i < specialiteNames.length; i++) {
        final spec = Specialite(
          idSpecialite: 'spec_${i + 1}_${now.millisecondsSinceEpoch}',
          libelleSpecialite: specialiteNames[i],
          description: 'Description de ${specialiteNames[i]}',
          createdAt: now,
          syncState: SyncState.pending,
        );
        specialites.add(spec);
        await saveSpecialite(spec);
      }
      print(' ${specialites.length} specialites created');

      // 5. Fiches (15) - Each fiche is associated with a source
      final fiches = <Fiche>[];
      final ficheComments = [
        'Visite initiale',
        'Suivi prospect',
        'Contact établi',
        'Demande d\'information',
        'Rendez-vous pris',
        'Confirmation d\'intérêt',
        'Relance effectuée',
        'Nouveau contact',
        'Prospection active',
        'Suivi personnalisé',
        'Prise de contact',
        'Entretien réalisé',
        'Offre envoyée',
        'Négociation',
        'Signature prochaine',
      ];

      for (int i = 0; i < sources.length; i++) {
        final fiche = Fiche(
          idFiche: 'fiche_${i + 1}_${now.millisecondsSinceEpoch}',
          idSrc: sources[i].idSource,
          dateCollecte: now.subtract(Duration(days: i * 2)),
          commentaire: ficheComments[i % ficheComments.length],
          scoreInteret: 3 + (i % 8),
          createdAt: now,
          isCurrent: i == 0,
          syncState: SyncState.pending,
        );
        fiches.add(fiche);
        await saveFiche(fiche);
      }
      print(' ${fiches.length} fiches created');

      // 6. Generate 1500 Prospects with source_infos
      final firstNames = [
        'Jean',
        'Marie',
        'Paul',
        'Claire',
        'David',
        'Sarah',
        'Kevin',
        'Laura',
        'Thomas',
        'Julie',
        'Nicolas',
        'Emma',
        'Alexandre',
        'Léa',
        'Raphaël',
        'Manon',
        'Lucas',
        'Chloé',
        'Hugo',
        'Camille',
        'Louis',
        'Alice',
        'Arnaud',
        'Céline',
        'François',
        'Diane',
        'Pierre',
        'Sophie',
        'Blaise',
        'Jacqueline',
        'Romain',
        'Adeline',
        'Daniel',
        'Martine',
        'Michel',
        'Suzanne',
        'André',
        'Elise',
        'Philippe',
        'Isabelle',
        'Christophe',
        'Nathalie',
        'Éric',
        'Valérie',
        'Stéphane',
        'Catherine',
        'Laurent',
        'Anne',
        'Frédéric',
        'Isabelle',
      ];

      final lastNames = [
        'Dupont',
        'Martin',
        'Durand',
        'Bernard',
        'Thomas',
        'Petit',
        'Robert',
        'Richard',
        'Dubois',
        'Laurent',
        'Simon',
        'Michel',
        'Lefebvre',
        'Leroy',
        'Roux',
        'David',
        'Bertrand',
        'Moreau',
        'Fournier',
        'Girard',
        'Bonnet',
        'François',
        'Martinez',
        'Legrand',
        'Garnier',
        'Faure',
        'Rousseau',
        'Blanc',
        'Guerin',
        'Muller',
        'Henry',
        'Roussel',
        'Nicolas',
        'Perrin',
        'Morin',
        'Mathieu',
        'Clement',
        'Gauthier',
        'Dumont',
        'Lopez',
        'Fontaine',
        'Chevalier',
        'Robin',
        'Masson',
        'Sanchez',
        'Adam',
        'Garcia',
      ];

      final typeProspects = ['Étudiant', 'Éleve'];
      final sexes = ['Masculin', 'Féminin'];
      final niveauEtudes = [
        'Baccalauréat',
        'BTS 1',
        'BTS 2',
        'Licence',
        'Master 1',
        'Master 2',
        'Doctorat'
      ];
      final statuses = [
        ProspectStatus.relancer,
        ProspectStatus.nouveau,
        ProspectStatus.contacte
      ];
      final phonePrefix = ['6', '7', '8', '9'];

      int savedCount = 0;
      const totalCount = 1500;
      const batchSize = 50;

      for (int batch = 0; batch < totalCount; batch += batchSize) {
        final end =
            (batch + batchSize < totalCount) ? batch + batchSize : totalCount;

        for (int i = batch; i < end; i++) {
          final firstName = firstNames[i % firstNames.length];
          final lastName = lastNames[i % lastNames.length];
          final fullName = '$firstName $lastName';

          final classe = classes[i % classes.length];
          final fiche = fiches[i % fiches.length];
          // Assign source_infos from the source list (ensuring each prospect gets a source)
          final sourceInfo = sourceInfos[i % sourceInfos.length];
          final numSpecialites = 1 + (i % 4);

          final prospect = Prospect(
            idProspect: 'prospect_${i + 1}_${now.millisecondsSinceEpoch}',
            idfiche: fiche.idFiche,
            idClass: classe.idClasse,
            nomComplet: fullName,
            telephone:
                '+237 ${phonePrefix[i % phonePrefix.length]}${(10000000 + i * 1000).toString().padLeft(7, '0')}',
            email:
                '${firstName.toLowerCase()}.${lastName.toLowerCase()}$i@example.com',
            niveauEtude: niveauEtudes[i % niveauEtudes.length],
            adresse: '${100 + i} Rue des Écoles, Cameroun',
            sexe: sexes[i % 2],
            typeProspect: typeProspects[i % typeProspects.length],
            source_infos: sourceInfo, // Assign the source info string
            commentaireGen: 'Prospect #${i + 1} - $firstName $lastName',
            concerne: null,
            date_relance:
                i % 5 == 0 ? now.add(Duration(days: 5 + (i % 20))) : null,
            createdAt: now.subtract(Duration(days: i % 30)),
            // updatedAt: null,
            syncState: SyncState.pending,
            prospectStatus: statuses[i % statuses.length],
          );

          await saveProspect(prospect);

          final selectedSpecialites = <Specialite>[];
          for (int s = 0; s < numSpecialites; s++) {
            final specIndex = (i + s * 7) % specialites.length;
            final spec = specialites[specIndex];

            if (!selectedSpecialites.contains(spec)) {
              selectedSpecialites.add(spec);

              final interet = InteretFiliere(
                idInteret:
                    'interet_${i + 1}_${s + 1}_${now.millisecondsSinceEpoch}',
                idProspect: prospect.idProspect,
                idSpecialite: spec.idSpecialite,
                ordrePreference: s + 1,
                niveauInteret: 4 + (i % 7),
                commentaire: 'Intérêt pour ${spec.libelleSpecialite}',
                createdAt: now,
                syncState: SyncState.pending,
              );

              interet.prospect.value = prospect;
              interet.specialite.value = spec;

              await saveInteret(interet);
              prospect.AllSpec.add(spec);
            }
          }

          savedCount++;
          if (savedCount % 100 == 0) {
            print('📊 Progress: $savedCount/$totalCount');
          }
        }

        print('📦 Batch ${(batch / batchSize).toInt() + 1} completed');
      }

      print(' Successfully saved $savedCount dummy prospects!');
      print('📊 Summary:');
      print('   - ${sources.length} Sources');
      print('   - ${etablissements.length} Etablissements');
      print('   - ${classes.length} Classes');
      print('   - ${specialites.length} Specialites');
      print('   - ${fiches.length} Fiches');
      print('   - $savedCount Prospects with source_infos assigned');
    } catch (e) {
      print(' Error generating dummy data: $e');
      rethrow;
    }
  }

  // ==================== PROSPECT - OPTIMIZED CHECKERS ====================

  Future<bool> _prospectExistsByPhone(String phone) async {
    try {
      final result =
          await _isar.prospects.where().telephoneEqualTo(phone).findFirst();
      return result != null;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _prospectExistsByEmail(String? email) async {
    if (email == null || email.isEmpty) return false;
    try {
      final result =
          await _isar.prospects.where().emailEqualTo(email).findFirst();
      return result != null;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _prospectExistsByName(String nomComplet) async {
    try {
      final result = await _isar.prospects
          .where()
          .nomCompletEqualTo(nomComplet)
          .findFirst();
      return result != null;
    } catch (e) {
      return false;
    }
  }

  // Save prospect with checker - returns translation key
  Future<String> saveProspect(Prospect prospect) async {
    try {
      if (await _prospectExistsByName(prospect.nomComplet)) {
        return 'name_already_exists';
      }

      if (await _prospectExistsByPhone(prospect.telephone)) {
        return 'phone_already_exists';
      }

      if (await _prospectExistsByEmail(prospect.email)) {
        return 'email_already_exists';
      }

      await _isar.writeTxn(() async {
        await _isar.prospects.put(prospect);
        if (prospect.classe.value != null) {
          await prospect.classe.save();
        }

        //  Save the fiche relationship
        if (prospect.fiche.value != null) {
          await prospect.fiche.save();
        }
      });

      return 'prospect_added_success';
    } catch (e) {
      print('Error saving prospect: $e');
      return 'error_saving_prospect';
    }
  }

  Future<List<Prospect>> getAllProspects() async {
    try {
      return await _isar.prospects.where().findAll();
    } catch (e) {
      print('Error getting all prospects: $e');
      return [];
    }
  }

  Future<Prospect?> getProspectById(String idProspect) async {
    try {
      return await _isar.prospects
          .where()
          .idProspectEqualTo(idProspect)
          .findFirst();
    } catch (e) {
      print('Error getting prospect by id: $e');
      return null;
    }
  }

  Future<List<Prospect>> getAllProspectsWithInterests() async {
    try {
      final prospects = await _isar.prospects.where().findAll();
      for (final prospect in prospects) {
        await prospect.interets.load();
        for (final interet in prospect.interets) {
          await interet.specialite.load();
        }
      }
      return prospects;
    } catch (e) {
      print('Error getting prospects with interests: $e');
      return [];
    }
  }

  // ==================== FICHE - OPTIMIZED CHECKER ====================

  Future<bool> _ficheExists(String idFiche) async {
    try {
      final result =
          await _isar.fiches.where().idFicheEqualTo(idFiche).findFirst();
      return result != null;
    } catch (e) {
      return false;
    }
  }

  // Save fiche with checker - returns translation key
  Future<String> saveFiche(Fiche fiche) async {
    try {
      if (await _ficheExists(fiche.idFiche)) {
        return 'fiche_already_exists';
      }

      if (!isar.isOpen) print("Isar is closed");
      await _isar.writeTxn(() async {
        await _isar.fiches.put(fiche);
      });

      return 'fiche_added_success';
    } catch (e) {
      print('Error saving fiche: $e');
      return 'error_saving_fiche';
    }
  }

  Future<List<Fiche>> getAllFiches() async {
    try {
      return await _isar.fiches.where().findAll();
    } catch (e) {
      print('Error getting all fiches: $e');
      return [];
    }
  }

  Future<Fiche?> getFicheById(String idFiche) async {
    try {
      return await _isar.fiches.where().idFicheEqualTo(idFiche).findFirst();
    } catch (e) {
      print('Error getting fiche by id: $e');
      return null;
    }
  }

  Future<List<Fiche>> getAllFichesWithProspects() async {
    try {
      final fiches = await _isar.fiches.where().findAll();
      for (final fiche in fiches) {
        await fiche.prospects.load();
        for (final prospect in fiche.prospects) {
          await prospect.interets.load();
        }
      }
      return fiches;
    } catch (e) {
      print('Error getting fiches with prospects: $e');
      return [];
    }
  }

  Future<Fiche?> getLastRecFiche() async {
    try {
      return await _isar.fiches.where().sortByIdFicheDesc().findFirst();
    } catch (e) {
      print('Error getting last fiche: $e');
      return null;
    }
  }

  Future<Fiche?> getFicheWithDetails(String ficheId) async {
    try {
      final fiche =
          await _isar.fiches.where().idFicheEqualTo(ficheId).findFirst();
      if (fiche != null) {
        await fiche.source.load();
        await fiche.prospects.load();
        for (final prospect in fiche.prospects) {
          await prospect.interets.load();
          for (final interet in prospect.interets) {
            await interet.specialite.load();
          }
          await prospect.classe.load();
          if (prospect.classe.value != null) {
            await prospect.classe.value!.ets.load();
          }
        }
      }
      return fiche;
    } catch (e) {
      print('Error getting fiche with details: $e');
      return null;
    }
  }

  // ==================== INTERET FILIERE - OPTIMIZED CHECKER ====================

  Future<bool> _interetExists(String idInteret) async {
    try {
      final result = await _isar.interetFilieres
          .where()
          .idInteretEqualTo(idInteret)
          .findFirst();
      return result != null;
    } catch (e) {
      return false;
    }
  }

  // Save interet with checker - returns translation key
  Future<String> saveInteret(InteretFiliere interet) async {
    try {
      if (await _interetExists(interet.idInteret)) {
        return 'interet_already_exists';
      }

      await _isar.writeTxn(() async {
        await _isar.interetFilieres.put(interet);
        await interet.prospect.save();
        await interet.specialite.save();
      });

      return 'interet_added_success';
    } catch (e) {
      print('Error saving interet: $e');
      return 'error_saving_interet';
    }
  }

  Future<List<InteretFiliere>> getAllInterets() async {
    try {
      return await _isar.interetFilieres.where().findAll();
    } catch (e) {
      print('Error getting all interets: $e');
      return [];
    }
  }

  Future<List<InteretFiliere>> getInteretsByProspect(String prospectId) async {
    try {
      return await _isar.interetFilieres
          .where()
          .filter()
          .prospect((q) => q.idProspectEqualTo(prospectId))
          .findAll();
    } catch (e) {
      print('Error getting interets by prospect: $e');
      return [];
    }
  }

  Future<InteretFiliere?> getInteretByProspectAndSpecialite(
      String idProspect, String idSpecialite) async {
    try {
      final allInterets = await getAllInterets();
      return allInterets.firstWhere(
        (i) => i.idProspect == idProspect && i.idSpecialite == idSpecialite,
        // orElse: () => null,
      );
    } catch (e) {
      return null;
    }
  }

  // ==================== SOURCE - OPTIMIZED CHECKER ====================

  Future<bool> _sourceExists(String idSource) async {
    try {
      final result =
          await _isar.sources.where().idSourceEqualTo(idSource).findFirst();
      return result != null;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _sourceExistsByName(String libelle) async {
    try {
      final result =
          await _isar.sources.where().libelleSourceEqualTo(libelle).findFirst();
      return result != null;
    } catch (e) {
      return false;
    }
  }

  // Save source with checker - returns translation key
  Future<String> saveSource(Source source) async {
    try {
      if (await _sourceExists(source.idSource)) {
        return 'source_already_exists';
      }

      if (await _sourceExistsByName(source.libelleSource)) {
        return 'source_name_already_exists';
      }

      await _isar.writeTxn(() async {
        await _isar.sources.put(source);
      });

      return 'source_added_success';
    } catch (e) {
      print('Error saving source: $e');
      return 'error_saving_source';
    }
  }

  Future<List<Source>> getAllSources() async {
    try {
      return await _isar.sources.where().findAll();
    } catch (e) {
      print('Error getting all sources: $e');
      return [];
    }
  }

  Future<Source?> getSourceById(String idSource) async {
    try {
      return await _isar.sources.where().idSourceEqualTo(idSource).findFirst();
    } catch (e) {
      print('Error getting source by id: $e');
      return null;
    }
  }

  Future<Source?> getLastRecSource() async {
    try {
      return await _isar.sources.where().sortByIdSourceDesc().findFirst();
    } catch (e) {
      print('Error getting last source: $e');
      return null;
    }
  }

  Future<Source?> getSourceByLabel(String label) async {
    try {
      return await _isar.sources
          .where()
          .libelleSourceEqualTo(label)
          .findFirst();
    } catch (e) {
      print('Error getting source by label: $e');
      return null;
    }
  }

  // ==================== ETABLISSEMENT - OPTIMIZED CHECKER ====================

  Future<bool> _etablissementExistsByName(String nom) async {
    try {
      final result = await _isar.etablissements
          .where()
          .nomEtablissementEqualTo(nom)
          .findFirst();
      return result != null;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _etablissementExists(String idEtablissement) async {
    try {
      final result = await _isar.etablissements
          .where()
          .idEtablissementEqualTo(idEtablissement)
          .findFirst();
      return result != null;
    } catch (e) {
      return false;
    }
  }

  // Save etablissement with checker - returns translation key
  Future<String> saveEtablissement(Etablissement etablissement) async {
    try {
      if (await _etablissementExists(etablissement.idEtablissement)) {
        return 'establishment_already_exists';
      }

      if (await _etablissementExistsByName(etablissement.nomEtablissement)) {
        return 'establishment_name_already_exists';
      }

      await _isar.writeTxn(() async {
        await _isar.etablissements.put(etablissement);
      });

      return 'establishment_added_success';
    } catch (e) {
      print('Error saving etablissement: $e');
      return 'error_saving_establishment';
    }
  }

  // Add etablissement only if it doesn't exist by name
  Future<String> addEtablissementIfNotExists(
      Etablissement etablissement) async {
    try {
      // Check if exists by name - using the same method
      final existing =
          await getEtablissementByNom(etablissement.nomEtablissement);

      if (existing != null) {
        print(
            ' Establishment already exists: ${etablissement.nomEtablissement}');
        return 'establishment_already_exists';
      }

      await _isar.writeTxn(() async {
        await _isar.etablissements.put(etablissement);
      });

      print(' New establishment added: ${etablissement.nomEtablissement}');
      return 'establishment_added_success';
    } catch (e) {
      print('Error adding etablissement: $e');
      return 'error_saving_establishment';
    }
  }

  Future<List<Etablissement>> getAllEtablissements() async {
    try {
      return await _isar.etablissements.where().findAll();
    } catch (e) {
      print('Error getting all etablissements: $e');
      return [];
    }
  }

  Future<Etablissement?> getEtablissementById(String idEtablissement) async {
    try {
      return await _isar.etablissements
          .where()
          .idEtablissementEqualTo(idEtablissement)
          .findFirst();
    } catch (e) {
      print('Error getting etablissement by id: $e');
      return null;
    }
  }

  Future<Etablissement?> getEtablissementByNom(String nom) async {
    try {
      return await _isar.etablissements
          .where()
          .nomEtablissementEqualTo(nom)
          .findFirst();
    } catch (e) {
      return null;
    }
  }

  // ==================== CLASSE - OPTIMIZED CHECKER ====================

  Future<bool> _classeExists(String idClasse) async {
    try {
      final result =
          await _isar.classes.where().idClasseEqualTo(idClasse).findFirst();
      return result != null;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _classeExistsByLibelleAndEts(
      String libelle, String idEts) async {
    try {
      final result = await _isar.classes
          .where()
          .filter()
          .libelleClasseEqualTo(libelle)
          .and()
          .idEtsEqualTo(idEts)
          .findFirst();
      return result != null;
    } catch (e) {
      return false;
    }
  }

  // Save class with checker - returns translation key
  Future<String> saveClasse(Classe classe) async {
    try {
      if (await _classeExists(classe.idClasse)) {
        return 'class_already_exists';
      }

      if (await _classeExistsByLibelleAndEts(
          classe.libelleClasse, classe.idEts)) {
        return 'class_name_already_exists';
      }

      await _isar.writeTxn(() async {
        await _isar.classes.put(classe);
      });

      return 'class_added_success';
    } catch (e) {
      print('Error saving classe: $e');
      return 'error_saving_class';
    }
  }

  Future<List<Classe>> getAllClasses() async {
    try {
      return await _isar.classes.where().findAll();
    } catch (e) {
      print('Error getting all classes: $e');
      return [];
    }
  }

  Future<Classe?> getClasseById(String idClasse) async {
    try {
      return await _isar.classes.where().idClasseEqualTo(idClasse).findFirst();
    } catch (e) {
      print('Error getting classe by id: $e');
      return null;
    }
  }

  Future<Classe?> getClasseByLibelleAndEts(String libelle, String idEts) async {
    try {
      return await _isar.classes
          .where()
          .filter()
          .libelleClasseEqualTo(libelle)
          .and()
          .idEtsEqualTo(idEts)
          .findFirst();
    } catch (e) {
      return null;
    }
  }

  Future<List<Classe>> getClassesByEtablissement(String idEts) async {
    try {
      final allClasses = await getAllClasses();
      return allClasses.where((c) => c.idEts == idEts).toList();
    } catch (e) {
      print('Error getting classes by etablissement: $e');
      return [];
    }
  }

  // ==================== SPECIALITE - OPTIMIZED CHECKER ====================

  Future<bool> _specialiteExistsByName(String nom) async {
    try {
      final result = await _isar.specialites
          .where()
          .libelleSpecialiteEqualTo(nom)
          .findFirst();
      return result != null;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _specialiteExists(String idSpecialite) async {
    try {
      final result = await _isar.specialites
          .where()
          .idSpecialiteEqualTo(idSpecialite)
          .findFirst();
      return result != null;
    } catch (e) {
      return false;
    }
  }

  // Save specialite with checker - returns translation key
  Future<String> saveSpecialite(Specialite specialite) async {
    try {
      if (await _specialiteExists(specialite.idSpecialite)) {
        return 'specialty_already_exists';
      }

      if (await _specialiteExistsByName(specialite.libelleSpecialite)) {
        return 'specialty_name_already_exists';
      }

      await _isar.writeTxn(() async {
        await _isar.specialites.put(specialite);
      });

      return 'specialty_added_success';
    } catch (e) {
      print('Error saving specialite: $e');
      return 'error_saving_specialty';
    }
  }

  // Add specialite only if it doesn't exist by name
  Future<String> addSpecialiteIfNotExists(Specialite specialite) async {
    try {
      // Check if exists by name - using the same method
      final existing = await getSpecialiteByNom(specialite.libelleSpecialite);

      if (existing != null) {
        print(' Speciality already exists: ${specialite.libelleSpecialite}');
        return 'specialty_already_exists';
      }

      await _isar.writeTxn(() async {
        await _isar.specialites.put(specialite);
      });

      print(' New speciality added: ${specialite.libelleSpecialite}');
      return 'specialty_added_success';
    } catch (e) {
      print('Error adding specialite: $e');
      return 'error_saving_specialty';
    }
  }

  Future<List<Specialite>> getAllSpecialites() async {
    try {
      return await _isar.specialites.where().findAll();
    } catch (e) {
      print('Error getting all specialites: $e');
      return [];
    }
  }

  Future<Specialite?> getSpecialiteById(String idSpecialite) async {
    try {
      return await _isar.specialites
          .where()
          .idSpecialiteEqualTo(idSpecialite)
          .findFirst();
    } catch (e) {
      print('Error getting specialite by id: $e');
      return null;
    }
  }

  /// Récupérer une spécialité par son nom (OPTIMIZED)
  Future<Specialite?> getSpecialiteByNom(String nom) async {
    try {
      return await _isar.specialites
          .where()
          .libelleSpecialiteEqualTo(nom)
          .findFirst();
    } catch (e) {
      return null;
    }
  }

  Future<List<Specialite>> getProspectSpecialites(String prospectId) async {
    try {
      final interets = await getInteretsByProspect(prospectId);
      if (interets.isEmpty) return [];

      final List<Specialite> specialites = [];
      for (final interet in interets) {
        await interet.specialite.load();
        if (interet.specialite.value != null) {
          specialites.add(interet.specialite.value!);
        }
      }

      return specialites;
    } catch (e) {
      print('Erreur getProspectSpecialites: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getProspectInterestsWithDetails(
      String prospectId) async {
    try {
      final interets = await getInteretsByProspect(prospectId);
      if (interets.isEmpty) return [];

      final List<Map<String, dynamic>> result = [];
      for (final interet in interets) {
        await interet.specialite.load();
        result.add({
          'idInteret': interet.idInteret,
          'ordrePreference': interet.ordrePreference,
          'niveauInteret': interet.niveauInteret,
          'commentaire': interet.commentaire ?? '',
          'specialite': interet.specialite.value?.toLocalJson(),
        });
      }

      result.sort((a, b) =>
          (a['ordrePreference'] as int).compareTo(b['ordrePreference'] as int));
      return result;
    } catch (e) {
      print('Erreur getProspectInterestsWithDetails: $e');
      return [];
    }
  }

  Future<List<String>> getProspectSpecialiteNames(String prospectId) async {
    try {
      final specialites = await getProspectSpecialites(prospectId);
      return specialites.map((s) => s.libelleSpecialite).toList();
    } catch (e) {
      print('Error getting prospect specialite names: $e');
      return [];
    }
  }

  // ==================== DELETE ====================

  Future<void> deleteProspect(String idProspect) async {
    try {
      await _isar.writeTxn(() async {
        final prospect = await getProspectById(idProspect);
        if (prospect != null) {
          await _isar.prospects.delete(prospect.isarId);
        }
      });
    } catch (e) {
      print('Error deleting prospect: $e');
    }
  }

  Future<void> deleteFiche(String idFiche) async {
    try {
      await _isar.writeTxn(() async {
        final fiche = await getFicheById(idFiche);
        if (fiche != null) {
          await _isar.fiches.delete(fiche.isarId);
        }
      });
    } catch (e) {
      print('Error deleting fiche: $e');
    }
  }

  Future<void> deleteAll() async {
    try {
      await _isar.writeTxn(() async {
        await _isar.clear();
      });
    } catch (e) {
      print('Error deleting all: $e');
    }
  }

  // ==================== PAGINATED PROSPECT STREAMS ====================

  /// Load a single page of prospects with all related data
  static Future<PaginatedResult<ProspectDetails>> loadProspectsPage({
    required int pageSize,
    required int offset,
  }) async {
    try {
      final isar = Isar.getInstance();
      if (isar == null) {
        return PaginatedResult(items: [], totalCount: 0, hasMore: false);
      }

      // Get total count
      final totalCount = await isar.prospects.where().count();

      // Calculate if there are more items
      final hasMore = (offset + pageSize) < totalCount;

      // Get prospects for current page
      final prospects = await isar.prospects
          .where()
          .sortByIdProspectDesc()
          .offset(offset)
          .limit(pageSize)
          .findAll();

      if (prospects.isEmpty) {
        return PaginatedResult(
          items: [],
          totalCount: totalCount,
          hasMore: false,
        );
      }

      // Load all related data
      final details = await _buildProspectDetailsList(isar, prospects);

      return PaginatedResult(
        items: details,
        totalCount: totalCount,
        hasMore: hasMore,
        currentPage: (offset / pageSize).floor(),
        pageSize: pageSize,
      );
    } catch (e) {
      print('Error loading prospects page: $e');
      return PaginatedResult(items: [], totalCount: 0, hasMore: false);
    }
  }

  /// Stream that loads a page and watches for changes
  static Stream<PaginatedResult<ProspectDetails>> watchProspectsPage({
    required int pageSize,
    required int offset,
  }) async* {
    try {
      final isar = Isar.getInstance();
      if (isar == null) {
        yield PaginatedResult(items: [], totalCount: 0, hasMore: false);
        return;
      }

      // Initial load
      final initialResult = await loadProspectsPage(
        pageSize: pageSize,
        offset: offset,
      );
      yield initialResult;

      // Watch for changes
      yield* isar.prospects
          .where()
          .watch(fireImmediately: false)
          .asyncMap((_) async {
        try {
          return await loadProspectsPage(
            pageSize: pageSize,
            offset: offset,
          );
        } catch (e) {
          print('Error in watchProspectsPage asyncMap: $e');
          return PaginatedResult(items: [], totalCount: 0, hasMore: false);
        }
      });
    } catch (e) {
      print('Error in watchProspectsPage: $e');
      yield PaginatedResult(items: [], totalCount: 0, hasMore: false);
    }
  }

  /// Original method - kept for backward compatibility
  static Stream<List<ProspectDetails>> watchProspectsWithSpecs(
      {int limit = 100000}) async* {
    try {
      final isar = Isar.getInstance();
      if (isar == null) {
        yield [];
        return;
      }

      yield* isar.prospects
          .where()
          .sortByIdProspectDesc()
          .limit(limit)
          .watch(fireImmediately: true)
          .asyncMap((_) async {
        try {
          final prospects = await isar.prospects
              .where()
              .sortByIdProspectDesc()
              .limit(limit)
              .findAll();

          if (prospects.isEmpty) return <ProspectDetails>[];

          return await _buildProspectDetailsList(isar, prospects);
        } catch (e) {
          print('Error in watchProspectsWithSpecs asyncMap: $e');
          return <ProspectDetails>[];
        }
      });
    } catch (e) {
      print('Error in watchProspectsWithSpecs: $e');
      yield [];
    }
  }

  /// Helper method to build ProspectDetails list from prospects
  // static Future<List<ProspectDetails>> _buildProspectDetailsList(
  //     Isar isar, List<Prospect> prospects) async {
  //   try {
  //     final ids = prospects.map((p) => p.idProspect).toList();

  //     final allLinks = await isar.interetFilieres
  //         .filter()
  //         .anyOf(ids,
  //             (q, id) => q.prospect((link) => link.idProspectEqualTo(id)))
  //         .findAll();

  //     final classeIds = prospects
  //         .map((p) => p.classe.value?.idClasse)
  //         .whereType<int>()
  //         .toList();
  //     final classes = await isar.classes.getAll(classeIds);
  //     final classeMap = {
  //       for (var c in classes.whereType<Classe>()) c.idClasse: c
  //     };

  //     final etsIds = classes
  //         .whereType<Classe>()
  //         .map((c) => c.ets.value?.idEtablissement)
  //         .whereType<int>()
  //         .toList();
  //     final etss = await isar.etablissements.getAll(etsIds);
  //     final etsMap = {
  //       for (var e in etss.whereType<Etablissement>()) e.idEtablissement: e
  //     };

  //     return prospects.map((p) {
  //       final specsP = allLinks
  //           .where((l) =>
  //               l.prospect.value?.idProspect == p.idProspect ||
  //               l.prospect.value?.idProspect == p.idProspect)
  //           .map((l) => SpecialityDetail(
  //                 libelleSpecialite:
  //                     l.specialite.value?.libelleSpecialite ?? '',
  //                 orderPreference: l.ordrePreference,
  //                 niveau: l.niveauInteret,
  //                 commentaire: l.commentaire,
  //               ))
  //           .toList()
  //         ..sort((a, b) => a.orderPreference.compareTo(b.orderPreference));

  //       final classe = classeMap[p.classe.value?.idClasse];
  //       final ets = classe != null
  //           ? etsMap[classe.ets.value?.idEtablissement]
  //           : null;

  //       return ProspectDetails(
  //         prosp: p,
  //         etablissement: ets?.nomEtablissement ?? '',
  //         classe: classe?.libelleClasse ?? '',
  //         specialities: specsP,
  //       );
  //     }).toList();
  //   } catch (e) {
  //     print('Error building prospect details list: $e');
  //     return [];
  //   }
  // }

  static Future<List<ProspectDetails>> _buildProspectDetailsList(
      Isar isar, List<Prospect> prospects) async {
    try {
      print('🔍 === START _buildProspectDetailsList ===');
      print('📊 Number of prospects: ${prospects.length}');

      if (prospects.isEmpty) {
        print(' Prospects list is empty, returning empty list');
        return [];
      }

      //  OPTIMIZATION: BATCH LOAD all classes in ONE query (not N queries)
      print(
          '🔄 Batch loading relationships for ${prospects.length} prospects...');

      // Get all class IDs as Strings
      final classIds =
          prospects.map((p) => p.idClass).where((id) => id.isNotEmpty).toList();

      print('📋 Class IDs found: ${classIds.length}');

      //  OPTIMIZATION: ONE query for ALL classes
      final classes = await isar.classes
          .where()
          .anyOf(classIds, (q, id) => q.idClasseEqualTo(id))
          .findAll();

      print('📊 Classes retrieved from DB: ${classes.length}');

      // Build class map for O(1) lookup
      final classeMap = {for (var c in classes) c.idClasse: c};

      //  OPTIMIZATION: Get all ets IDs in ONE pass
      final etsIds =
          classes.where((c) => c.idEts.isNotEmpty).map((c) => c.idEts).toList();

      print('📋 Etablissement IDs found: ${etsIds.length}');

      //  OPTIMIZATION: ONE query for ALL etablissements
      final etss = await isar.etablissements
          .where()
          .anyOf(etsIds, (q, id) => q.idEtablissementEqualTo(id))
          .findAll();

      print('📊 Etablissements retrieved from DB: ${etss.length}');

      // Build ets map for O(1) lookup
      final etsMap = {for (var e in etss) e.idEtablissement: e};

      //  OPTIMIZATION: Get all interests in ONE query
      final ids = prospects.map((p) => p.idProspect).toList();

      final allLinks = await isar.interetFilieres
          .filter()
          .anyOf(
              ids, (q, id) => q.prospect((link) => link.idProspectEqualTo(id)))
          .findAll();

      print('📊 Interests found: ${allLinks.length}');

      //  OPTIMIZATION: Get all specialites in ONE query
      if (allLinks.isNotEmpty) {
        final specialiteIds = allLinks
            .where((l) => l.idSpecialite.isNotEmpty)
            .map((l) => l.idSpecialite)
            .toList();

        final specialites = await isar.specialites
            .where()
            .anyOf(specialiteIds, (q, id) => q.idSpecialiteEqualTo(id))
            .findAll();

        final specialiteMap = {for (var s in specialites) s.idSpecialite: s};

        // Attach specialites to their interests
        for (final link in allLinks) {
          link.specialite.value = specialiteMap[link.idSpecialite];
        }
      }

      //  Build results with O(1) lookups
      final result = prospects.map((p) {
        final specsP = allLinks
            .where((l) => l.idProspect == p.idProspect)
            .map((l) => SpecialityDetail(
                  libelleSpecialite:
                      l.specialite.value?.libelleSpecialite ?? '',
                  orderPreference: l.ordrePreference,
                  niveau: l.niveauInteret,
                  commentaire: l.commentaire,
                ))
            .toList()
          ..sort((a, b) => a.orderPreference.compareTo(b.orderPreference));

        final classe = classeMap[p.idClass];
        final ets = classe != null ? etsMap[classe.idEts] : null;

        return ProspectDetails(
          prosp: p,
          etablissement: ets?.nomEtablissement ?? '',
          classe: classe?.libelleClasse ?? '',
          specialities: specsP,
        );
      }).toList();

      // Final summary
      int emptyEtablissement =
          result.where((d) => d.etablissement.isEmpty).length;
      int emptyClasse = result.where((d) => d.classe.isEmpty).length;

      print('📊 === FINAL RESULTS ===');
      print('   - Total prospects: ${result.length}');
      print('   - Empty etablissement: $emptyEtablissement/${result.length}');
      print('   - Empty classe: $emptyClasse/${result.length}');

      print(' === END _buildProspectDetailsList ===');
      return result;
    } catch (e) {
      print(' Error building prospect details list: $e');
      print(' Stack trace: ${StackTrace.current}');
      return [];
    }
  }

  /// Stream d'une fiche spécifique avec tous ses prospects et leurs relations
  Stream<Fiche?> watchFicheById(String ficheId) {
    try {
      return _isar.fiches
          .where()
          .idFicheEqualTo(ficheId)
          .watch(fireImmediately: true)
          .asyncMap((_) async {
        try {
          final fiche =
              await _isar.fiches.where().idFicheEqualTo(ficheId).findFirst();

          if (fiche != null) {
            await fiche.source.load();
            await fiche.prospects.load();

            for (final prospect in fiche.prospects) {
              await prospect.interets.load();
              for (final interet in prospect.interets) {
                await interet.specialite.load();
              }
              await prospect.classe.load();
              if (prospect.classe.value != null) {
                await prospect.classe.value!.ets.load();
              }
            }
          }

          return fiche;
        } catch (e) {
          print('Error in watchFicheById asyncMap: $e');
          return null;
        }
      });
    } catch (e) {
      print('Error in watchFicheById: $e');
      return Stream.value(null);
    }
  }

  /// Stream de toutes les fiches avec leurs prospects
  Stream<List<Fiche>> watchAllFiches() {
    try {
      return _isar.fiches
          .where()
          .watch(fireImmediately: true)
          .asyncMap((_) async {
        try {
          final fiches = await _isar.fiches.where().findAll();

          for (final fiche in fiches) {
            await fiche.source.load();
            await fiche.prospects.load();

            for (final prospect in fiche.prospects) {
              await prospect.interets.load();
              for (final interet in prospect.interets) {
                await interet.specialite.load();
              }
              await prospect.classe.load();
              if (prospect.classe.value != null) {
                await prospect.classe.value!.ets.load();
              }
            }
          }

          return fiches;
        } catch (e) {
          print('Error in watchAllFiches asyncMap: $e');
          return <Fiche>[];
        }
      });
    } catch (e) {
      print('Error in watchAllFiches: $e');
      return Stream.value([]);
    }
  }

  /// Stream d'un prospect spécifique
  Stream<Prospect?> watchProspectById(String prospectId) {
    try {
      return _isar.prospects
          .where()
          .idProspectEqualTo(prospectId)
          .watch(fireImmediately: true)
          .asyncMap((_) async {
        try {
          final prospect = await _isar.prospects
              .where()
              .idProspectEqualTo(prospectId)
              .findFirst();

          if (prospect != null) {
            await prospect.interets.load();
            for (final interet in prospect.interets) {
              await interet.specialite.load();
            }
            await prospect.classe.load();
            if (prospect.classe.value != null) {
              await prospect.classe.value!.ets.load();
            }
          }

          return prospect;
        } catch (e) {
          print('Error in watchProspectById asyncMap: $e');
          return null;
        }
      });
    } catch (e) {
      print('Error in watchProspectById: $e');
      return Stream.value(null);
    }
  }

  /// Stream d'une fiche avec tous ses prospects et leurs détails
  Stream<Fiche?> watchFicheWithDetails(String ficheId) {
    try {
      return _isar.fiches
          .where()
          .idFicheEqualTo(ficheId)
          .watch(fireImmediately: true)
          .asyncMap((_) async {
        try {
          return await getFicheWithDetails(ficheId);
        } catch (e) {
          print('Error in watchFicheWithDetails asyncMap: $e');
          return null;
        }
      });
    } catch (e) {
      print('Error in watchFicheWithDetails: $e');
      return Stream.value(null);
    }
  }

  /// Convertir un prospect en ProspectDetails
  Future<ProspectDetails> buildProspectDetails(Prospect prospect) async {
    try {
      await prospect.interets.load();
      for (final interet in prospect.interets) {
        await interet.specialite.load();
      }
      await prospect.classe.load();
      if (prospect.classe.value != null) {
        await prospect.classe.value!.ets.load();
      }

      final classe = prospect.classe.value;
      final etablissement = classe?.ets.value;

      final List<SpecialityDetail> specialities = [];
      for (final interet in prospect.interets) {
        final specialite = interet.specialite.value;
        if (specialite != null) {
          specialities.add(SpecialityDetail(
            libelleSpecialite: specialite.libelleSpecialite,
            orderPreference: interet.ordrePreference,
            niveau: interet.niveauInteret,
            commentaire: interet.commentaire,
          ));
        }
      }

      specialities
          .sort((a, b) => a.orderPreference.compareTo(b.orderPreference));

      return ProspectDetails(
        prosp: prospect,
        etablissement: etablissement?.nomEtablissement ?? 'Non spécifié',
        classe: classe?.libelleClasse ?? 'Non spécifié',
        specialities: specialities,
      );
    } catch (e) {
      print('Error building prospect details: $e');
      return ProspectDetails(
        prosp: prospect,
        etablissement: 'Non spécifié',
        classe: 'Non spécifié',
        specialities: [],
      );
    }
  }

  /// Stream de tous les prospects d'une fiche convertis en ProspectDetails
  Stream<List<ProspectDetails>> watchProspectsDetailsByFiche(String ficheId) {
    try {
      return _isar.prospects
          .where()
          .filter()
          .idficheEqualTo(ficheId)
          .watch(fireImmediately: true)
          .asyncMap((_) async {
        try {
          final prospects = await _isar.prospects
              .where()
              .filter()
              .idficheEqualTo(ficheId)
              .findAll();

          final List<ProspectDetails> detailsList = [];
          for (final prospect in prospects) {
            final details = await buildProspectDetails(prospect);
            detailsList.add(details);
          }
          return detailsList;
        } catch (e) {
          print('Error in watchProspectsDetailsByFiche asyncMap: $e');
          return <ProspectDetails>[];
        }
      });
    } catch (e) {
      print('Error in watchProspectsDetailsByFiche: $e');
      return Stream.value([]);
    }
  }

  // Version plus efficace - une seule requête
  Stream<Map<String, dynamic>> watchStatsOptimized() {
    try {
      return _isar.prospects
          .where()
          .watch(fireImmediately: true)
          .asyncMap((_) async {
        try {
          final allProspects = await _isar.prospects.where().findAll();
          final allfiche = await _isar.fiches.where().findAll();
          final now = DateTime.now();
          // final startOfMonth = DateTime(now.year, now.month, 1);
          // final endOfMonth = DateTime(now.year, now.month + 1, 0);

          final total = allProspects.length;
          final aRelancer = allProspects
              .where((p) =>
                  p.date_relance != null && p.date_relance!.isBefore(now))
              .length;
          // final visites = allProspects
          //     .where((p) =>
          //         p.createdAt.isAfter(startOfMonth) &&
          //         p.createdAt.isBefore(endOfMonth))
          //     .length;
          final fiches = allfiche.length;
          final nouveauxEtablissements =
              allProspects.map((p) => p.idfiche).toSet().length;

          return {
            // 'totalProspects': total,
            // 'aRelancer': aRelancer,
            // 'visitesEffectuees': visites,
            // 'allfiches': fiches,
            // 'nouveauxEtablissements': nouveauxEtablissements,
            'totalFormatted': total >= 10 ? total.toString() : '0$total',
            'aRelancerFormatted':
                aRelancer >= 10 ? aRelancer.toString() : '0$aRelancer',
            // 'visitesFormatted':
            //     visites >= 10 ? visites.toString() : '0$visites',
            'fiche_formatted': fiches >= 10 ? fiches.toString() : '0$fiches',
            'nouveauxFormatted': nouveauxEtablissements >= 10
                ? nouveauxEtablissements.toString()
                : '0$nouveauxEtablissements',
          };
        } catch (e) {
          print('Error in watchStatsOptimized asyncMap: $e');
          return {
            'totalProspects': 0,
            'aRelancer': 0,
            'visitesEffectuees': 0,
            'nouveauxEtablissements': 0,
            'totalFormatted': '00',
            'aRelancerFormatted': '00',
            'visitesFormatted': '00',
            'nouveauxFormatted': '00',
          };
        }
      });
    } catch (e) {
      print('Error in watchStatsOptimized: $e');
      return Stream.value({
        'totalProspects': 0,
        'aRelancer': 0,
        'visitesEffectuees': 0,
        'nouveauxEtablissements': 0,
        'totalFormatted': '00',
        'aRelancerFormatted': '00',
        'visitesFormatted': '00',
        'nouveauxFormatted': '00',
      });
    }
  }

  // ==================== USER ====================

  // Save user
  Future<void> saveUser(User user) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.users.put(user);
      });
    } catch (e) {
      print('Error saving user: $e');
    }
  }

  // Get user by ID
  Future<User?> getUserById(String idUtilisateur) async {
    try {
      return await _isar.users
          .where()
          .idUtilisateurEqualTo(idUtilisateur)
          .findFirst();
    } catch (e) {
      print('Error getting user by id: $e');
      return null;
    }
  }

  // Get user by email or phone
  Future<User?> getUserByEmailOrPhone(String emailOrPhone) async {
    try {
      final allUsers = await getAllUsers();
      return allUsers.firstWhere(
        (u) => u.email == emailOrPhone || u.telephone == emailOrPhone,
        // orElse: () => null,
      );
    } catch (e) {
      print('Error getting user by email or phone: $e');
      return null;
    }
  }

  // Get all users
  Future<List<User>> getAllUsers() async {
    try {
      return await _isar.users.where().findAll();
    } catch (e) {
      print('Error getting all users: $e');
      return [];
    }
  }

  // Get all users with a specific role
  Future<List<User>> getUsersByRole(String role) async {
    try {
      return await _isar.users.where().filter().roleEqualTo(role).findAll();
    } catch (e) {
      print('Error getting users by role: $e');
      return [];
    }
  }

  // Update user
  Future<void> updateUser(User user) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.users.put(user);
      });
    } catch (e) {
      print('Error updating user: $e');
    }
  }

  // ==================== AGENT COMMERCIAL ====================

  // Get agent by ID with user loaded
  Future<AgentCommercial?> getAgentById(String idAgent) async {
    try {
      final agent = await _isar.agentCommercials
          .where()
          .idAgentEqualTo(idAgent)
          .findFirst();

      if (agent != null) {
        await agent.user.load();
      }
      return agent;
    } catch (e) {
      print('Error getting agent by id: $e');
      return null;
    }
  }

  // Get agent by user ID with user loaded
  Future<AgentCommercial?> getAgentByUserId(String idUtilisateur) async {
    try {
      final agent = await _isar.agentCommercials
          .where()
          .filter()
          .idUtilisateurEqualTo(idUtilisateur)
          .findFirst();

      if (agent != null) {
        await agent.user.load();
      }
      return agent;
    } catch (e) {
      print('Error getting agent by user id: $e');
      return null;
    }
  }

  // Get all agents with their users loaded
  Future<List<AgentCommercial>> getAllAgents() async {
    try {
      final agents = await _isar.agentCommercials.where().findAll();
      for (final agent in agents) {
        await agent.user.load();
      }
      return agents;
    } catch (e) {
      print('Error getting all agents: $e');
      return [];
    }
  }

  // Get active agents
  Future<List<AgentCommercial>> getActiveAgents() async {
    try {
      final agents = await _isar.agentCommercials.where().findAll();
      final activeAgents = <AgentCommercial>[];

      for (final agent in agents) {
        await agent.user.load();
        if (agent.user.value?.actif == true) {
          activeAgents.add(agent);
        }
      }
      return activeAgents;
    } catch (e) {
      print('Error getting active agents: $e');
      return [];
    }
  }
}
