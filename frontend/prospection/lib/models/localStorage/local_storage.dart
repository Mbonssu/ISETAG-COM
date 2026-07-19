// ignore_for_file: avoid_print

import 'dart:async';

import 'package:isar_community/isar.dart';
import 'package:isetagcom/models/prospectData.dart';
import 'package:isetagcom/utils/status.dart';
import 'package:path_provider/path_provider.dart';
import '../../utils/idGenerator.dart';
import '../campaign.dart';
import '../pros.dart';
import '../fiche.dart';
import '../interet_filiere.dart';
import '../sortie.dart';
import '../source.dart';
import '../etablissement.dart';
import '../classe.dart';
import '../specialite.dart';
import '../user.dart';
import '../agent_commercial.dart';
import '../zone.dart';

class LocalStorage {
  static final LocalStorage instance = LocalStorage._internal();
  LocalStorage._internal();

  late Isar _isar;
  bool _initialized = false;

  // Shared prospects stream to avoid multiple Isar watchers
  StreamController<List<ProspectDetails>>? _prospectsController;
  StreamSubscription<List<ProspectDetails>>? _prospectsWatcher;

  Future<void> init() async {
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

  // ==================== PROSPECT ====================

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
        await prospect.classe.save();
        await prospect.fiche.save();
      });

      return 'prospect_added_success';
    } catch (e) {
      print('Error saving prospect: $e');
      return 'error_saving_prospect';
    }
  }

  /// Update the prospect in LocalStorage [prospect]
  Future<String> updateProspect(Prospect prospect) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.prospects.put(prospect);
        await prospect.classe.save();
        await prospect.fiche.save();
      });
      return 'prospect_updated_success';
    } catch (e) {
      print('Error updating prospect: $e');
      return 'error_updating_prospect';
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

  // ==================== FICHE ====================

  Future<void> saveFiche(Fiche fiche) async {
    try {
      if (!isar.isOpen) print("Isar is closed");
      await _isar.writeTxn(() async {
        await _isar.fiches.put(fiche);
      });
    } catch (e) {
      print('Error saving fiche: $e');
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

  // ==================== FICHE - CHECKER ====================

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

  // ==================== INTERET FILIERE ====================

  Future<void> saveInteret(InteretFiliere interet) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.interetFilieres.put(interet);
        await interet.prospect.save();
        await interet.specialite.save();
      });
    } catch (e) {
      print('Error saving interet: $e');
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
    String idProspect,
    String idSpecialite,
  ) async {
    try {
      final allInterets = await getAllInterets();
      return allInterets.firstWhere(
        (i) => i.idProspect == idProspect && i.idSpecialite == idSpecialite,
      );
    } catch (e) {
      return null;
    }
  }

  // ==================== SOURCE ====================

  Future<void> saveSource(Source source) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.sources.put(source);
      });
    } catch (e) {
      print('Error saving source: $e');
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

  // ==================== ETABLISSEMENT ====================

  Future<bool> _etablissementExistsByName(String nom) async {
    try {
      final allEtablissements = await getAllEtablissements();
      return allEtablissements.any(
        (e) => e.nomEtablissement.toLowerCase() == nom.toLowerCase(),
      );
    } catch (e) {
      return false;
    }
  }

  Future<String> saveEtablissement(Etablissement etablissement) async {
    try {
      if (await _etablissementExistsByName(etablissement.nomEtablissement)) {
        return 'establishment_already_exists';
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
      final allEtablissements = await getAllEtablissements();
      return allEtablissements.firstWhere(
        (e) =>
            e.nomEtablissement.toLowerCase().trim() == nom.toLowerCase().trim(),
      );
    } catch (e) {
      return null;
    }
  }

  // ==================== CLASSE ====================

  Future<String> saveClasse(Classe classe) async {
    try {
      final existing = await getClasseByLibelleAndEts(
        classe.libelleClasse,
        classe.idEts,
      );

      if (existing != null) {
        return 'class_already_exists';
      }

      if (classe.idEts.isNotEmpty) {
        final etablissement = await getEtablissementById(classe.idEts);
        if (etablissement != null) {
          classe.ets.value = etablissement;
        }
      }

      await _isar.writeTxn(() async {
        await _isar.classes.put(classe);
        await classe.ets.save();
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

  // ==================== CLASSE - CHECKER ====================

  Future<Classe?> getClasseByLibelleAndEts(String libelle, String idEts) async {
    try {
      final allClasses = await getAllClasses();
      return allClasses.firstWhere(
        (c) =>
            c.libelleClasse.toLowerCase() == libelle.toLowerCase() &&
            c.idEts == idEts,
      );
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

  // ==================== SPECIALITE ====================

  Future<bool> _specialiteExistsByName(String nom) async {
    try {
      final allSpecialites = await getAllSpecialites();
      return allSpecialites.any(
        (s) => s.libelleSpecialite.toLowerCase() == nom.toLowerCase(),
      );
    } catch (e) {
      return false;
    }
  }

  Future<String> saveSpecialite(Specialite specialite) async {
    try {
      if (await _specialiteExistsByName(specialite.libelleSpecialite)) {
        return 'specialty_already_exists';
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

  Future<Specialite?> getSpecialiteByNom(String nom) async {
    try {
      final allSpecialites = await getAllSpecialites();
      return allSpecialites.firstWhere(
        (s) => s.libelleSpecialite.toLowerCase() == nom.toLowerCase(),
      );
    } catch (e) {
      return null;
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

  // ==================== HELPER METHODS ====================

  Future<Classe?> _loadClasseForProspect(Prospect prospect) async {
    await prospect.classe.load();
    if (prospect.classe.value != null) {
      return prospect.classe.value;
    }

    if (prospect.idClass.isNotEmpty) {
      return await getClasseById(prospect.idClass);
    }

    return null;
  }

  Future<Etablissement?> _loadEtablissementForClasse(Classe classe) async {
    await classe.ets.load();
    if (classe.ets.value != null) {
      return classe.ets.value;
    }

    if (classe.idEts.isNotEmpty) {
      return await getEtablissementById(classe.idEts);
    }

    return null;
  }

  Future<Specialite?> _loadSpecialiteForInteret(InteretFiliere interet) async {
    await interet.specialite.load();
    if (interet.specialite.value != null) {
      return interet.specialite.value;
    }

    if (interet.idSpecialite.isNotEmpty) {
      return await getSpecialiteById(interet.idSpecialite);
    }

    return null;
  }

  // ==================== PAGINATION METHODS ====================

  /// ✅ Récupérer les 10 dernières fiches
  Future<List<Fiche>> getLast10Fiches() async {
    try {
      final fiches = await _isar.fiches
          .where()
          .sortByDateCollecteDesc()
          .limit(10)
          .findAll();

      if (fiches.isEmpty) return [];

      for (final fiche in fiches) {
        await fiche.source.load();
        await fiche.prospects.load();
        for (final prospect in fiche.prospects) {
          await prospect.interets.load();
        }
      }

      return fiches;
    } catch (e) {
      print('❌ Error getting last 10 fiches: $e');
      return [];
    }
  }

  /// ✅ Récupérer les 10 derniers prospects avec détails
  Future<List<ProspectDetails>> getLast10Prospects() async {
    try {
      final prospects = await _isar.prospects
          .where()
          .sortByCreatedAtDesc()
          .limit(10)
          .findAll();

      if (prospects.isEmpty) return [];

      final List<ProspectDetails> results = [];
      for (final prospect in prospects) {
        final details = await buildProspectDetails(prospect);
        results.add(details);
      }
      return results;
    } catch (e) {
      print('❌ Error getting last 10 prospects: $e');
      return [];
    }
  }

  /// ✅ Récupérer les prospects avec pagination (comme RelancesScreen)
  Future<List<ProspectDetails>> getPaginatedProspects({
    required int page,
    required int pageSize,
    bool sortByDate = true,
  }) async {
    try {
      final prospects = sortByDate
          ? await _isar.prospects
              .where()
              .sortByCreatedAtDesc()
              .offset(page * pageSize)
              .limit(pageSize)
              .findAll()
          : await _isar.prospects
              .where()
              .sortByIdProspectDesc()
              .offset(page * pageSize)
              .limit(pageSize)
              .findAll();

      if (prospects.isEmpty) return [];

      // ✅ Batch load all relations
      final prospectIds = prospects.map((p) => p.idProspect).toList();

      final allInterets = await _isar.interetFilieres
          .where()
          .filter()
          .anyOf(prospectIds, (q, id) => q.idProspectEqualTo(id))
          .findAll();

      final specialiteIds = allInterets.map((i) => i.idSpecialite).toList();
      final allSpecialites = specialiteIds.isNotEmpty
          ? await _isar.specialites
              .where()
              .anyOf(specialiteIds, (q, id) => q.idSpecialiteEqualTo(id))
              .findAll()
          : [];

      final specialiteMap = {for (var s in allSpecialites) s.idSpecialite: s};

      final classeIds = prospects.map((p) => p.idClass).toList();
      final allClasses = await _isar.classes
          .where()
          .anyOf(classeIds, (q, id) => q.idClasseEqualTo(id))
          .findAll();

      final classeMap = {for (var c in allClasses) c.idClasse: c};

      final etsIds = allClasses.map((c) => c.idEts).toList();
      final allEts = await _isar.etablissements
          .where()
          .anyOf(etsIds, (q, id) => q.idEtablissementEqualTo(id))
          .findAll();

      final etsMap = {for (var e in allEts) e.idEtablissement: e};

      // ✅ Build details
      final detailsList = <ProspectDetails>[];
      for (final prospect in prospects) {
        final interets = allInterets
            .where((i) => i.idProspect == prospect.idProspect)
            .toList();

        final specialities = interets
            .map((i) {
              final spec = specialiteMap[i.idSpecialite];
              return spec != null
                  ? SpecialityDetail(
                      libelleSpecialite: spec.libelleSpecialite,
                      orderPreference: i.ordrePreference,
                      niveau: i.niveauInteret,
                      commentaire: i.commentaire ?? '',
                    )
                  : null;
            })
            .whereType<SpecialityDetail>()
            .toList()
          ..sort((a, b) => a.orderPreference.compareTo(b.orderPreference));

        final classe = classeMap[prospect.idClass];
        final ets = classe != null ? etsMap[classe.idEts] : null;

        detailsList.add(ProspectDetails(
          prosp: prospect,
          etablissement: ets ??
              Etablissement(
                idEtablissement: '',
                nomEtablissement: 'Non spécifié',
                typeEtablissement: '',
                createdAt: DateTime.now(),
                syncState: SyncState.pending,
              ),
          classe: classe ??
              Classe(
                idClasse: '',
                idEts: '',
                libelleClasse: 'Non spécifié',
                createdAt: DateTime.now(),
                syncState: SyncState.pending,
              ),
          specialities: specialities,
        ));
      }

      return detailsList;
    } catch (e) {
      print('❌ Error getting paginated prospects: $e');
      return [];
    }
  }

  /// ✅ Récupérer les relances avec pagination
  Future<List<ProspectDetails>> getPaginatedRelances({
    required int page,
    required int pageSize,
    bool onlyOverdue = false,
  }) async {
    try {
      final now = DateTime.now();

      var query = _isar.prospects.where().filter().date_relanceIsNotNull();

      if (onlyOverdue) {
        query = query.date_relanceLessThan(now);
      }

      final prospects =
          await query.offset(page * pageSize).limit(pageSize).findAll();

      if (prospects.isEmpty) return [];

      prospects.sort((a, b) => a.date_relance!.compareTo(b.date_relance!));

      // ✅ Batch load all relations
      final prospectIds = prospects.map((p) => p.idProspect).toList();

      final allInterets = await _isar.interetFilieres
          .where()
          .filter()
          .anyOf(prospectIds, (q, id) => q.idProspectEqualTo(id))
          .findAll();

      final specialiteIds = allInterets.map((i) => i.idSpecialite).toList();
      final allSpecialites = specialiteIds.isNotEmpty
          ? await _isar.specialites
              .where()
              .anyOf(specialiteIds, (q, id) => q.idSpecialiteEqualTo(id))
              .findAll()
          : [];

      final specialiteMap = {for (var s in allSpecialites) s.idSpecialite: s};

      final classeIds = prospects.map((p) => p.idClass).toList();
      final allClasses = await _isar.classes
          .where()
          .anyOf(classeIds, (q, id) => q.idClasseEqualTo(id))
          .findAll();

      final classeMap = {for (var c in allClasses) c.idClasse: c};

      final etsIds = allClasses.map((c) => c.idEts).toList();
      final allEts = await _isar.etablissements
          .where()
          .anyOf(etsIds, (q, id) => q.idEtablissementEqualTo(id))
          .findAll();

      final etsMap = {for (var e in allEts) e.idEtablissement: e};

      // ✅ Build details
      final detailsList = <ProspectDetails>[];
      for (final prospect in prospects) {
        final interets = allInterets
            .where((i) => i.idProspect == prospect.idProspect)
            .toList();

        final specialities = interets
            .map((i) {
              final spec = specialiteMap[i.idSpecialite];
              return spec != null
                  ? SpecialityDetail(
                      libelleSpecialite: spec.libelleSpecialite,
                      orderPreference: i.ordrePreference,
                      niveau: i.niveauInteret,
                      commentaire: i.commentaire ?? '',
                    )
                  : null;
            })
            .whereType<SpecialityDetail>()
            .toList()
          ..sort((a, b) => a.orderPreference.compareTo(b.orderPreference));

        final classe = classeMap[prospect.idClass];
        final ets = classe != null ? etsMap[classe.idEts] : null;

        detailsList.add(ProspectDetails(
          prosp: prospect,
          etablissement: ets ??
              Etablissement(
                idEtablissement: '',
                nomEtablissement: 'Non spécifié',
                typeEtablissement: '',
                createdAt: DateTime.now(),
                syncState: SyncState.pending,
              ),
          classe: classe ??
              Classe(
                idClasse: '',
                idEts: '',
                libelleClasse: 'Non spécifié',
                createdAt: DateTime.now(),
                syncState: SyncState.pending,
              ),
          specialities: specialities,
        ));
      }

      return detailsList;
    } catch (e) {
      print('❌ Error getting paginated relances: $e');
      return [];
    }
  }

  /// ✅ Récupérer les prospects par fiche avec pagination
  Future<List<ProspectDetails>> getPaginatedProspectsByFiche({
    required String ficheId,
    required int page,
    required int pageSize,
  }) async {
    try {
      final prospects = await _isar.prospects
          .where()
          .filter()
          .idficheEqualTo(ficheId)
          .offset(page * pageSize)
          .limit(pageSize)
          .findAll();

      if (prospects.isEmpty) return [];

      final List<ProspectDetails> results = [];
      for (final prospect in prospects) {
        final details = await buildProspectDetails(prospect);
        results.add(details);
      }
      return results;
    } catch (e) {
      print('❌ Error getting paginated prospects by fiche: $e');
      return [];
    }
  }

  /// ✅ Rechercher des prospects avec pagination
  Future<List<ProspectDetails>> searchPaginatedProspects({
    required String query,
    required int page,
    required int pageSize,
  }) async {
    try {
      if (query.isEmpty) {
        return await getPaginatedProspects(page: page, pageSize: pageSize);
      }

      final lowerQuery = query.toLowerCase();

      final allProspects = await _isar.prospects.where().findAll();

      final filteredProspects = allProspects.where((p) {
        final nomMatch = p.nomComplet.toLowerCase().contains(lowerQuery);

        bool etsMatch = false;
        if (p.classe.value != null) {
          etsMatch = p.classe.value!.ets.value?.nomEtablissement
                  .toLowerCase()
                  .contains(lowerQuery) ??
              false;
        }

        return nomMatch || etsMatch;
      }).toList();

      final start = page * pageSize;
      final end = (start + pageSize) > filteredProspects.length
          ? filteredProspects.length
          : start + pageSize;

      final paginatedProspects = filteredProspects.sublist(
        start < filteredProspects.length ? start : 0,
        end,
      );

      final List<ProspectDetails> results = [];
      for (final prospect in paginatedProspects) {
        final details = await buildProspectDetails(prospect);
        results.add(details);
      }
      return results;
    } catch (e) {
      print('❌ Error searching paginated prospects: $e');
      return [];
    }
  }

  /// ✅ Compter le nombre total de prospects
  Future<int> countProspects({
    String? ficheId,
    bool? hasRelanceDate,
  }) async {
    try {
      var query = _isar.prospects.where();

      if (ficheId != null) {
        query = query.filter().idficheEqualTo(ficheId)
            as QueryBuilder<Prospect, Prospect, QWhere>;
      }

      if (hasRelanceDate == true) {
        query = query.filter().date_relanceIsNotNull()
            as QueryBuilder<Prospect, Prospect, QWhere>;
      }

      return await query.count();
    } catch (e) {
      print('❌ Error counting prospects: $e');
      return 0;
    }
  }

  // ==================== BUILD PROSPECT DETAILS ====================

  Future<ProspectDetails> buildProspectDetails(Prospect prospect) async {
    try {
      await prospect.interets.load();
      final List<SpecialityDetail> specialities = [];

      for (final interet in prospect.interets) {
        final specialite = await _loadSpecialiteForInteret(interet);
        if (specialite != null) {
          specialities.add(
            SpecialityDetail(
              libelleSpecialite: specialite.libelleSpecialite,
              orderPreference: interet.ordrePreference,
              niveau: interet.niveauInteret,
              commentaire: interet.commentaire ?? '',
            ),
          );
        }
      }

      specialities.sort(
        (a, b) => a.orderPreference.compareTo(b.orderPreference),
      );

      final classe = await _loadClasseForProspect(prospect);
      if (classe != null) {
        prospect.classe.value = classe;
      }

      final etablissement =
          classe != null ? await _loadEtablissementForClasse(classe) : null;

      return ProspectDetails(
        prosp: prospect,
        etablissement: etablissement!,
        classe: classe!,
        specialities: specialities,
      );
    } catch (e) {
      print('❌ Error building prospect details: $e');
      return ProspectDetails(
        prosp: prospect,
        etablissement: Etablissement(
          idEtablissement: 'unknown',
          nomEtablissement: 'Non spécifié',
          typeEtablissement: 'Non spécifié',
          syncState: SyncState.pending,
          createdAt: DateTime.now(),
        ),
        classe: Classe(
          idClasse: 'unknown',
          idEts: 'unknown',
          libelleClasse: 'Non spécifié',
          syncState: SyncState.pending,
          createdAt: DateTime.now(),
        ),
        specialities: [],
      );
    }
  }

  // ==================== STREAMS ====================

  Stream<List<ProspectDetails>> watchProspectsShared({int limit = 500}) {
    _prospectsController ??= StreamController<List<ProspectDetails>>.broadcast(
      onListen: () {},
      onCancel: () {
        if (!(_prospectsController?.hasListener ?? false)) {
          _prospectsWatcher?.cancel().then((_) {
            _prospectsWatcher = null;
          }).catchError((_) {
            _prospectsWatcher = null;
          });
        }
      },
    );

    if (_prospectsWatcher != null) {
      return _prospectsController!.stream;
    }

    try {
      _prospectsWatcher = _isar.prospects
          .where()
          .sortByIdProspectDesc()
          .limit(limit)
          .watch(fireImmediately: true)
          .asyncMap((_) async {
        try {
          final prospects = await _isar.prospects
              .where()
              .sortByIdProspectDesc()
              .limit(limit)
              .findAll();

          if (prospects.isEmpty) return <ProspectDetails>[];

          final List<ProspectDetails> results = [];
          for (final prospect in prospects) {
            await prospect.interets.load();
            for (final interet in prospect.interets) {
              await interet.specialite.load();
            }
            await prospect.classe.load();
            if (prospect.classe.value != null) {
              await prospect.classe.value!.ets.load();
            }

            final List<SpecialityDetail> specs = [];
            for (final interet in prospect.interets) {
              final specialite = interet.specialite.value;
              if (specialite != null) {
                specs.add(
                  SpecialityDetail(
                    libelleSpecialite: specialite.libelleSpecialite,
                    orderPreference: interet.ordrePreference,
                    niveau: interet.niveauInteret,
                    commentaire: interet.commentaire ?? '',
                  ),
                );
              }
            }
            specs
                .sort((a, b) => a.orderPreference.compareTo(b.orderPreference));

            final classe = prospect.classe.value;
            final ets = classe?.ets.value;

            results.add(
              ProspectDetails(
                prosp: prospect,
                etablissement: ets!,
                classe: classe!,
                specialities: specs,
              ),
            );
          }

          return results;
        } catch (e) {
          print('❌ Error in shared prospects watcher: $e');
          return <ProspectDetails>[];
        }
      }).listen(
        (list) {
          try {
            _prospectsController?.add(list);
          } catch (e) {
            // ignore
          }
        },
        onError: (e) {
          _prospectsController?.addError(e);
        },
      );
    } catch (e) {
      print('❌ Error starting shared prospects watcher: $e');
    }

    return _prospectsController!.stream;
  }

  Stream<List<ProspectDetails>> watchProspectsWithSpecs({
    int limit = 500,
  }) async* {
    try {
      yield* _isar.prospects
          .where()
          .sortByIdProspectDesc()
          .limit(limit)
          .watch(fireImmediately: true)
          .asyncMap((_) async {
        try {
          final prospects = await _isar.prospects
              .where()
              .sortByIdProspectDesc()
              .limit(limit)
              .findAll();

          if (prospects.isEmpty) return <ProspectDetails>[];

          final List<ProspectDetails> results = [];
          for (final prospect in prospects) {
            final details = await buildProspectDetails(prospect);
            results.add(details);
          }
          return results;
        } catch (e) {
          print('Error in watchProspectsWithSpecs: $e');
          return <ProspectDetails>[];
        }
      });
    } catch (e) {
      print('Error in watchProspectsWithSpecs: $e');
      yield [];
    }
  }

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
          print('Error in watchFicheById: $e');
          return null;
        }
      });
    } catch (e) {
      print('Error in watchFicheById: $e');
      return Stream.value(null);
    }
  }

  Stream<List<Fiche>> watchAllFiches() {
    try {
      return _isar.fiches.where().watch(fireImmediately: true).asyncMap((
        _,
      ) async {
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
          print('Error in watchAllFiches: $e');
          return <Fiche>[];
        }
      });
    } catch (e) {
      print('Error in watchAllFiches: $e');
      return Stream.value([]);
    }
  }

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
          print('Error in watchProspectById: $e');
          return null;
        }
      });
    } catch (e) {
      print('Error in watchProspectById: $e');
      return Stream.value(null);
    }
  }

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
          print('Error in watchFicheWithDetails: $e');
          return null;
        }
      });
    } catch (e) {
      print('Error in watchFicheWithDetails: $e');
      return Stream.value(null);
    }
  }

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
          print('Error in watchProspectsDetailsByFiche: $e');
          return <ProspectDetails>[];
        }
      });
    } catch (e) {
      print('Error in watchProspectsDetailsByFiche: $e');
      return Stream.value([]);
    }
  }

  // Stream<Map<String, dynamic>> watchStatsOptimized() {
  //   try {
  //     return _isar.prospects.where().watch(fireImmediately: true).asyncMap((
  //       _,
  //     ) async {
  //       try {
  //         final allProspects = await _isar.prospects.where().findAll();
  //         // final allfiches = await _isar.fiches.count();
  //         final now = DateTime.now();
  //         final startOfMonth = DateTime(now.year, now.month, 1);
  //         final endOfMonth = DateTime(now.year, now.month + 1, 0);

  //         final total = allProspects.length;
  //         final aRelancer = allProspects
  //             .where(
  //               (p) => p.date_relance != null && p.date_relance!.isBefore(now),
  //             )
  //             .length;
  //         final visites = allProspects
  //             .where(
  //               (p) =>
  //                   p.createdAt.isAfter(startOfMonth) &&
  //                   p.createdAt.isBefore(endOfMonth),
  //             )
  //             .length;
  //         final nouveauxEtablissements =
  //             allProspects.map((p) => p.idfiche).toSet().length;

  //         return {
  //           'totalProspects': total,
  //           'aRelancer': aRelancer,
  //           'visitesEffectuees': visites,
  //           // 'fiche_formatted': allfiches,
  //           // 'nouveauxEtablissements': nouveauxEtablissements,
  //           'totalFormatted': total >= 10 ? total.toString() : '0$total',
  //           'aRelancerFormatted':
  //               aRelancer >= 10 ? aRelancer.toString() : '0$aRelancer',
  //           'visitesFormatted':
  //               visites >= 10 ? visites.toString() : '0$visites',
  //           'nouveauxFormatted': nouveauxEtablissements >= 10
  //               ? nouveauxEtablissements.toString()
  //               : '0$nouveauxEtablissements',
  //         };
  //       } catch (e) {
  //         print('Error in watchStatsOptimized: $e');
  //         return {
  //           'totalProspects': 0,
  //           'aRelancer': 0,
  //           'visitesEffectuees': 0,
  //           'fiche_formatted': 0,
  //           // 'nouveauxEtablissements': 0,
  //           'totalFormatted': '00',
  //           'aRelancerFormatted': '00',
  //           'visitesFormatted': '00',
  //           'nouveauxFormatted': '00',
  //         };
  //       }
  //     });
  //   } catch (e) {
  //     print('Error in watchStatsOptimized: $e');
  //     return Stream.value({
  //       'totalProspects': 0,
  //       'aRelancer': 0,
  //       'visitesEffectuees': 0,
  //       'nouveauxEtablissements': 0,
  //       'totalFormatted': '00',
  //       'aRelancerFormatted': '00',
  //       'visitesFormatted': '00',
  //       'nouveauxFormatted': '00',
  //     });
  //   }
  // }
  Stream<Map<String, dynamic>> watchStatsOptimized() {
    try {
      return _isar.prospects.where().watch(fireImmediately: true).asyncMap((
        _,
      ) async {
        try {
          final allProspects = await _isar.prospects.where().findAll();
          final allFiches = await _isar.fiches.where().findAll();
          final now = DateTime.now();
          final startOfMonth = DateTime(now.year, now.month, 1);
          final endOfMonth = DateTime(now.year, now.month + 1, 0);
          final startOfDay = DateTime(now.year, now.month, now.day);
          final endOfDay =
              DateTime(now.year, now.month, now.day, 23, 59, 59, 999);

          // Total des prospects
          final total = allProspects.length;

          // ✅ Nombre total de fiches
          final totalFiches = allFiches.length;

          // Prospects à relancer (date de relance passée)
          final aRelancer = allProspects
              .where((p) =>
                  p.date_relance != null && p.date_relance!.isBefore(now))
              .length;

          // Prospects du mois (visites effectuées)
          final visites = allProspects
              .where((p) =>
                  p.createdAt.isAfter(startOfMonth) &&
                  p.createdAt.isBefore(endOfMonth))
              .length;

          // Nouveaux prospects du jour
          final nouveauxAujourdhui = allProspects
              .where((p) =>
                  p.createdAt.isAfter(startOfDay) &&
                  p.createdAt.isBefore(endOfDay))
              .length;

          // Nombre d'établissements uniques (par fiche)
          final nouveauxEtablissements =
              allProspects.map((p) => p.idfiche).toSet().length;

          // ✅ Formatage des nombres
          String formatNumber(int number) {
            return number >= 10 ? number.toString() : '0$number';
          }

          return {
            // Données brutes
            // 'totalProspects': total,
            // 'totalFiches': totalFiches, // ✅ Nombre total de fiches
            // 'aRelancer': aRelancer,
            // 'visitesEffectuees': visites,
            // 'nouveauxAujourdhui': nouveauxAujourdhui,
            // 'nouveauxEtablissements': nouveauxEtablissements,

            // Données formatées (affichage)
            'totalFormatted': formatNumber(total),
            'fichesFormatted': formatNumber(totalFiches), // ✅ Fiches formatées
            'aRelancerFormatted': formatNumber(aRelancer),
            'visitesFormatted': formatNumber(visites),
            'nouveauxFormatted': formatNumber(nouveauxAujourdhui),
          };
        } catch (e) {
          print('Error in watchStatsOptimized asyncMap: $e');
          return {
            'totalFormatted': '00',
            'fichesFormatted': '00',
            'aRelancerFormatted': '00',
            'visitesFormatted': '00',
            'nouveauxFormatted': '00',
            // 'totalFormatted': '00',
            // 'fichesFormatted': '00',
            // 'aRelancerFormatted': '00',
            // 'visitesFormatted': '00',
            // 'nouveauxFormatted': '00',
          };
        }
      });
    } catch (e) {
      print('Error in watchStatsOptimized: $e');
      return Stream.value({
        'totalProspects': 0,
        'totalFiches': 0,
        'aRelancer': 0,
        'visitesEffectuees': 0,
        'nouveauxAujourdhui': 0,
        'nouveauxEtablissements': 0,
        'totalFormatted': '00',
        'fichesFormatted': '00',
        'aRelancerFormatted': '00',
        'visitesFormatted': '00',
        'nouveauxFormatted': '00',
      });
    }
  }

  // ==================== USER ====================

  Future<void> saveUser(User user) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.users.put(user);
      });
    } catch (e) {
      print('Error saving user: $e');
    }
  }

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

  Future<User?> getUserByEmailOrPhone(String emailOrPhone) async {
    try {
      final allUsers = await getAllUsers();
      return allUsers.firstWhere(
        (u) => u.email == emailOrPhone || u.telephone == emailOrPhone,
      );
    } catch (e) {
      print('Error getting user by email or phone: $e');
      return null;
    }
  }

  Future<List<User>> getAllUsers() async {
    try {
      return await _isar.users.where().findAll();
    } catch (e) {
      print('Error getting all users: $e');
      return [];
    }
  }

  Future<List<User>> getUsersByRole(String role) async {
    try {
      return await _isar.users.where().filter().roleEqualTo(role).findAll();
    } catch (e) {
      print('Error getting users by role: $e');
      return [];
    }
  }

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

  Future<void> saveAgent(AgentCommercial agent) async {
    try {
      await isar.writeTxn(() async {
        await isar.agentCommercials.put(agent);
      });
      print('✅ Agent saved successfully: ${agent.idAgent}');
    } catch (e) {
      print('❌ Error saving agent: $e');
      rethrow;
    }
  }

  Future<void> updateAgent(AgentCommercial agent) async {
    try {
      await isar.writeTxn(() async {
        await isar.agentCommercials.put(agent);
      });
      print('✅ Agent updated successfully: ${agent.idAgent}');
    } catch (e) {
      print('❌ Error updating agent: $e');
      rethrow;
    }
  }

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

  // ==================== SEED CLASSES ====================

  // Future<void> seedClassesIfEmpty() async {
  //   try {
  //     final existing = await getAllClasses();
  //     if (existing.isNotEmpty) return;

  //     print('Seeding default classes...');

  //     final List<String> classKeys = [
  //       'class_a1',
  //       'class_a2',
  //       'class_a3',
  //       'class_a4',
  //       'class_abi',
  //       'class_c',
  //       'class_d',
  //       'class_ti',
  //       'class_b',
  //       'class_g1',
  //       'class_g2',
  //       'class_g3',
  //       'class_ses',
  //       'class_f2',
  //       'class_f3',
  //       'class_mav',
  //       'class_f4',
  //       'class_is',
  //       'class_gt',
  //       'class_f1',
  //       'class_ma',
  //       'class_mf_ch',
  //       'class_f7',
  //       'class_ci',
  //       'class_frcl',
  //       'class_ih',
  //       'class_esf',
  //     ];

  //     String generalEtsId;
  //     final generalEts = await getEtablissementByNom('Lycée Général Leclerc');

  //     if (generalEts != null) {
  //       generalEtsId = generalEts.idEtablissement;
  //     } else {
  //       final now = DateTime.now();
  //       final newEts = Etablissement(
  //         idEtablissement: Generator.generateShortId('ets_'),
  //         nomEtablissement: 'Lycée Général Leclerc',
  //         typeEtablissement: 'secondaire',
  //         createdAt: now,
  //         syncState: SyncState.pending,
  //       );
  //       await saveEtablissement(newEts);
  //       generalEtsId = newEts.idEtablissement;
  //     }

  //     final now = DateTime.now();
  //     for (final key in classKeys) {
  //       final classe = Classe(
  //         idClasse: Generator.generateShortId('cls_'),
  //         idEts: generalEtsId,
  //         libelleClasse: key,
  //         createdAt: now,
  //         syncState: SyncState.pending,
  //       );
  //       await saveClasse(classe);
  //     }

  //     print('✅ ${classKeys.length} classes seeded successfully!');
  //   } catch (e) {
  //     print('❌ Error seeding classes: $e');
  //   }
  // }

  Future<void> seedClassesIfEmpty() async {
    try {
      final existing = await getAllClasses();
      if (existing.isNotEmpty) return;

      print('Seeding default classes...');

      // ✅ Map of class keys to both French and English translations
      final Map<String, Map<String, String>> classTranslations = {
        'class_a1': {
          'fr': 'Terminale A1 : Lettres, Latin et Grec',
          'en': 'A1: Literature, Latin and Greek',
        },
        'class_a2': {
          'fr': 'Terminale A2 : Lettres, Latin et Langue Vivante II',
          'en': 'A2: Literature, Latin and Living Language II',
        },
        'class_a3': {
          'fr': 'Terminale A3 : Lettres et Latin',
          'en': 'A3: Literature and Latin',
        },
        'class_a4': {
          'fr': 'Terminale A4 : Lettres, Philosophie et Langues Vivantes',
          'en': 'A4: Literature, Philosophy and Living Languages',
        },
        'class_abi': {
          'fr': 'Terminale ABI : Baccalauréat Bilingue',
          'en': 'ABI: Bilingual Baccalaureate',
        },
        'class_c': {
          'fr': 'Terminale C : Mathématiques, Physique et Chimie',
          'en': 'C: Mathematics, Physics and Chemistry',
        },
        'class_d': {
          'fr':
              'Terminale D : Sciences de la Vie et de la Terre, Physique et Chimie',
          'en': 'D: Life and Earth Sciences, Physics and Chemistry',
        },
        'class_ti': {
          'fr': 'Terminale TI : Technologies de l\'Information',
          'en': 'TI: Information Technology',
        },
        'class_b': {
          'fr': 'Terminale B : Sciences Économiques et Sociales',
          'en': 'B: Economic and Social Sciences',
        },
        'class_g1': {
          'fr': 'Terminale G1 : Secrétariat et Bureautique',
          'en': 'G1: Secretarial and Office Automation',
        },
        'class_g2': {
          'fr': 'Terminale G2 : Comptabilité et Gestion',
          'en': 'G2: Accounting and Management',
        },
        'class_g3': {
          'fr': 'Terminale G3 : Commerce et Vente',
          'en': 'G3: Commerce and Sales',
        },
        'class_ses': {
          'fr': 'Terminale SES : Sciences Économiques et Sociales',
          'en': 'SES: Economic and Social Sciences',
        },
        'class_f2': {
          'fr': 'Terminale F2 : Électronique',
          'en': 'F2: Electronics',
        },
        'class_f3': {
          'fr': 'Terminale F3 : Électrotechnique',
          'en': 'F3: Electrotechnics',
        },
        'class_mav': {
          'fr': 'Terminale MAV : Maintenance Audiovisuelle',
          'en': 'MAV: Audiovisual Maintenance',
        },
        'class_f4': {
          'fr': 'Terminale F4 : Génie Civil / Bâtiment et Travaux Publics',
          'en': 'F4: Civil Engineering / Building and Public Works',
        },
        'class_is': {
          'fr': 'Terminale IS : Installation Sanitaire',
          'en': 'IS: Sanitary Installation',
        },
        'class_gt': {
          'fr': 'Terminale GT : Géomètre Topographe',
          'en': 'GT: Topographic Surveyor',
        },
        'class_f1': {
          'fr': 'Terminale F1 : Construction Mécanique',
          'en': 'F1: Mechanical Construction',
        },
        'class_ma': {
          'fr': 'Terminale MA : Mécanique Automobile',
          'en': 'MA: Automotive Mechanics',
        },
        'class_mf_ch': {
          'fr': 'Terminale MF/CH : Menuiserie et Charpente',
          'en': 'MF/CH: Carpentry and Woodworking',
        },
        'class_f7': {
          'fr': 'Terminale F7 : Sciences Biologiques et Biochimie',
          'en': 'F7: Biological Sciences and Biochemistry',
        },
        'class_ci': {
          'fr': 'Terminale CI : Chimie Industrielle',
          'en': 'CI: Industrial Chemistry',
        },
        'class_frcl': {
          'fr': 'Terminale FRCL : Froid et Climatisation',
          'en': 'FRCL: Refrigeration and Air Conditioning',
        },
        'class_ih': {
          'fr':
              'Terminale IH : Industrie de l\'Habillement (Couture et Stylisme)',
          'en': 'IH: Clothing Industry (Sewing and Styling)',
        },
        'class_esf': {
          'fr': 'Terminale ESF : Économie Sociale et Familiale',
          'en': 'ESF: Social and Family Economics',
        },
      };

      // ✅ Get or create establishment
      String generalEtsId;
      final generalEts = await getEtablissementByNom('Lycée Général Leclerc');

      if (generalEts != null) {
        generalEtsId = generalEts.idEtablissement;
      } else {
        final now = DateTime.now();
        final newEts = Etablissement(
          idEtablissement: Generator.generateShortId('ets_'),
          nomEtablissement: 'Lycée Général Leclerc',
          typeEtablissement: 'secondaire',
          createdAt: now,
          syncState: SyncState.pending,
        );
        await saveEtablissement(newEts);
        generalEtsId = newEts.idEtablissement;
      }

      final now = DateTime.now();

      // ✅ Create entries with duplicate detection
      final List<Classe> classesToSave = [];
      final Set<String> uniqueNames = {};

      for (final entry in classTranslations.entries) {
        final String frValue = entry.value['fr']!;
        final String enValue = entry.value['en']!;

        // ✅ If French and English are the same, save only one entry
        if (frValue == enValue) {
          if (!uniqueNames.contains(frValue)) {
            uniqueNames.add(frValue);
            classesToSave.add(Classe(
              idClasse: Generator.generateShortId('cls_'),
              idEts: generalEtsId,
              libelleClasse: frValue,
              createdAt: now,
              syncState: SyncState.pending,
            ));
            print('📌 Single entry for: "$frValue" (FR = EN)');
          }
        } else {
          // ✅ French version
          if (!uniqueNames.contains(frValue)) {
            uniqueNames.add(frValue);
            classesToSave.add(Classe(
              idClasse: Generator.generateShortId('cls_'),
              idEts: generalEtsId,
              libelleClasse: frValue,
              createdAt: now,
              syncState: SyncState.pending,
            ));
          }

          // ✅ English version
          if (!uniqueNames.contains(enValue)) {
            uniqueNames.add(enValue);
            classesToSave.add(Classe(
              idClasse: Generator.generateShortId('cls_'),
              idEts: generalEtsId,
              libelleClasse: enValue,
              createdAt: now,
              syncState: SyncState.pending,
            ));
          }
        }
      }

      // ✅ Save all classes
      for (final classe in classesToSave) {
        await saveClasse(classe);
      }

      print('✅ ${classesToSave.length} unique classes seeded successfully!');
      // print('📊 French entries: ${classesToSave.where((c) => c.idClasse.contains('cls_fr_')).length}');
      // print('📊 English entries: ${classesToSave.where((c) => c.idClasse.contains('cls_en_')).length}');
      // print('📊 Shared entries: ${classesToSave.where((c) => !c.idClasse.contains('cls_fr_') && !c.idClasse.contains('cls_en_')).length}');
    } catch (e) {
      print('❌ Error seeding classes: $e');
    }
  }

  // ==================== SEED SPECIALTIES ====================

  // Future<void> seedSpecialtiesIfEmpty() async {
  //   try {
  //     final existing = await getAllSpecialites();
  //     if (existing.isNotEmpty) return;

  //     print('Seeding default specialties...');

  //     final List<String> specialtyKeys = [
  //       'software_engineering',
  //       'computer_systems_maintenance',
  //       'industrial_computing_and_automation',
  //       'computer_engineering_and_telecommunications',
  //       'computer_graphics_and_web_design',
  //       'ecommerce_and_digital_marketing',
  //       'building_construction',
  //       'public_works',
  //       'carpentry_and_cabinetmaking',
  //       'electrical_engineering',
  //       'electrotechnics',
  //       'electronic_systems_maintenance',
  //       'thermal_and_energy_engineering',
  //       'refrigeration_and_air_conditioning',
  //       'fluid_systems_maintenance',
  //       'mechanical_engineering',
  //       'mechanical_manufacturing',
  //       'mechanical_construction',
  //       'metal_construction',
  //       'boilermaking_and_welding',
  //       'automotive_engineering',
  //       'automobile_engineering',
  //       'mechatronics',
  //       'automotive_mechanics_and_electronics',
  //       'marketing_sales',
  //       'international_trade',
  //       'accounting_and_business_management',
  //       'banking_and_finance',
  //       'assistant_manager',
  //       'human_resource_management',
  //       'quality_management',
  //       'communication_advertising',
  //       'transport_and_logistics',
  //       'marketing_communication',
  //       'accounting_and_finance',
  //       'qhse_management',
  //       'entrepreneurship',
  //       'naval_electromechanics',
  //       'port_and_maritime_logistics',
  //       'nautical_sciences',
  //       'offshore_and_maritime_safety',
  //       'aquaculture',
  //       'maritime_and_port_administration',
  //       'marine_fisheries_technology',
  //     ];

  //     final now = DateTime.now();
  //     for (final key in specialtyKeys) {
  //       final spec = Specialite(
  //         idSpecialite: Generator.generateShortId('spec_'),
  //         libelleSpecialite: key,
  //         description: "no description",
  //         createdAt: now,
  //         syncState: SyncState.pending,
  //       );
  //       await saveSpecialite(spec);
  //     }

  //     print('✅ ${specialtyKeys.length} specialties seeded successfully!');
  //   } catch (e) {
  //     print('❌ Error seeding specialties: $e');
  //   }
  // }

  Future<void> seedSpecialtiesIfEmpty() async {
    try {
      final existing = await getAllSpecialites();
      if (existing.isNotEmpty) return;

      print('Seeding default specialties...');

      // ✅ Map of specialty keys to both French and English translations
      final Map<String, Map<String, String>> specialtyTranslations = {
        'software_engineering': {
          'fr': 'Génie Logiciel',
          'en': 'Software Engineering',
        },
        'computer_systems_maintenance': {
          'fr': 'Maintenance des Systèmes Informatiques',
          'en': 'Computer Systems Maintenance',
        },
        'industrial_computing_and_automation': {
          'fr': 'Informatique Industrielle et Automatisme',
          'en': 'Industrial Computing and Automation',
        },
        'computer_engineering_and_telecommunications': {
          'fr': 'Génie Informatique et Télécommunication',
          'en': 'Computer Engineering and Telecommunications',
        },
        'computer_graphics_and_web_design': {
          'fr': 'Infographie et Web Design',
          'en': 'Computer Graphics and Web Design',
        },
        'ecommerce_and_digital_marketing': {
          'fr': 'E-Commerce et Marketing Numérique',
          'en': 'E-Commerce and Digital Marketing',
        },
        'building_construction': {
          'fr': 'Bâtiment',
          'en': 'Building Construction',
        },
        'public_works': {
          'fr': 'Travaux Publics et Ouvrages',
          'en': 'Public Works',
        },
        'carpentry_and_cabinetmaking': {
          'fr': 'Menuiserie - Ébénisterie',
          'en': 'Carpentry and Cabinetmaking',
        },
        'electrical_engineering': {
          'fr': 'Génie Électrique',
          'en': 'Electrical Engineering',
        },
        'electrotechnics': {
          'fr': 'Électrotechnique',
          'en': 'Electrotechnics',
        },
        'electronic_systems_maintenance': {
          'fr': 'Maintenance des Systèmes Électroniques',
          'en': 'Electronic Systems Maintenance',
        },
        'thermal_and_energy_engineering': {
          'fr': 'Génie Thermique et Énergie',
          'en': 'Thermal and Energy Engineering',
        },
        'refrigeration_and_air_conditioning': {
          'fr': 'Froid et Climatisation',
          'en': 'Refrigeration and Air Conditioning',
        },
        'fluid_systems_maintenance': {
          'fr': 'Maintenance des Systèmes Fluides',
          'en': 'Fluid Systems Maintenance',
        },
        'mechanical_engineering': {
          'fr': 'Génie Mécanique',
          'en': 'Mechanical Engineering',
        },
        'mechanical_manufacturing': {
          'fr': 'Fabrication Mécanique',
          'en': 'Mechanical Manufacturing',
        },
        'mechanical_construction': {
          'fr': 'Construction Mécanique',
          'en': 'Mechanical Construction',
        },
        'metal_construction': {
          'fr': 'Construction Métallique',
          'en': 'Metal Construction',
        },
        'boilermaking_and_welding': {
          'fr': 'Chaudronnerie et Soudure',
          'en': 'Boilermaking and Welding',
        },
        'automotive_engineering': {
          'fr': 'Génie Automobile',
          'en': 'Automotive Engineering',
        },
        'automobile_engineering': {
          'fr': 'Ingénierie Automobile',
          'en': 'Automobile Engineering',
        },
        'mechatronics': {
          'fr': 'Mécatronique',
          'en': 'Mechatronics',
        },
        'automotive_mechanics_and_electronics': {
          'fr': 'Mécanique et Électronique Automobile',
          'en': 'Automotive Mechanics and Electronics',
        },
        'marketing_sales': {
          'fr': 'Marketing Commerce Vente',
          'en': 'Marketing, Sales and Commerce',
        },
        'international_trade': {
          'fr': 'Commerce International',
          'en': 'International Trade',
        },
        'accounting_and_business_management': {
          'fr': 'Comptabilité et Gestion des Entreprises',
          'en': 'Accounting and Business Management',
        },
        'banking_and_finance': {
          'fr': 'Banque et Finance',
          'en': 'Banking and Finance',
        },
        'assistant_manager': {
          'fr': 'Assistant Manager',
          'en': 'Assistant Manager',
        },
        'human_resource_management': {
          'fr': 'Gestion des Ressources Humaines',
          'en': 'Human Resource Management',
        },
        'quality_management': {
          'fr': 'Gestion de la Qualité',
          'en': 'Quality Management',
        },
        'communication_advertising': {
          'fr': 'Communication (Publicité)',
          'en': 'Communication and Advertising',
        },
        'transport_and_logistics': {
          'fr': 'Transport et Logistique',
          'en': 'Transport and Logistics',
        },
        'marketing_communication': {
          'fr': 'Marketing Communication',
          'en': 'Marketing Communication',
        },
        'accounting_and_finance': {
          'fr': 'Comptabilité et Finance',
          'en': 'Accounting and Finance',
        },
        'qhse_management': {
          'fr': 'Management Qualité, Sécurité et Environnement',
          'en': 'Quality, Health, Safety and Environment Management',
        },
        'entrepreneurship': {
          'fr': 'Entrepreneuriat',
          'en': 'Entrepreneurship',
        },
        'naval_electromechanics': {
          'fr': 'Électromécanique Navale',
          'en': 'Naval Electromechanics',
        },
        'port_and_maritime_logistics': {
          'fr': 'Gestion et Logistique Portuaire et Maritime',
          'en': 'Port and Maritime Logistics Management',
        },
        'nautical_sciences': {
          'fr': 'Sciences Nautiques',
          'en': 'Nautical Sciences',
        },
        'offshore_and_maritime_safety': {
          'fr': 'Sécurité et Sûreté des Plates-formes Pétrolières et Maritimes',
          'en': 'Offshore and Maritime Safety',
        },
        'aquaculture': {
          'fr': 'Aquaculture',
          'en': 'Aquaculture',
        },
        'maritime_and_port_administration': {
          'fr': 'Administration Maritime et Portuaire',
          'en': 'Maritime and Port Administration',
        },
        'marine_fisheries_technology': {
          'fr': 'Technologie des Pêches Maritimes',
          'en': 'Marine Fisheries Technology',
        },
      };

      final now = DateTime.now();

      // ✅ Create entries with duplicate detection
      final List<Specialite> specialtiesToSave = [];
      final Set<String> uniqueNames = {};

      for (final entry in specialtyTranslations.entries) {
        final String frValue = entry.value['fr']!;
        final String enValue = entry.value['en']!;

        // ✅ If French and English are the same, save only one entry
        if (frValue == enValue) {
          if (!uniqueNames.contains(frValue)) {
            uniqueNames.add(frValue);
            specialtiesToSave.add(Specialite(
              idSpecialite: Generator.generateShortId('spec_'),
              libelleSpecialite: frValue,
              description: "no description",
              createdAt: now,
              syncState: SyncState.pending,
            ));
            print('📌 Single entry for: "$frValue" (FR = EN)');
          }
        } else {
          // ✅ French version
          if (!uniqueNames.contains(frValue)) {
            uniqueNames.add(frValue);
            specialtiesToSave.add(Specialite(
              // idSpecialite: Generator.generateShortId('spec_fr_'),
              idSpecialite: Generator.generateShortId('spec_'),
              libelleSpecialite: frValue,
              description: "no description",
              createdAt: now,
              syncState: SyncState.pending,
            ));
          }

          // ✅ English version
          if (!uniqueNames.contains(enValue)) {
            uniqueNames.add(enValue);
            specialtiesToSave.add(Specialite(
              idSpecialite: Generator.generateShortId('spec_'),
              // idSpecialite: Generator.generateShortId('spec_en_'),
              libelleSpecialite: enValue,
              description: "no description",
              createdAt: now,
              syncState: SyncState.pending,
            ));
          }
        }
      }

      // ✅ Save all specialties
      for (final spec in specialtiesToSave) {
        await saveSpecialite(spec);
      }

      print(
          '✅ ${specialtiesToSave.length} unique specialties seeded successfully!');
      // print('📊 French entries: ${specialtiesToSave.where((s) => s.idSpecialite.contains('spec_fr_')).length}');
      // print('📊 English entries: ${specialtiesToSave.where((s) => s.idSpecialite.contains('spec_en_')).length}');
      // print('📊 Shared entries: ${specialtiesToSave.where((s) => !s.idSpecialite.contains('spec_fr_') && !s.idSpecialite.contains('spec_en_')).length}');
    } catch (e) {
      print('❌ Error seeding specialties: $e');
    }
  }

