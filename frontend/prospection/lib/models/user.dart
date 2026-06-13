/// Modèle de données pour un utilisateur
class User {
  final String id;
  final String email;
  final String fullName;
  final String? profilePicture;
  final DateTime createdAt;
  final bool isActive;

  const User({
    required this.id,
    required this.email,
    required this.fullName,
    this.profilePicture,
    required this.createdAt,
    this.isActive = true,
  });

  /// Factory constructor pour créer un utilisateur depuis JSON
  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json['id'],
      email: json['email'],
      fullName: json['fullName'],
      profilePicture: json['profilePicture'],
      createdAt: DateTime.parse(json['createdAt']),
      isActive: json['isActive'] ?? true,
    );
  

  /// Convertir l'utilisateur en JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'fullName': fullName,
    'profilePicture': profilePicture,
    'createdAt': createdAt.toIso8601String(),
    'isActive': isActive,
  };

  /// Copier avec des modifications
  User copyWith({
    String? id,
    String? email,
    String? fullName,
    String? profilePicture,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      profilePicture: profilePicture ?? this.profilePicture,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
