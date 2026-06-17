import 'package:isar/isar.dart';
import 'package:isetagcom/models/classe.dart';
import 'package:isetagcom/models/fiche.dart';
import 'package:isetagcom/models/specialite.dart';
import 'package:isetagcom/utils/status.dart';
import 'interet_filiere.dart';

part 'generated/pros.g.dart';

@collection
class Prospect {
  Id isarId = Isar.autoIncrement;
  @Index(unique: true)
  final String idProspect;

  @Index()
  final String idClass;
  @Index()
  final String idfiche;
  final String nomComplet;
  final String telephone;
  final String? email;
  final String niveauEtude;
  final String? concerne;
  final String? commentaireGen;
  final String? adresse;
  final String sexe;
  final String typeProspect;
  final DateTime createdAt;
  DateTime? date_relance;
  // List<Prospect> allProspects = [];

  @enumerated
  SyncState syncState = SyncState.pending;

  @enumerated
  ProspectStatus prospectStatus;

  // 1 fiches -> N Prospects
  final fiche = IsarLink<Fiche>();

  // 1 Classe -> N Prospects
  final classe = IsarLink<Classe>();

  /// Relation Isar
  @Backlink(to: 'prospect')
  final interets = IsarLinks<InteretFiliere>();

  @ignore
  final List<Specialite> AllSpec = [];

  Prospect({
    required this.idProspect,
    required this.nomComplet,
    required this.telephone,
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
    this.syncState = SyncState.pending,
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
        email: json['email'],
        niveauEtude: json['niveauEtude'],
        concerne: json['concerne'],
        adresse: json['adresse'],
        sexe: json['sexe'],
        typeProspect: json['typeProspect'],
        createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      );

  Map<String, dynamic> toJsonApi() {
    return {
      'idProspect': idProspect,
      'idClass': idClass,
      'idfiche': idfiche,
      'nomComplet': nomComplet,
      'telephone': telephone,
      'email': email,
      'niveauEtude': niveauEtude,
      'concerne': concerne,
      'adresse': adresse,
      'sexe': sexe,
      'typeProspect': typeProspect,
      'createdAt': createdAt.toIso8601String(),
      // 'syncState': syncState.name,
      // 'interets': interets.map((e) => e.toJson()).toList(),
    };
  }

  // Map<String, dynamic> toLocalJson() {
  //   return {
  //     'idProspect': idProspect,
  //     'nomComplet': nomComplet,
  //     'telephone': telephone,
  //     'email': email,
  //     'niveauEtude': niveauEtude,
  //     'concerne': concerne,
  //     'adresse': adresse,
  //     'sexe': sexe,
  //     'typeProspect': typeProspect,
  //     'createdAt': createdAt.toIso8601String(),
  //     'idClass': idClass,
  //     'idfiche': idfiche,
  //     'syncState': syncState.name,
  //     // 'interets': interets.map((e) => e.toJson()).toList(),
  //   };
  // }

  Map<String, dynamic> toLocalJson() {
    return {
      'idProspect': idProspect,
      'idClass': idClass,
      'idfiche': idfiche,
      'nomComplet': nomComplet,
      'telephone': telephone,
      'email': email,
      'niveauEtude': niveauEtude,
      'adresse': adresse,
      'date_relance': date_relance,
      'sexe': sexe,
      'typeProspect': typeProspect,
      'commentaire': commentaireGen,
      'createdAt': createdAt.toIso8601String(),
      'syncState': syncState.name,
      'pros_state': prospectStatus.name,
      'chosenSpec': AllSpec.map((cs) => cs.toLocalJson()).toList(),
      // 'interets': interets.map((interet) => interet.toLocalJson()).toList(),
    };
  }

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
