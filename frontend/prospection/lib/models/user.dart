// // lib/models/user.dart
import 'package:isar_community/isar.dart';

part 'generated/user.g.dart';

@collection
class User {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  String idUtilisateur;

  @Index()
  String nom;
  @Index()
  String prenom;
  @Index()
  String telephone;
  @Index()
  String? email;
  String motDePasse;
  String role; // 'admin', 'agent', 'user'
  bool actif;
  @Index()
  DateTime? createdAt;
  @Index()
  DateTime? updatedAt;

  User({
    required this.idUtilisateur,
    required this.nom,
    required this.prenom,
    required this.telephone,
    this.email,
    required this.motDePasse,
    this.role = 'agent',
    this.actif = true,
    this.createdAt,
    this.updatedAt,
  });

  // ✅ From JSON with safe DateTime parsing
  factory User.fromJson(Map<String, dynamic> json) {
    // Safe date parser
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      if (value is DateTime) return value;
      if (value is String && value.isNotEmpty) {
        try {
          return DateTime.parse(value);
        } catch (e) {
          return null;
        }
      }
      return null;
    }

    return User(
      idUtilisateur: json['idUtilisateur']?.toString() ??
          json['user_id']?.toString() ??
          '',
      nom: json['nom']?.toString() ?? '',
      prenom: json['prenom']?.toString() ?? '',
      telephone:
          json['telephone']?.toString() ?? json['phone']?.toString() ?? '',
      email: json['email']?.toString(),
      motDePasse:
          json['password']?.toString() ?? json['motDePasse']?.toString() ?? '',
      role: json['role']?.toString() ?? 'user',
      actif: json['actif'] ?? json['is_active'] ?? true,
      createdAt:
          parseDate(json['createdAt']) ?? parseDate(json['dateEmbauche']),
      updatedAt: parseDate(json['updatedAt']),
    );
  }

  /// Pour l'affichage local / UI
  Map<String, dynamic> toLocalJson() => {
        'idUtilisateur': idUtilisateur,
        'nom': nom,
        'prenom': prenom,
        'fullName': fullName,
        'initials': initials,
        'telephone': telephone,
        'email': email,
        'role': role,
        'actif': actif,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'isAdmin': isAdmin,
        'isAgent': isAgent,
        'isUser': isUser,
      };

  /// Pour l'API
  Map<String, dynamic> toJsonApi() => {
        'idUtilisateur': idUtilisateur,
        'nom': nom,
        'prenom': prenom,
        'telephone': telephone,
        'email': email,
        'password': motDePasse,
        'role': role,
        'actif': actif,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  @ignore
  // ✅ Safe helper getters with fallbacks
  String get fullName {
    final name = '$prenom $nom'.trim();
    return name.isNotEmpty ? name : 'Utilisateur';
  }
  @ignore
  String get initials {
    // Safe access with fallback
    final first = prenom.isNotEmpty ? prenom[0] : '';
    final last = nom.isNotEmpty ? nom[0] : '';
    final initials = '$first$last'.trim();
    return initials.isNotEmpty ? initials.toUpperCase() : 'A';
  }

  @ignore
  bool get isAdmin => role.toLowerCase() == 'admin';
  @ignore
  bool get isAgent => role.toLowerCase() == 'agent';
  @ignore
  bool get isUser => role.toLowerCase() == 'user';
}
