// lib/models/zone.dart
import 'package:isar_community/isar.dart';

part 'generated/zone.g.dart';

@collection
class Zone {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  String idZone;

  @Index()
  String libele;
  String description;
  String quartier;
  String ville;
  String pays;
  String region;
  String lieuDepart;
  String lieuArrivee;

  @Index()
  DateTime createdAt;
  DateTime? updatedAt;

  Zone({
    required this.idZone,
    required this.libele,
    required this.description,
    required this.quartier,
    required this.ville,
    required this.pays,
    required this.region,
    required this.lieuDepart,
    required this.lieuArrivee,
    required this.createdAt,
    this.updatedAt,
  });

  factory Zone.fromJson(Map<String, dynamic> json) {
    return Zone(
      idZone: json['idZone'] ?? '',
      libele: json['libele'] ?? '',
      description: json['description'] ?? '',
      quartier: json['quartier'] ?? '',
      ville: json['ville'] ?? '',
      pays: json['pays'] ?? '',
      region: json['region'] ?? '',
      lieuDepart: json['lieuDepart'] ?? '',
      lieuArrivee: json['lieuArrivee'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idZone': idZone,
      'libele': libele,
      'description': description,
      'quartier': quartier,
      'ville': ville,
      'pays': pays,
      'region': region,
      'lieuDepart': lieuDepart,
      'lieuArrivee': lieuArrivee,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Helper getters
  @ignore
  String get fullAddress => '$quartier, $ville, $pays';
  @ignore
  String get route => '$lieuDepart → $lieuArrivee';
}
