import 'package:isar_community/isar.dart';
import 'package:isetagcom/services/translation_service.dart';

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

  // Map<String, dynamic> toLocalJson() {
  //   return {
  //     'idSpecialite': idSpecialite,
  //     'libeleSpecialite': libelleSpecialite,
  //     'description': description,
  //     'createdAt': createdAt?.toIso8601String(),
  //     'syncState': syncState.name
  //     // 'interets': interets.values.map((i) => i.toJson()).toList(),
  //   };
  // }

  // lib/models/specialite.dart

  /// Pour l'affichage local / UI
  Map<String, dynamic> toLocalJson() => {
        'idSpecialite': idSpecialite,
        'libelleSpecialite': libelleSpecialite.tr,
        'description': "nope".tr,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'interets': interets.map((i) => i.toLocalJson()).toList(),
        'syncState': syncState.name,
      };

  /// Pour l'API
  Map<String, dynamic> toJsonApi() => {
        'idSpecialite': idSpecialite,
        'libeleSpecialite': libelleSpecialite.tr,
        'description': description,
        "acronyme": generateAcronym(libelleSpecialite),
        // 'createdAt': createdAt?.toIso8601String(),
        // 'updatedAt': updatedAt?.toIso8601String(),
        // 'interetsIds': interets.map((i) => i.idInteret).toList(),
        'syncState': syncState.name,
      };

  /// Génère un acronyme à partir d'une chaîne de caractères
  ///
  /// Règles :
  /// - Prend la première lettre de chaque mot
  /// - Ignore les mots vides (le, la, les, de, des, etc.)
  /// - Limite à 5 caractères maximum
  ///
  /// Exemples :
  /// - "Construction Mecanique" → "CM"
  /// - "Informatique de Gestion" → "IG"
  /// - "Sciences et Techniques" → "ST"
  /// - "Génie Logiciel" → "GL"
  /// - "Maintenance des Systèmes" → "MS"
  @ignore
  static String generateAcronym(String input, {int maxLength = 5}) {
    if (input.isEmpty) return '';

    // Nettoyer la chaîne (enlever les accents, caractères spéciaux)
    final cleanInput = _cleanString(input);

    // Liste des mots à ignorer (stopwords)
    const stopwords = [
      'de',
      'des',
      'du',
      'la',
      'le',
      'les',
      'et',
      'ou',
      'ou',
      'aux',
      'pour',
      'avec',
      'sans',
      'dans',
      'par'
    ];

    // Séparer en mots
    final words = cleanInput
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();

    if (words.isEmpty) return '';

    // Si un seul mot, prendre les 3 premières lettres
    if (words.length == 1) {
      return words.first
          .substring(0, words.first.length > 3 ? 3 : words.first.length)
          .toUpperCase();
    }

    // Sinon, prendre la première lettre de chaque mot (sauf stopwords)

    String acronym = '';
    for (final word in words) {
      // Ignorer les stopwords
      if (stopwords.contains(word.toLowerCase())) continue;
      if (acronym.length >= maxLength) break;
      acronym += word.substring(0, 1).toUpperCase();
    }

    // Si l'acronyme est vide (tous les mots étaient des stopwords), prendre la première lettre du premier mot
    if (acronym.isEmpty && words.isNotEmpty) {
      acronym = words.first.substring(0, 1).toUpperCase();
    }

    return acronym;
  }

  /// Nettoie une chaîne : supprime les accents, caractères spéciaux, etc.
  static String _cleanString(String input) {
    // Supprimer les accents
    final accents = {
      'à': 'a',
      'â': 'a',
      'ä': 'a',
      'á': 'a',
      'ã': 'a',
      'å': 'a',
      'è': 'e',
      'ê': 'e',
      'ë': 'e',
      'é': 'e',
      // 'è': 'e',
      'ì': 'i',
      'î': 'i',
      'ï': 'i',
      'í': 'i',
      'ò': 'o',
      'ô': 'o',
      'ö': 'o',
      'ó': 'o',
      'õ': 'o',
      'ø': 'o',
      'ù': 'u',
      'û': 'u',
      'ü': 'u',
      'ú': 'u',
      'ç': 'c',
      'ñ': 'n',
    };

    String result = input;
    for (final entry in accents.entries) {
      result = result.replaceAll(entry.key, entry.value);
    }

    // Enlever les caractères spéciaux (garder lettres, chiffres et espaces)
    result = result.replaceAll(RegExp(r'[^a-zA-Z0-9\s\-]'), '');

    // Enlever les tirets et underscores
    result = result.replaceAll(RegExp(r'[-_]'), ' ');

    return result;
  }
}
