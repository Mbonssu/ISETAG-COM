import 'dart:math';
import 'package:isar_community/isar.dart';
import 'package:isetagcom/models/localStorage/local_storage.dart';
import 'package:isetagcom/models/pros.dart';
import 'package:isetagcom/models/classe.dart';
import 'package:isetagcom/models/etablissement.dart';
import 'package:isetagcom/models/specialite.dart';
import 'package:isetagcom/models/interet_filiere.dart';
import 'package:isetagcom/models/source.dart';
import 'package:isetagcom/models/fiche.dart';
import 'package:isetagcom/services/notification_service.dart';
import 'package:isetagcom/utils/status.dart';

class TestDataGenerator {
  static final Random _random = Random();

  static final List<String> _firstNames = [
    'Jean',
    'Marie',
    'Pierre',
    'Anne',
    'Louis',
    'Sophie',
    'Michel',
    'Claire',
    'Franc',
    'Isabe',
    'Paul',
    'Cath',
    'Andre',
    'Nath',
    'Phili',
    'Chris',
    'Dan',
    'Brig',
    'Jacq',
    'Mart',
    'Alain',
    'Val',
    'Bern',
    'Sylv',
    'Charles',
    'Monique',
    'Robert',
    'Nicole',
    'Marc',
    'Jacqu',
    'Gerard',
    'Chant',
    'Pat',
    'Domin',
    'J-P',
    'Denis',
    'Mich',
    'Olivier',
    'Colette',
    'Christian',
    'Made',
    'J-L',
    'Suzan',
    'Rene',
    'Mire',
    'Nico',
    'Helene',
    'Chris',
    'Jos',
    'Steph',
    'Caroline',
    'Seb',
    'Laure',
    'Antoine',
    'Odile',
    'Romain',
    'Cecile',
    'Julien',
    'Gaelle',
    'Alex',
    'Elodie',
    'Mathieu',
    'Aurelie',
    'David',
    'Marion',
    'Thomas',
    'Manon',
    'Jerome',
    'Camille',
    'Vincent',
    'Eva',
    'Hugo',
    'Lea',
    'Adrien',
    'Theo',
    'Sarah',
    'Maxime',
    'Ines',
    'Raphael',
    'Chloe',
    'Lucas',
    'Pauline',
    'Gabin',
    'Leonie',
    'Nathan',
    'Emma',
    'Louis',
    'Alice',
    'Gabriel',
    'Juliette',
    'Liam',
    'Elena',
    'Arthur',
    'Noemie'
  ];

  static final List<String> _lastNames = [
    'Martin',
    'Bernard',
    'Dubois',
    'Thomas',
    'Robert',
    'Richard',
    'Petit',
    'Durand',
    'Leroy',
    'Moreau',
    'Simon',
    'Laurent',
    'Lefebvre',
    'Michel',
    'Garcia',
    'David',
    'Bertrand',
    'Roux',
    'Vincent',
    'Fournier',
    'Morel',
    'Girard',
    'Andre',
    'Lefevre',
    'Mercier',
    'Dupont',
    'Lambert',
    'Bonnet',
    'Francois',
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
    'Roger',
    'Schmitt',
    'Gauthier',
    'Clement',
    'Fernandez',
    'Fontaine',
    'Lopez',
    'Benoit',
    'Joly',
    'Gautier',
    'Carpentier',
    'Moulin',
    'Chevalier',
    'Riviere',
    'Perez',
    'Marin',
    'Boucher',
    'Caron',
    'Perrot',
    'Dufour',
    'Girard',
    'Marechal',
    'Lemoine',
    'Giraud',
    'Roche',
    'Marty',
    'Picard',
    'Legros',
    'Bertin',
    'Meyer',
    'Gros',
    'Adam',
    'Fleury'
  ];

  static final List<String> _specialityKeys = [
    'software_eng',
    'comp_sys_maint',
    'indus_comp_auto',
    'comp_eng_telecom',
    'comp_graphics',
    'ecommerce_digit',
    'building_const',
    'public_works',
    'carpentry_cab',
    'electrical_eng',
    'electrotech',
    'elec_sys_maint',
    'thermal_energy',
    'refrigeration',
    'fluid_sys',
    'mechanical_eng',
    'mech_manufact',
    'mech_const',
    'metal_const',
    'boilermaking',
    'automotive_eng',
    'automobile_eng',
    'mechatronics',
    'auto_mech_elec',
    'marketing_sales',
    'intl_trade',
    'accounting_mgmt',
    'banking_finance',
    'assistant_mgr',
    'hr_mgmt',
    'quality_mgmt',
    'comm_advertising',
    'transport_log',
    'marketing_comm',
    'accounting_fin',
    'qhse_mgmt',
    'entrepreneur',
    'naval_electro',
    'port_maritime',
    'nautical_sci',
    'offshore_safety',
    'aquaculture',
    'maritime_admin',
    'marine_fisheries'
  ];

