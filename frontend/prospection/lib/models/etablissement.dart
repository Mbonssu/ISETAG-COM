import 'package:isar/isar.dart';
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

  Etablissement({
    required this.idEtablissement,
    required this.nomEtablissement,
    this.typeEtablissement,
    this.adresse,
    this.telephone,
    this.ville,
    this.region,
    this.createdAt,
    required this.syncState
  });

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
            syncState: json["sync"]
      );

  /// Local/UI display
  Map<String, dynamic> toJson() {
    return {
      'idEtablissement': idEtablissement,
      'nomEtablissement': nomEtablissement,
      'typeEtablissement': typeEtablissement,
      'adresse': adresse,
      'telephone': telephone,
      'ville': ville,
      'region': region,
      'createdAt': createdAt,
      'classes': classes.map((e) => e.toJson()).toList(),
    };
  }

  /// API payload
  Map<String, dynamic> toJsonApi() {
    return {
      'idEtablissement': idEtablissement,
      'nomEtablissement': nomEtablissement,
      'typeEtablissement': typeEtablissement,
      'adresse': adresse,
      'telephone': telephone,
      'ville': ville,
      'region': region,
      'createdAt': createdAt?.toIso8601String(),

      // Send only IDs
      'classes': classes.map((e) => e.idClasse).toList(),
      "syncState": syncState.name
    };
  }
}
