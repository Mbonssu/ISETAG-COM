import 'package:isar/isar.dart';
import '../utils/status.dart';
import 'pros.dart';
import 'specialite.dart';

part 'generated/interet_filiere.g.dart';

@collection
class InteretFiliere {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  final String idInteret;

  // final String prospectId;

  // final String specialityId;

  @Index() // ← AJOUTEZ CECI
  late String idProspect;

  @Index() // ← AJOUTEZ CECI aussi
  late String idSpecialite;

  @Index()
  final int ordrePreference;

  @Index()
  final int niveauInteret;

  final String? commentaire;

  @Index()
  final DateTime createdAt;

  /// Relation vers Prospect
  final prospect = IsarLink<Prospect>();

  /// Relation vers Specialite
  final specialite = IsarLink<Specialite>();

  @enumerated
  SyncState syncState = SyncState.pending;

  InteretFiliere({
    required this.idInteret,
    required this.idProspect, // ← Ajouter
    required this.idSpecialite, // ← Ajouter
    required this.ordrePreference,
    required this.niveauInteret,
    this.commentaire,
    required this.createdAt,
  });

  factory InteretFiliere.fromJson(Map<String, dynamic> json) => InteretFiliere(
        idInteret: json['idInteret'] ?? '',
        ordrePreference: json['ordrePreference'] ?? 0,
        niveauInteret: json['niveauInteret'] ?? 0,
        commentaire: json['commentaire'],
        createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
        idProspect: json['idProspect'] ?? '',
        idSpecialite: json['idSpecialite'] ?? '',
      );

  /// Local UI
  Map<String, dynamic> toLocalJson() {
    return {
      'idInteret': idInteret,
      'idProspect': idProspect,
      'idSpecialite': idSpecialite,
      'ordrePreference': ordrePreference,
      'niveauInteret': niveauInteret,
      'commentaire': commentaire,
      'createdAt': createdAt.toIso8601String(),
      'prospect': prospect.value?.toLocalJson(),
      'specialite': specialite.value?.toLocalJson(),
    };
  }

  /// API
  Map<String, dynamic> toApiJson() {
    return {
      'idInteret': idInteret,
      'idProspect': idProspect,
      'idSpecialite': idSpecialite,
      'idProspect_isar': prospect.value?.idProspect,
      'idSpecialite_isar': specialite.value?.idSpecialite,
      'ordrePreference': ordrePreference,
      'niveauInteret': niveauInteret,
      'commentaire': commentaire,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