  static final List<String> _niveauEtudes = [
    'Baccalaureat',
    'BTS_1',
    'BTS_2',
    'Licence',
    'Master_1',
    'Master_2'
  ];

  static final List<String> _sexeOptions = ['Masculin', 'Feminin'];
  static final List<String> _typeProspectOptions = ['Etudiant', 'Eleve'];

  // ✅ Domaines d'email courts (pour éviter la troncature)
  static final List<String> _emailDomains = [
    'gmail.com',
    'yahoo.com',
    'outlook.com',
    'hotmail.com',
    'proton.me', // Court
    'email.fr', // Court
    'mail.fr', // Court
    'test.io', // Court
    'inbox.fr', // Court
    'live.fr' // Court
  ];

  // ✅ Générer un email valide (SANS TRONCATURE)
  static String _generateValidEmail(
      String firstName, String lastName, int index) {
    final cleanFirstName = firstName
        .toLowerCase()
        .replaceAll('é', 'e')
        .replaceAll('è', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('à', 'a')
        .replaceAll('â', 'a')
        .replaceAll('ô', 'o')
        .replaceAll('û', 'u')
        .replaceAll('ç', 'c')
        .replaceAll("'", '')
        .replaceAll(' ', '')
        .replaceAll('-', '');

    final cleanLastName = lastName
        .toLowerCase()
        .replaceAll('é', 'e')
        .replaceAll('è', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('à', 'a')
        .replaceAll('â', 'a')
        .replaceAll('ô', 'o')
        .replaceAll('û', 'u')
        .replaceAll('ç', 'c')
        .replaceAll("'", '')
        .replaceAll(' ', '')
        .replaceAll('-', '');

    final domain = _emailDomains[_random.nextInt(_emailDomains.length)];
    final number = _random.nextInt(1000);

    // ✅ Retourner l'email complet sans troncature
    return '$cleanFirstName.$cleanLastName$number@$domain';
  }

  // ✅ Générer un ID court
  static String _shortId(String prefix, int index, int timestamp) {
    final shortTime =
        timestamp.toString().substring(timestamp.toString().length - 6);
    return '$prefix$shortTime$index';
  }

  // ✅ Tronquer un texte (pour les champs non-email)
  static String _truncate(String text, {int maxLength = 25}) {
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength);
  }

  static Future<void> generate500Prospects() async {
    try {
      final localStorage = LocalStorage.instance;

      try {
        final testIsar = localStorage.isar;
      } catch (e) {
        await localStorage.init();
      }

      final isar = localStorage.isar;
      final now = DateTime.now();
      final timestamp = now.millisecondsSinceEpoch;

      // ✅ CRÉER UNE SOURCE DE TEST
      final testSource = Source(
        idSource: _shortId('src_', 0, timestamp),
        libelleSource: 'test_Prospection',
        createdAt: now,
        syncState: SyncState.pending,
      );
      await localStorage.saveSource(testSource);

      // ✅ CRÉER UNE FICHE DE TEST
      final testFiche = Fiche(
        idFiche: _shortId('fch_', 0, timestamp),
        idSrc: testSource.idSource,
        dateCollecte: now,
        commentaire: 'test_Fiche',
        scoreInteret: 5,
        createdAt: now,
        isCurrent: true,
        syncState: SyncState.pending,
      );
      await localStorage.saveFiche(testFiche);

      // ✅ CRÉER 5 ÉTABLISSEMENTS DE TEST
      final List<Etablissement> testEtablissements = [];
      final List<String> etsNames = [
        'test_Lyc_Biyem',
        "test_Lyc_Efouan",
        'test_Inst_Conf',
        'test_Lyc_Leclerc',
        'test_Coll_Vogt',
      ];

      for (int i = 0; i < etsNames.length; i++) {
        final ets = Etablissement(
          idEtablissement: _shortId('ets_', i, timestamp),
          nomEtablissement: etsNames[i],
          typeEtablissement: i % 2 == 0 ? 'secondaire' : 'superieur',
          adresse: _truncate('test_${_random.nextInt(200) + 1} Rue Paris'),
          telephone: '6${_random.nextInt(90000000) + 10000000}',
          ville: 'test_Yaounde',
          region: 'test_Centre',
          createdAt: now,
          syncState: SyncState.pending,
        );
        await localStorage.saveEtablissement(ets);
        testEtablissements.add(ets);
      }

      // ✅ CRÉER 10 CLASSES DE TEST
      final List<Classe> testClasses = [];
      final List<String> classNames = [
        'test_Term_C',
        'test_Term_D',
        'test_Term_A4',
        'test_Term_TI',
        'test_Term_B',
        'test_Term_G1',
        'test_Term_G2',
        'test_Term_F2',
        'test_Term_F3',
        'test_Term_MA',
      ];

      for (int i = 0; i < classNames.length; i++) {
        final ets =
            testEtablissements[_random.nextInt(testEtablissements.length)];
        final shortName =
            _truncate(classNames[i].replaceAll(' ', '_').replaceAll("'", '_'));
        final classe = Classe(
          idClasse: _shortId('cls_', i, timestamp),
          idEts: ets.idEtablissement,
          libelleClasse: shortName,
          createdAt: now,
          syncState: SyncState.pending,
        );
        classe.ets.value = ets;
        await localStorage.saveClasse(classe);
        testClasses.add(classe);
      }

      // ✅ CRÉER 10 SPÉCIALITÉS DE TEST
      final List<Specialite> testSpecialites = [];
      final List<String> specNames = _specialityKeys.take(10).toList();

      for (int i = 0; i < specNames.length; i++) {
        final spec = Specialite(
          idSpecialite: _shortId('spc_', i, timestamp),
          libelleSpecialite: specNames[i],
          description: 'test_spec',
          createdAt: now,
          syncState: SyncState.pending,
        );
        await localStorage.saveSpecialite(spec);
        testSpecialites.add(spec);
      }

      // ✅ DÉFINIR LES DATES DE RELANCE
      int startMinute = now.minute + 5;
      int startHour = now.hour;

      if (startMinute >= 60) {
        startMinute -= 60;
        startHour += 1;
      }

      if (startHour >= 24) {
        startHour = 0;
      }

      final startDate = DateTime(
        now.year,
        now.month,
        now.day,
        startHour,
        startMinute,
      );

      final List<DateTime> groupDates = [];

      for (int i = 0; i < 5; i++) {
        final minutesOffset = i * 10;
        final date = startDate.add(Duration(minutes: minutesOffset));
        groupDates.add(date);
      }

      // ✅ GÉNÉRER 500 PROSPECTS
      int totalSaved = 0;
      const int groupSize = 10;

      for (int groupIndex = 0; groupIndex < 5; groupIndex++) {
        final relanceDate = groupDates[groupIndex];

        for (int i = 0; i < groupSize; i++) {
          final prospectIndex = groupIndex * groupSize + i;

          final firstName = _firstNames[_random.nextInt(_firstNames.length)];
          final lastName = _lastNames[_random.nextInt(_lastNames.length)];

          final fullName = _truncate('test_$firstName $lastName');
          final classe = testClasses[_random.nextInt(testClasses.length)];

          final shuffledSpecs = List.from(testSpecialites)..shuffle(_random);
          final selectedSpecs = shuffledSpecs.take(4).toList();

          final now = DateTime.now();

          // ✅ CRÉER LE PROSPECT AVEC EMAIL VALIDE
          final prospect = Prospect(
            idProspect: _shortId('prs_', prospectIndex, timestamp),
            idClass: classe.idClasse,
            idfiche: testFiche.idFiche,
            nomComplet: fullName,
            telephone: '6${_random.nextInt(90000000) + 10000000}',
            nomParent: _truncate('test_Parent $firstName'),
            telephoneParent: '6${_random.nextInt(90000000) + 10000000}',
            email: _generateValidEmail(
                firstName, lastName, prospectIndex), // ✅ Email valide
            niveauEtude: _niveauEtudes[_random.nextInt(_niveauEtudes.length)],
            concerne: 'test_Etudiant',
            commentaireGen: _truncate('test_Prospect G${groupIndex + 1}'),
            adresse: _truncate('test_${_random.nextInt(200) + 1} Rue Paris'),
            sexe: _sexeOptions[_random.nextInt(_sexeOptions.length)],
            typeProspect: _typeProspectOptions[
                _random.nextInt(_typeProspectOptions.length)],
            source_infos: testSource.libelleSource,
            date_relance: relanceDate,
            createdAt: now,
            syncState: SyncState.pending,
            prospectStatus: ProspectStatus.relancer,
          );

          // ✅ SAUVEGARDER LE PROSPECT
          await localStorage.saveProspect(prospect);

          // ✅ RÉCUPÉRER LE PROSPECT SAUVEGARDÉ
          final savedProspect =
              await localStorage.getProspectById(prospect.idProspect);
          if (savedProspect == null) {
            continue;
          }

          // ✅ LIER LA CLASSE ET LA FICHE
          savedProspect.classe.value = classe;
          savedProspect.fiche.value = testFiche;
          await isar.writeTxn(() async {
            await savedProspect.classe.save();
            await savedProspect.fiche.save();
          });

          // ✅ CRÉER LES INTÉRÊTS
          for (int j = 0; j < selectedSpecs.length; j++) {
            final spec = selectedSpecs[j];

            final interet = InteretFiliere(
              idInteret: _shortId('int_', prospectIndex * 4 + j, timestamp),
              idProspect: savedProspect.idProspect,
              idSpecialite: spec.idSpecialite,
              ordrePreference: j + 1,
              niveauInteret: _random.nextInt(10) + 1,
              commentaire: _truncate('test_Int #${j + 1}'),
              createdAt: now,
              syncState: SyncState.pending,
            );

            interet.prospect.value = savedProspect;
            interet.specialite.value = spec;

            await localStorage.saveInteret(interet);
            savedProspect.interets.add(interet);
          }

          // ✅ SAUVEGARDER LA LISTE DES INTÉRÊTS
          await isar.writeTxn(() async {
            await savedProspect.interets.save();
          });

          // ✅ PROGRAMMER LA NOTIFICATION
          try {
            await NotificationService.instance.scheduleReminder(
              prospectId: savedProspect.idProspect,
              prospectName: savedProspect.nomComplet,
              date: relanceDate,
              comment: _truncate('test_Relance G${groupIndex + 1}'),
            );
          } catch (e) {
            print("Error: $e");
          }

          totalSaved++;
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> cleanTestData() async {
    try {
      final localStorage = LocalStorage.instance;

      try {
        final testIsar = localStorage.isar;
      } catch (e) {
        await localStorage.init();
      }

      final isar = localStorage.isar;

      // ✅ SUPPRIMER LES SOURCES DE TEST
      final testSources = await isar.sources
          .where()
          .filter()
          .idSourceStartsWith('src_')
          .findAll();

      for (final source in testSources) {
        await isar.writeTxn(() async {
          await isar.sources.delete(source.isarId);
        });
      }

      // ✅ SUPPRIMER LES FICHES DE TEST
      final testFiches = await isar.fiches
          .where()
          .filter()
          .idFicheStartsWith('fch_')
          .findAll();

      for (final fiche in testFiches) {
        await isar.writeTxn(() async {
          await isar.fiches.delete(fiche.isarId);
        });
      }

      // ✅ SUPPRIMER LES ÉTABLISSEMENTS DE TEST
      final testEts = await isar.etablissements
          .where()
          .filter()
          .idEtablissementStartsWith('ets_')
          .findAll();

      for (final ets in testEts) {
        await isar.writeTxn(() async {
          await isar.etablissements.delete(ets.isarId);
        });
      }

      // ✅ SUPPRIMER LES CLASSES DE TEST
      final testClasses = await isar.classes
          .where()
          .filter()
          .idClasseStartsWith('cls_')
          .findAll();

      for (final classe in testClasses) {
        await isar.writeTxn(() async {
          await isar.classes.delete(classe.isarId);
        });
      }

      // ✅ SUPPRIMER LES PROSPECTS DE TEST
      final testProspects = await isar.prospects
          .where()
          .filter()
          .idProspectStartsWith('prs_')
          .findAll();

      for (final prospect in testProspects) {
        await localStorage.deleteProspect(prospect.idProspect);
      }

      // ✅ SUPPRIMER LES INTÉRÊTS DE TEST
      final testInterets = await isar.interetFilieres
          .where()
          .filter()
          .idInteretStartsWith('int_')
          .findAll();

      for (final interet in testInterets) {
        await isar.writeTxn(() async {
          await isar.interetFilieres.delete(interet.isarId);
        });
      }

      // ✅ SUPPRIMER LES SPÉCIALITÉS DE TEST
      final testSpecs = await isar.specialites
          .where()
          .filter()
          .idSpecialiteStartsWith('spc_')
          .findAll();

      for (final spec in testSpecs) {
        await isar.writeTxn(() async {
          await isar.specialites.delete(spec.isarId);
        });
      }

      // ✅ ANNULER TOUTES LES NOTIFICATIONS
      await NotificationService.instance.cancelAll();
    } catch (e) {
      rethrow;
    }
  }
}
