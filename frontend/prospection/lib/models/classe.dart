import 'package:isar/isar.dart';
import 'package:isetagcom/models/etablissement.dart';
import 'package:isetagcom/utils/status.dart';

import 'pros.dart';
part 'generated/classe.g.dart';

@collection
class Classe {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  String idClasse;

  @Index() // ← AJOUTEZ CECI pour pouvoir filtrer par idClasse
  String idEts;

  @Index()
  String libelleClasse;
  DateTime? createdAt;

  // 1 ets -> N Classes
  final ets = IsarLink<Etablissement>();

  @Backlink(to: 'classe')
  final prospects = IsarLinks<Prospect>();

  @enumerated
  SyncState syncState = SyncState.pending;

  Classe({
    required this.idClasse,
    required this.idEts,
    required this.libelleClasse,
    this.createdAt,
  });

  factory Classe.fromJson(Map<String, dynamic> json) => Classe(
        idClasse: json['idClasse'],
        idEts: json['idEts'],
        libelleClasse: json['libelleClasse'] ?? '',
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : null,
      );

  /// For UI / local display
  Map<String, dynamic> toJson() {
    return {
      'idClasse': idClasse,
      'idEts': idEts,
      'libelleClasse': libelleClasse,
      'createdAt': createdAt,
    };
  }

  /// For API
  Map<String, dynamic> toJsonApi() {
    return {
      'idClasse': idClasse,
      'idEts': idEts,
      'libelleClasse': libelleClasse,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
