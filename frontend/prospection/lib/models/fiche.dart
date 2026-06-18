import 'package:isar/isar.dart';
import '../utils/status.dart';
import 'pros.dart';
import 'source.dart';

part 'generated/fiche.g.dart';

@collection
class Fiche {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  String idFiche;

  @Index()
  String idSrc;

  @Index()
  DateTime dateCollecte;
  String? commentaire;
  int? scoreInteret;

  @Index()
  DateTime createdAt;
  bool isCurrent;

  @Index()
  DateTime? updatedAt;
  // Relation 1 Source -> N fiches
  // @Backlink(to: '')
  final source = IsarLink<Source>();

  // relation bidirectionnelle avec Prospect
  @Backlink(to: 'fiche')
  final prospects = IsarLinks<Prospect>();

  @enumerated
  SyncState syncState;

  Fiche(
      {required this.idFiche,
      required this.idSrc,
      required this.dateCollecte,
      this.commentaire,
      this.scoreInteret,
      required this.createdAt,
      required this.isCurrent,
      required this.syncState});

  factory Fiche.fromJson(Map<String, dynamic> json) {
    final fiche = Fiche(
        idFiche: json['idFiche'] ?? '',
        idSrc: json['idSource'] ?? '',
        dateCollecte:
            DateTime.tryParse(json['dateCollecte'] ?? '') ?? DateTime.now(),
        commentaire: json['commentaire'],
        scoreInteret: json['scoreInteret'] ?? 0,
        createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
        isCurrent: json['isCurrent'] ?? false,
        syncState: json["sync"]);

    fiche.source.value = Source.fromJson(json['source'] ?? {});

    return fiche;
  }

  Map<String, dynamic> toLocalJson() => {
        'idFiche': idFiche,
        'dateCollecte': dateCollecte.toIso8601String(),
        'commentaire': commentaire,
        'scoreInteret': scoreInteret,
        'createdAt': createdAt.toIso8601String(),
        'isCurrent': isCurrent,

        // Source linked to the fiche
        'source': source.value?.toLocalJson(),

        // Prospects linked to the fiche
        'prospects': prospects.map((p) => p.toLocalJson()).toList(),
      };

  Map<String, dynamic> toJsonApi() => {
        'idFiche': idFiche,
        'dateCollecte': dateCollecte.toIso8601String(),
        'commentaire': commentaire,
        'scoreInteret': scoreInteret,
        'createdAt': createdAt.toIso8601String(),
        'isCurrent': isCurrent,
      };
}
