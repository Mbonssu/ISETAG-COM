// ignore_for_file: non_constant_identifier_names

import 'package:isar_community/isar.dart';
import 'package:isetagcom/models/classe.dart';
import 'package:isetagcom/models/fiche.dart';
import 'package:isetagcom/models/specialite.dart';
import 'package:isetagcom/services/translation_service.dart';
import 'package:isetagcom/utils/status.dart';
import 'interet_filiere.dart';
import 'relance.dart';

part 'generated/pros.g.dart';

@collection
class Prospect {
  Id isarId = Isar.autoIncrement;
  @Index(unique: true)
  String idProspect;

  @Index()
  String idClass;
  @Index()
  String idfiche;
  @Index()
  String nomComplet;
  @Index()
  String telephone;
  @Index()
  String nomParent;
  @Index()
  String telephoneParent;
  @Index()
  String? email;
  @Index()
  String niveauEtude;
  @Index()
  String source_infos;
  String? concerne;
  String? commentaireGen;
  String? adresse;
  String sexe;
  String typeProspect;
  @Index()
  DateTime createdAt;
  @Index()
  DateTime? updatedAt;
  @Index()
  DateTime? date_relance;
  // List<Prospect> allProspects = [];

  @enumerated
  SyncState syncState;

  @enumerated
  ProspectStatus prospectStatus;

  // 1 fiches -> N Prospects
  final fiche = IsarLink<Fiche>();

  // 1 Classe -> N Prospects
  final classe = IsarLink<Classe>();

  /// Relation Isar
  @Backlink(to: 'prospect')
  final interets = IsarLinks<InteretFiliere>();

  @Backlink(to: 'prospect')
  final relances = IsarLinks<Relance>();

  @ignore
  final List<Specialite> AllSpec = [];

  Prospect({
    required this.idProspect,
    required this.nomComplet,
    required this.telephone,
    required this.nomParent,
    required this.telephoneParent,
    required this.idClass,
    required this.idfiche,
    this.email,
    required this.niveauEtude,
    this.concerne,
    this.commentaireGen,
    this.adresse,
    this.date_relance,
    required this.sexe,
    required this.typeProspect,
    required this.createdAt,
    required this.source_infos,
    required this.syncState,
    this.prospectStatus = ProspectStatus.relancer,
    // String? idEtablissement,
    // String? idSource,
  });