// lib/models/localStorage/local_storage.dart

// ==================== SORTIE METHODS ====================

  /// Save or update a sortie
  Future<void> saveSortie(Sortie sortie) async {
    try {
      await isar.writeTxn(() async {
        await isar.sorties.put(sortie);
      });
      print('✅ Sortie saved: ${sortie.idSortie}');
    } catch (e) {
      print('❌ Error saving sortie: $e');
      rethrow;
    }
  }

  /// Save sortie with relations (Zone and Campagne)
  Future<void> saveSortieWithRelations(
      Sortie sortie, Zone zone, Campagne campagne) async {
    try {
      await isar.writeTxn(() async {
        // Save zone
        await isar.zones.put(zone);

        // Save campagne
        await isar.campagnes.put(campagne);

        // Save sortie
        await isar.sorties.put(sortie);

        // Link relations
        final savedSortie = await isar.sorties
            .where()
            .idSortieEqualTo(sortie.idSortie)
            .findFirst();
        final savedZone =
            await isar.zones.where().idZoneEqualTo(zone.idZone).findFirst();
        final savedCampagne = await isar.campagnes
            .where()
            .idCampagneEqualTo(campagne.idCampagne)
            .findFirst();

        if (savedSortie != null && savedZone != null) {
          savedSortie.zone.value = savedZone;
        }
        if (savedSortie != null && savedCampagne != null) {
          savedSortie.campagne.value = savedCampagne;
        }
      });
      print('✅ Sortie with relations saved: ${sortie.idSortie}');
    } catch (e) {
      print('❌ Error saving sortie with relations: $e');
      rethrow;
    }
  }

  /// Get sortie by ID
  Future<Sortie?> getSortieById(String sortieId) async {
    try {
      return await isar.sorties.where().idSortieEqualTo(sortieId).findFirst();
    } catch (e) {
      print('❌ Error getting sortie: $e');
      return null;
    }
  }

  /// Get sortie with relations (Zone and Campagne)
  Future<Sortie?> getSortieWithRelations(String sortieId) async {
    try {
      final sortie =
          await isar.sorties.where().idSortieEqualTo(sortieId).findFirst();

      if (sortie != null) {
        await sortie.zone.load();
        await sortie.campagne.load();
      }
      return sortie;
    } catch (e) {
      print('❌ Error getting sortie with relations: $e');
      return null;
    }
  }

  /// Get current active sortie
  Future<Sortie?> getCurrentSortie() async {
    try {
      return await isar.sorties
          .where()
          .filter()
          .statutEqualTo('en-cours')
          .findFirst();
    } catch (e) {
      print('❌ Error getting current sortie: $e');
      return null;
    }
  }

  /// Get all sorties
  Future<List<Sortie>> getAllSorties() async {
    try {
      return await isar.sorties.where().sortByCreatedAtDesc().findAll();
    } catch (e) {
      print('❌ Error getting all sorties: $e');
      return [];
    }
  }

  /// Delete sortie
  Future<void> deleteSortie(String sortieId) async {
    try {
      await isar.writeTxn(() async {
        await isar.sorties.where().idSortieEqualTo(sortieId).deleteFirst();
      });
      print('✅ Sortie deleted: $sortieId');
    } catch (e) {
      print('❌ Error deleting sortie: $e');
      rethrow;
    }
  }
}
