import 'package:isar_community/isar.dart';
import '../provider/auth_provider.dart';
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

  // final authProvider = AuthProvider();
  // print("Participation id: ${await authProvider.getCachedParticipationId()

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

  /// Pour l'affichage local / UI
  Map<String, dynamic> toLocalJson() => {
        'idFiche': idFiche,
        'idSrc': idSrc,
        'dateCollecte': dateCollecte.toIso8601String(),
        'commentaire': commentaire,
        'scoreInteret': scoreInteret,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'isCurrent': isCurrent,
        'source': source.value?.toLocalJson(),
        'prospects': prospects.map((p) => p.toLocalJson()).toList(),
        'syncState': syncState.name,
      };

  @ignore
  Future<String?> get participationId async {
    try {
      final authProvider = AuthProvider();
      print(
          "Participation id: ${await authProvider.getCachedParticipationId()}");
      return await authProvider.getCachedParticipationId();
    } catch (e) {
      print('❌ Error getting participation ID from AuthProvider: $e');
      return null;
    }
  }

  /// Pour l'API
  Future<Map<String, dynamic>> toJsonApi() async {
    return {
      'idFiche': idFiche,
      'idParticipation': await participationId,
      'idSource': idSrc,
      'dateCollecte': dateCollecte.toIso8601String(),
      'commentaire': commentaire,
      'scoreInteret': scoreInteret,
      'createdAt': createdAt.toIso8601String(),
      // 'updatedAt': updatedAt?.toIso8601String(),
      // 'isCurrent': isCurrent,
      // 'syncState': syncState.name,
    };
  }
}
