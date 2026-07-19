import 'package:isar_community/isar.dart';
import '../utils/status.dart';
import 'pros.dart';
import 'specialite.dart';

part 'generated/interet_filiere.g.dart';

@collection
class InteretFiliere {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  String idInteret;

  // final String prospectId;

  // final String specialityId;

  @Index() // ← AJOUTEZ CECI
  late String idProspect;

  @Index() // ← AJOUTEZ CECI aussi
  late String idSpecialite;

  @Index()
  int ordrePreference;

  @Index()
  int niveauInteret;

  String? commentaire;

  @Index()
  DateTime createdAt;

  @Index()
  DateTime? updatedAt;

  /// Relation vers Prospect
  final prospect = IsarLink<Prospect>();

  /// Relation vers Specialite
  final specialite = IsarLink<Specialite>();

  @enumerated
  SyncState syncState;
  // SyncState syncState = SyncState.pending;

  InteretFiliere({
    required this.idInteret,
    required this.idProspect, // ← Ajouter
    required this.idSpecialite, // ← Ajouter
    required this.ordrePreference,
    required this.niveauInteret,
    this.commentaire,
    required this.createdAt,
    required this.syncState,
  });

  factory InteretFiliere.fromJson(Map<String, dynamic> json) => InteretFiliere(
        idInteret: json['idInteret'] ?? '',
        ordrePreference: json['ordrePreference'] ?? 0,
        niveauInteret: json['niveauInteret'] ?? 0,
        commentaire: json['commentaire'],
        createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
        idProspect: json['idProspect'] ?? '',
        idSpecialite: json['idSpecialite'] ?? '',
        syncState: json['state'],
      );

  // lib/models/interet_filiere.dart

  /// Pour l'affichage local / UI
  Map<String, dynamic> toLocalJson() => {
        'idInteret': idInteret,
        'idProspect': prospect.value?.idProspect,
        'idSpecialite': idSpecialite,
        'ordrePreference': ordrePreference,
        'niveauInteret': niveauInteret,
        'commentaire': commentaire,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'prospect': prospect.value?.toLocalJson(),
        'specialite': specialite.value?.toLocalJson(),
        'syncState': syncState.name,
      };

  /// Convertit un niveau numérique (1-5) en libellé textuel
  String get niveauInteretLabel {
    switch (niveauInteret) {
      case 1:
        return 'Faible';
      case 2:
        return 'Moyen';
      case 3:
        return 'Élevé';
      case 4:
        return 'Très élevé';
      case 5:
        return 'Excellent';
      default:
        return 'Non spécifié';
    }
  }

  Map<String, dynamic> toJsonApi() => {
        'idInteret': idInteret,
        'idProspect': idProspect,
        'idSpecialite': idSpecialite,
        'ordrePreference': ordrePreference,
        'niveauInteret':
            niveauInteretLabel, // ✅ Envoie le texte (Faible, Moyen, Eleve, Tres eleve, Excellent)
        'commentaire': commentaire,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'syncState': syncState.name,
      };
}
