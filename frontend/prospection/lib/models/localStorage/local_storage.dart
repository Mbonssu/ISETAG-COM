// ignore_for_file: avoid_print

import 'dart:math';

import 'package:isar/isar.dart';
import 'package:isetagcom/models/prospectData.dart';
import 'package:path_provider/path_provider.dart';
import '../pros.dart';
import '../fiche.dart';
import '../interet_filiere.dart';
import '../source.dart';
import '../etablissement.dart';
import '../classe.dart';
import '../specialite.dart';
import '../user.dart';
import '../agent_commercial.dart';

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

  // ==================== PROSPECT - OPTIMIZED CHECKERS ====================

  // ✅ OPTIMIZED: Uses index to find by phone directly
  Future<bool> _prospectExistsByPhone(String phone) async {
    try {
      final result = await _isar.prospects
          .where()
          .telephoneEqualTo(phone)
          .findFirst();
      return result != null;
    } catch (e) {
      return false;
    }
  }

  // ✅ OPTIMIZED: Uses index to find by email directly
  Future<bool> _prospectExistsByEmail(String? email) async {
    if (email == null || email.isEmpty) return false;
    try {
      final result = await _isar.prospects
          .where()
          .emailEqualTo(email)
          .findFirst();
      return result != null;
    } catch (e) {
      return false;
    }
  }

  // ✅ OPTIMIZED: Uses index to find by name directly
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

  // ✅ OPTIMIZED: Check if fiche exists by ID
  Future<bool> _ficheExists(String idFiche) async {
    try {
      final result = await _isar.fiches
          .where()
          .idFicheEqualTo(idFiche)
          .findFirst();
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

  // ==================== INTERET FILIERE - OPTIMIZED CHECKER ====================

  // ✅ OPTIMIZED: Check if interet exists
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

  // ==================== INTERET FILIERE - CHECKER ====================

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

  // ✅ OPTIMIZED: Check if source exists by ID
  Future<bool> _sourceExists(String idSource) async {
    try {
      final result = await _isar.sources
          .where()
          .idSourceEqualTo(idSource)
          .findFirst();
      return result != null;
    } catch (e) {
      return false;
    }
  }

  // ✅ OPTIMIZED: Check if source exists by name
  Future<bool> _sourceExistsByName(String libelle) async {
    try {
      final result = await _isar.sources
          .where()
          .libelleSourceEqualTo(libelle)
          .findFirst();
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

  // ==================== ETABLISSEMENT - OPTIMIZED CHECKER ====================

  // ✅ OPTIMIZED: Check if etablissement exists by name using index
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

  // ✅ OPTIMIZED: Check if etablissement exists by ID
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

  // ==================== ETABLISSEMENT - CHECKER ====================

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

  // ✅ OPTIMIZED: Check if class exists
  Future<bool> _classeExists(String idClasse) async {
    try {
      final result = await _isar.classes
          .where()
          .idClasseEqualTo(idClasse)
          .findFirst();
      return result != null;
    } catch (e) {
      return false;
    }
  }

  // ✅ OPTIMIZED: Check if class exists by libelle and establishment
  Future<bool> _classeExistsByLibelleAndEts(String libelle, String idEts) async {
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

      if (await _classeExistsByLibelleAndEts(classe.libelleClasse, classe.idEts)) {
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

  // ==================== CLASSE - CHECKER ====================

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

  // ✅ OPTIMIZED: Check if specialite exists by name using index
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

  // ✅ OPTIMIZED: Check if specialite exists by ID
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

  // ==================== STREAMS WITH ERROR HANDLING ====================

  static Stream<List<ProspectDetails>> watchProspectsWithSpecs(
      {int limit = 500}) async* {
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

          final ids = prospects.map((p) => p.idProspect).toList();

          final allLinks = await isar.interetFilieres
              .filter()
              .anyOf(ids,
                  (q, id) => q.prospect((link) => link.idProspectEqualTo(id)))
              .findAll();

          final classeIds = prospects
              .map((p) => p.classe.value?.idClasse)
              .whereType<int>()
              .toList();
          final classes = await isar.classes.getAll(classeIds);
          final classeMap = {
            for (var c in classes.whereType<Classe>()) c.idClasse: c
          };

          final etsIds = classes
              .whereType<Classe>()
              .map((c) => c.ets.value?.idEtablissement)
              .whereType<int>()
              .toList();
          final etss = await isar.etablissements.getAll(etsIds);
          final etsMap = {
            for (var e in etss.whereType<Etablissement>()) e.idEtablissement: e
          };

          return prospects.map((p) {
            final specsP = allLinks
                .where((l) =>
                    l.prospect.value?.idProspect == p.idProspect ||
                    l.prospect.value?.idProspect == p.idProspect)
                .map((l) => SpecialityDetail(
                      libelleSpecialite:
                          l.specialite.value?.libelleSpecialite ?? '',
                      orderPreference: l.ordrePreference,
                      niveau: l.niveauInteret,
                      commentaire: l.commentaire,
                    ))
                .toList()
              ..sort((a, b) => a.orderPreference.compareTo(b.orderPreference));

            final classe = classeMap[p.classe.value?.idClasse];
            final ets = classe != null
                ? etsMap[classe.ets.value?.idEtablissement]
                : null;

            return ProspectDetails(
              prosp: p,
              etablissement: ets?.nomEtablissement ?? '',
              classe: classe?.libelleClasse ?? '',
              specialities: specsP,
            );
          }).toList();
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
          final now = DateTime.now();
          final startOfMonth = DateTime(now.year, now.month, 1);
          final endOfMonth = DateTime(now.year, now.month + 1, 0);

          final total = allProspects.length;
          final aRelancer = allProspects
              .where((p) =>
                  p.date_relance != null && p.date_relance!.isBefore(now))
              .length;
          final visites = allProspects
              .where((p) =>
                  p.createdAt.isAfter(startOfMonth) &&
                  p.createdAt.isBefore(endOfMonth))
              .length;
          final nouveauxEtablissements =
              allProspects.map((p) => p.idfiche).toSet().length;

          return {
            'totalProspects': total,
            'aRelancer': aRelancer,
            'visitesEffectuees': visites,
            'nouveauxEtablissements': nouveauxEtablissements,
            'totalFormatted': total >= 10 ? total.toString() : '0$total',
            'aRelancerFormatted':
                aRelancer >= 10 ? aRelancer.toString() : '0$aRelancer',
            'visitesFormatted':
                visites >= 10 ? visites.toString() : '0$visites',
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
      return await _isar.users
          .where()
          .filter()
          .roleEqualTo(role)
          .findAll();
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