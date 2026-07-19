import 'package:isar_community/isar.dart';
import '../utils/status.dart';
import 'classe.dart';

part 'generated/etablissement.g.dart';

@collection
class Etablissement {
  /// Local Isar ID
  Id isarId = Isar.autoIncrement;

  /// Server ID
  @Index(unique: true)
  String idEtablissement;

  @Index()
  String nomEtablissement;
  String? typeEtablissement;
  String? adresse;
  String? telephone;

  // @Index()
  String? ville;
  String? region;
  @Index()
  DateTime? createdAt;
  @Index()
  DateTime? updatedAt;

  /// Relationship
  @Backlink(to: 'ets')
  final classes = IsarLinks<Classe>();

  @enumerated
  SyncState syncState;

  Etablissement(
      {required this.idEtablissement,
      required this.nomEtablissement,
      this.typeEtablissement,
      this.adresse,
      this.telephone,
      this.ville,
      this.region,
      this.createdAt,
      required this.syncState});

  factory Etablissement.fromJson(Map<String, dynamic> json) => Etablissement(
      idEtablissement: json['idEtablissement'],
      nomEtablissement: json['nomEtablissement'] ?? '',
      typeEtablissement: json['typeEtablissement'],
      adresse: json['adresse'],
      telephone: json['telephone'],
      ville: json['ville'],
      region: json['region'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      syncState: json["sync"]);

  /// Pour l'affichage local / UI
  Map<String, dynamic> toLocalJson() => {
        'idEtablissement': idEtablissement,
        'nomEtablissement': nomEtablissement,
        'typeEtablissement': typeEtablissement,
        'adresse': adresse,
        'telephone': telephone,
        'ville': ville,
        'region': region,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'classes': classes.map((c) => c.toLocalJson()).toList(),
        'syncState': syncState.name,
      };

  /// Pour l'API
  Map<String, dynamic> toJsonApi() => {
        'idEtablissement': idEtablissement,
        'nom': nomEtablissement,
        'type': typeEtablissement,
        // 'adresse': adresse,
        // 'telephone': telephone,
        // 'ville': ville,
        // 'region': region,

        'adresse': "adresse",
        'telephone': "telephone",
        'ville': "ville",
        'region': "region",

        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        // 'classesIds': classes.map((c) => c.idClasse).toList(),
        'syncState': syncState.name,
      };
}
