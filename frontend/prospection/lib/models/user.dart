// /// Modèle de données pour un utilisateur
// class User {
//   final String id;
//   final String email;
//   final String fullName;
//   final String? profilePicture;
//   final DateTime createdAt;
//   final bool isActive;

//   const User({
//     required this.id,
//     required this.email,
//     required this.fullName,
//     this.profilePicture,
//     required this.createdAt,
//     this.isActive = true,
//   });

//   /// Factory constructor pour créer un utilisateur depuis JSON
//   factory User.fromJson(Map<String, dynamic> json) => User(
//       id: json['id'],
//       email: json['email'],
//       fullName: json['fullName'],
//       profilePicture: json['profilePicture'],
//       createdAt: DateTime.parse(json['createdAt']),
//       isActive: json['isActive'] ?? true,
//     );

//   /// Convertir l'utilisateur en JSON
//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'email': email,
//     'fullName': fullName,
//     'profilePicture': profilePicture,
//     'createdAt': createdAt.toIso8601String(),
//     'isActive': isActive,
//   };

//   /// Copier avec des modifications
//   User copyWith({
//     String? id,
//     String? email,
//     String? fullName,
//     String? profilePicture,
//     DateTime? createdAt,
//     bool? isActive,
//   }) {
//     return User(
//       id: id ?? this.id,
//       email: email ?? this.email,
//       fullName: fullName ?? this.fullName,
//       profilePicture: profilePicture ?? this.profilePicture,
//       createdAt: createdAt ?? this.createdAt,
//       isActive: isActive ?? this.isActive,
//     );
//   }
// }
// lib/models/user.dart
import 'package:isar/isar.dart';

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
    this.role = 'user',
    this.actif = true,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        idUtilisateur: json['idUtilisateur'] ?? '',
        nom: json['nom'] ?? '',
        prenom: json['prenom'] ?? '',
        telephone: json['telephone'] ?? '',
        email: json['email'],
        motDePasse: json['motDePasse'] ?? '',
        role: json['role'] ?? 'user',
        actif: json['actif'] ?? true,
        createdAt: json['createdAt'] ?? DateTime.now().toIso8601String(),
      );

  Map<String, dynamic> toJson() {
    return {
      'idUtilisateur': idUtilisateur,
      'nom': nom,
      'prenom': prenom,
      'telephone': telephone,
      'email': email,
      'motDePasse': motDePasse,
      'role': role,
      'actif': actif,
      'createdAt': createdAt,
    };
  }

  // Helper getters
  String get fullName => '$prenom $nom';
  String get initials => '${prenom[0]}${nom[0]}'.toUpperCase();
  bool get isAdmin => role.toLowerCase() == 'admin';
  bool get isAgent => role.toLowerCase() == 'agent';
  bool get isUser => role.toLowerCase() == 'user';
}
