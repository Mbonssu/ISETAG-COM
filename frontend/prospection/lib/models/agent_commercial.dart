// lib/models/agent_commercial.dart
import 'package:isar/isar.dart';
import 'user.dart';

part 'generated/agent_commercial.g.dart';

@collection
class AgentCommercial {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  String idAgent;

  @Index()
  String idUtilisateur; // Reference to User

  @Index()
  String matriculeAgent;
  @Index()
  DateTime dateEmbauche;
  String statut; // Actif, En congé, Arrêté

  // Link to the User (Isar relationship)
  final user = IsarLink<User>();

  AgentCommercial({
    required this.idAgent,
    required this.idUtilisateur,
    required this.matriculeAgent,
    required this.dateEmbauche,
    this.statut = 'Actif',
  });

  factory AgentCommercial.fromJson(Map<String, dynamic> json) =>
      AgentCommercial(
        idAgent: json['idAgent'] ?? '',
        idUtilisateur: json['idUtilisateur'] ?? '',
        matriculeAgent: json['matriculeAgent'] ?? '',
        dateEmbauche:
            DateTime.tryParse(json['dateEmbauche'] ?? '') ?? DateTime.now(),
        statut: json['statut'] ?? 'Actif',
      );

  Map<String, dynamic> toJson() {
    return {
      'idAgent': idAgent,
      'idUtilisateur': idUtilisateur,
      'matriculeAgent': matriculeAgent,
      'dateEmbauche': dateEmbauche.toIso8601String(),
      'statut': statut,
    };
  }

  // Helper getters to access user data
  String get fullName => user.value?.fullName ?? '';
  String get initials => user.value?.initials ?? '';
  String get nom => user.value?.nom ?? '';
  String get prenom => user.value?.prenom ?? '';
  String get telephone => user.value?.telephone ?? '';
  String? get email => user.value?.email;
  String get motDePasse => user.value?.motDePasse ?? '';
  String get role => user.value?.role ?? '';
  bool get isAdmin => user.value?.isAdmin ?? false;
  bool get isAgent => user.value?.isAgent ?? false;
  bool get isUser => user.value?.isUser ?? false;
  bool get actif => user.value?.actif ?? false;
}
