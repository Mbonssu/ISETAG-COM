import 'package:isar/isar.dart';

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
  final DateTime? createdAt;

  @Backlink(to: 'specialite')
  final interets = IsarLinks<InteretFiliere>();

  Specialite({
    required this.idSpecialite,
    required this.libelleSpecialite,
    this.description,
    this.createdAt,
  });

  factory Specialite.fromJson(Map<String, dynamic> json) => Specialite(
      idSpecialite: json['idSpecialite'] ?? '',
      libelleSpecialite: json['libelleSpecialite'] ?? '',
      description: json['description'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  

  Map<String, dynamic> toLocalJson() {
    return {
      'idSpecialite': idSpecialite,
      'libelleSpecialite': libelleSpecialite,
      'description': description,
      'createdAt': createdAt?.toIso8601String(),
      // 'interets': interets.values.map((i) => i.toJson()).toList(),
    };
  }
}