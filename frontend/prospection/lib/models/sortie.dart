// lib/models/sortie.dart
import 'package:flutter/material.dart';
import 'package:isar_community/isar.dart';
import 'package:isetagcom/models/campaign.dart';
import 'zone.dart';

part 'generated/sortie.g.dart';

@collection
class Sortie {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  String idSortie;

  @Index()
  String idZone;

  @Index()
  String idCampagne;

  String? idEtablissement;

  // Relations
  final zone = IsarLink<Zone>();
  final campagne = IsarLink<Campagne>();

  @Index()
  DateTime dateSortie;

  @Index()
  String statut; // 'en-cours', 'termine', 'annule', 'planifie'

  @Index()
  String typeSortie; // 'Prospection', 'Suivi', 'Visite'

  String objectif;
  String commentaire;

  @Index()
  DateTime createdAt;
  DateTime? updatedAt;

  Sortie({
    required this.idSortie,
    required this.idZone,
    required this.idCampagne,
    this.idEtablissement,
    required this.dateSortie,
    required this.statut,
    required this.typeSortie,
    required this.objectif,
    required this.commentaire,
    required this.createdAt,
    this.updatedAt,
  });

  factory Sortie.fromJson(Map<String, dynamic> json) {
    return Sortie(
      idSortie: json['idSortie'] ?? '',
      idZone: json['idZone'] ?? '',
      idCampagne: json['idCampagne'] ?? '',
      idEtablissement: json['idEtablissement'],
      dateSortie: DateTime.tryParse(json['dateSortie'] ?? '') ?? DateTime.now(),
      statut: json['statut'] ?? '',
      typeSortie: json['typeSortie'] ?? '',
      objectif: json['objectif'] ?? '',
      commentaire: json['commentaire'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idSortie': idSortie,
      'idZone': idZone,
      'idCampagne': idCampagne,
      'idEtablissement': idEtablissement,
      'dateSortie': dateSortie.toIso8601String(),
      'statut': statut,
      'typeSortie': typeSortie,
      'objectif': objectif,
      'commentaire': commentaire,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Helper getters
  @ignore
  String get statutDisplay {
    switch (statut.toLowerCase()) {
      case 'en-cours':
        return 'En cours';
      case 'termine':
        return 'Terminé';
      case 'annule':
        return 'Annulé';
      case 'planifie':
        return 'Planifié';
      default:
        return statut;
    }
  }

  @ignore
  String get typeDisplay {
    switch (typeSortie.toLowerCase()) {
      case 'prospection':
        return 'Prospection';
      case 'suivi':
        return 'Suivi';
      case 'visite':
        return 'Visite';
      default:
        return typeSortie;
    }
  }

  @ignore
  Color get statutColor {
    switch (statut.toLowerCase()) {
      case 'en-cours':
        return Colors.green;
      case 'termine':
        return Colors.blue;
      case 'annule':
        return Colors.red;
      case 'planifie':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @ignore
  bool get isActive => statut.toLowerCase() == 'en-cours';
}
