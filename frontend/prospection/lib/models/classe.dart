import 'package:isar_community/isar.dart';
import 'package:isetagcom/utils/status.dart';

import 'pros.dart';
part 'generated/classe.g.dart';

/// Classe est indépendante de l'Établissement (aucune liaison requise,
/// conformément à la doc API : il n'existe pas d'endpoint /classe côté API,
/// la classe reste un référentiel local libre).
@collection
class Classe {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  String idClasse;

  /// Optionnel : conservé uniquement pour compatibilité locale, n'impose
  /// plus aucune contrainte avec Etablissement.
  @Index()
  String idEts;

  @Index()
  String libelleClasse;
  @Index()
  DateTime? createdAt;
  @Index()
  DateTime? updatedAt;

  // 1 ets -> N Classes
  // final ets = IsarLink<Etablissement>();

  @Backlink(to: 'classe')
  final prospects = IsarLinks<Prospect>();

  @enumerated
  SyncState syncState;

  Classe(
      {required this.idClasse,
      this.idEts = '',
      required this.libelleClasse,
      this.createdAt,
      required this.syncState});

  factory Classe.fromJson(Map<String, dynamic> json) => Classe(
      idClasse: json['idClasse'],
      idEts: json['idEts'] ?? '',
      libelleClasse: json['libelleClasse'] ?? '',
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      syncState: json["sync"]);

  // lib/models/classe.dart

  /// Pour l'affichage local / UI
  Map<String, dynamic> toLocalJson() => {
        'idClasse': idClasse,
        'idEts': idEts,
        'libelleClasse': libelleClasse,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        // 'ets': ets.value?.toLocalJson(),
        'prospects': prospects.map((p) => p.toLocalJson()).toList(),
        'syncState': syncState.name,
      };

  /// Pour l'API
  Map<String, dynamic> toJsonApi() => {
        'idClasse': idClasse,
        'idEts': idEts,
        'libelleClasse': libelleClasse,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'syncState': syncState.name,
      };
}
