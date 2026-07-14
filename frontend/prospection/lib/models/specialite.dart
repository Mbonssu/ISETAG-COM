import 'package:isar/isar.dart';

import '../utils/status.dart';
import 'interet_filiere.dart';

part 'generated/specialite.g.dart';

@collection
class Specialite {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  final String idSpecialite;

  @Index()
  final String libelleSpecialite;
  final String? description;
  @Index()
  final DateTime? createdAt;
  @Index()
  DateTime? updatedAt;

  @Backlink(to: 'specialite')
  final interets = IsarLinks<InteretFiliere>();

  @enumerated
  SyncState syncState;

  Specialite({
    required this.idSpecialite,
    required this.libelleSpecialite,
    this.description,
    this.createdAt,
    required this.syncState,
  });

  factory Specialite.fromJson(Map<String, dynamic> json) => Specialite(
        idSpecialite: json['idSpecialite'] ?? '',
        libelleSpecialite: json['libelleSpecialite'] ?? '',
        description: json['description'],
        createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
        syncState: json["sync"],
      );

  Map<String, dynamic> toLocalJson() {
    return {
      'idSpecialite': idSpecialite,
      'libeleSpecialite': libelleSpecialite,
      'description': description,
      'createdAt': createdAt?.toIso8601String(),
      'syncState': syncState.name
      // 'interets': interets.values.map((i) => i.toJson()).toList(),
    };
  }
}
