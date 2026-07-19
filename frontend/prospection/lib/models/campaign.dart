// lib/models/campagne.dart
import 'package:isar_community/isar.dart';

part 'generated/campaign.g.dart';

@collection
class Campagne {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  String idCampagne;

  @Index()
  String libele;
  String description;
  DateTime dateDebut;
  DateTime dateFin;
  String objectif;
  String type;

  @Index()
  DateTime createdAt;
  DateTime? updatedAt;

  Campagne({
    required this.idCampagne,
    required this.libele,
    required this.description,
    required this.dateDebut,
    required this.dateFin,
    required this.objectif,
    required this.type,
    required this.createdAt,
    this.updatedAt,
  });

  factory Campagne.fromJson(Map<String, dynamic> json) {
    return Campagne(
      idCampagne: json['idCampagne'] ?? '',
      libele: json['libele'] ?? '',
      description: json['description'] ?? '',
      dateDebut: DateTime.tryParse(json['dateDebut'] ?? '') ?? DateTime.now(),
      dateFin: DateTime.tryParse(json['dateFin'] ?? '') ?? DateTime.now(),
      objectif: json['objectif'] ?? '',
      type: json['type'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idCampagne': idCampagne,
      'libele': libele,
      'description': description,
      'dateDebut': dateDebut.toIso8601String(),
      'dateFin': dateFin.toIso8601String(),
      'objectif': objectif,
      'type': type,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