  factory Prospect.fromJson(Map<String, dynamic> json) => Prospect(
      idProspect: json['idProspect'] ?? '',
      idClass: json['idClass'],
      idfiche: json['idfiche'] ?? '',
      nomComplet: json['nomComplet'] ?? '',
      telephone: json['telephone'] ?? '',
      nomParent: json['nomParent'] ?? '',
      telephoneParent: json['telephoneParent'] ?? '',
      email: json['email'],
      niveauEtude: json['niveauEtude'],
      concerne: json['concerne'],
      adresse: json['adresse'],
      sexe: json['sexe'],
      typeProspect: json['typeProspect'],
      source_infos: json['sourceInfos'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      syncState: json["sync"]);

  // Map<String, dynamic> toJsonApi() {
  //   return {
  //     'idProspect': idProspect,
  //     'idClass': idClass,
  //     'idfiche': idfiche,
  //     'nomComplet': nomComplet,
  //     'telephone': telephone,
  //     'nomParent': nomParent,
  //     'telephoneParent': telephoneParent,
  //     'email': email,
  //     'niveauEtude': niveauEtude,
  //     'concerne': concerne,
  //     'adresse': adresse,
  //     'sexe': sexe,
  //     "ville": 'ville1',
  //     "codePostal": 'cd1',
  //     "pays": "CMR",
  //     "domaineEtude": 'domaine',
  //     'typeProspect': typeProspect,
  //     'source_infos': source_infos,
  //     'createdAt': createdAt.toIso8601String(),
  //     'syncState': syncState.name,
  //   };
  // }

  // // Map<String, dynamic> toLocalJson() {
  // //   return {
  // //     'idProspect': idProspect,
  // //     'nomComplet': nomComplet,
  // //     'telephone': telephone,
  // //     'email': email,
  // //     'niveauEtude': niveauEtude,
  // //     'concerne': concerne,
  // //     'adresse': adresse,
  // //     'sexe': sexe,
  // //     'typeProspect': typeProspect,
  // //     'createdAt': createdAt.toIso8601String(),
  // //     'idClass': idClass,
  // //     'idfiche': idfiche,
  // //     'syncState': syncState.name,
  // //     // 'interets': interets.map((e) => e.toJson()).toList(),
  // //   };
  // // }

  // Map<String, dynamic> toLocalJson() {
  //   return {
  //     'idProspect': idProspect,
  //     'idClass': idClass,
  //     'idfiche': idfiche,
  //     'nomComplet': nomComplet,
  //     'telephone': telephone,
  //     'nomParent': nomParent,
  //     'telephoneParent': telephoneParent,
  //     'email': email,
  //     'niveauEtude': niveauEtude,
  //     'adresse': adresse,
  //     'date_relance': date_relance,
  //     'sexe': sexe,
  //     'typeProspect': typeProspect,
  //     'commentaire': commentaireGen,
  //     'createdAt': createdAt.toIso8601String(),
  //     'syncState': syncState.name,
  //     'pros_state': prospectStatus.name,
  //     'chosenSpec': AllSpec.map((cs) => cs.toLocalJson()).toList(),
  //     // 'interets': interets.map((interet) => interet.toLocalJson()).toList(),
  //   };
  // }

// lib/models/pros.dart

  /// Pour l'affichage local / UI
  Map<String, dynamic> toLocalJson() => {
        'idProspect': idProspect,
        'idClass': idClass,
        'idFiche': idfiche,
        'nomComplet': nomComplet,
        'telephone': telephone,
        'nomParent': nomParent,
        'telephoneParent': telephoneParent,
        'email': email,
        'niveauEtude': niveauEtude,
        'concerne': concerne,
        'commentaireGen': commentaireGen,
        'adresse': adresse,
        'sexe': sexe,
        'typeProspect': typeProspect,
        'source_infos': source_infos,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'date_relance': date_relance?.toIso8601String(),
        'prospectStatus': prospectStatus.name,
        'syncState': syncState.name,
        'classe': classe.value?.toLocalJson(),
        'fiche': fiche.value?.toLocalJson(),
        'interets': interets.map((i) => i.toLocalJson()).toList(),
      };

  /// Pour l'API
  Map<String, dynamic> toJsonApi() => {
        'idProspect': idProspect,
        // 'idClass': idClass,
        'idFiche': idfiche,
        'nomComplet': nomComplet,
        'telephone': telephone,
        'domaineEtude': classe.value?.libelleClasse.tr,
        // 'Ets': classe.value?.ets.value?.nomEtablissement,
        'nomParent': nomParent,
        'numeroParent': telephoneParent,
        'email': email,
        'niveauEtude': niveauEtude,
        'concerne': concerne,
        'commentaireGen': commentaireGen,
        'adresse': adresse,
        'sexe': sexe,
        'typeProspect': typeProspect,
        // 'source_infos': source_infos,
        'createdAt': createdAt.toIso8601String(),
        // 'updatedAt': updatedAt?.toIso8601String(),
        'date_relance': date_relance?.toIso8601String(),

        // "idProspect": "string",
        // "nomComplet": "string",
        // "email": "string",
        // "telephone": "string",
        // "adresse": "string",
        // "ville": "string",
        // "codePostal": "string",
        // "pays": "string",
        // "sexe": "string",
        // "dateNaissance": "2026-07-21",
        // "niveauEtude": "string",
        // "domaineEtude": "string",
        // "typeProspect": "string",
        // "nomParent": "string",
        // "numeroParent": "string",
        // "idFiche": "string"
        // 'prospectStatus': prospectStatus.name,
        // 'syncState': syncState.name,
      };
  // Prospect copyWith({
  //   String? idProspect,
  //   String? nomComplet,
  //   String? telephone,
  //   String? email,
  //   String? niveauEtude,
  //   String? concerne,
  //   String? adresse,
  //   String? sexe,
  //   String? typeProspect,
  //   DateTime? createdAt,
  //   SyncState? syncState,
  // }) {
  //   return Prospect(
  //     idProspect: idProspect ?? this.idProspect,
  //     idClass: idClass,
  //     idfiche: idfiche,
  //     nomComplet: nomComplet ?? this.nomComplet,
  //     telephone: telephone ?? this.telephone,
  //     email: email ?? this.email,
  //     niveauEtude: niveauEtude ?? this.niveauEtude,
  //     concerne: concerne ?? this.concerne,
  //     adresse: adresse ?? this.adresse,
  //     sexe: sexe ?? this.sexe,
  //     typeProspect: typeProspect ?? this.typeProspect,
  //     createdAt: createdAt ?? this.createdAt,
  //     syncState: syncState ?? this.syncState,
  //   );
  // }
}
