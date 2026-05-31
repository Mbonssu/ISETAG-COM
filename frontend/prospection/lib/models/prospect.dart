/// Énumération pour les statuts des prospects
enum ProspectStatus {
  relancer,
  nouveau,
  contacte,
}

/// Modèle de données pour un prospect
class Prospect {
  final String id;
  final String initials;
  final String name;
  final String institution;
  final String interest;
  final ProspectStatus status;
  final int? rating;
  final String? notes;
  final DateTime createdAt;
  final DateTime? lastContactAt;

  const Prospect({
    required this.id,
    required this.initials,
    required this.name,
    required this.institution,
    required this.interest,
    required this.status,
    this.rating,
    this.notes,
    required this.createdAt,
    this.lastContactAt,
  });

  /// Factory constructor pour créer un prospect depuis JSON
  factory Prospect.fromJson(Map<String, dynamic> json) {
    return Prospect(
      id: json['id'],
      initials: json['initials'],
      name: json['name'],
      institution: json['institution'],
      interest: json['interest'],
      status: ProspectStatus.values[json['status'] ?? 1],
      rating: json['rating'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
      lastContactAt: json['lastContactAt'] != null
          ? DateTime.parse(json['lastContactAt'])
          : null,
    );
  }

  /// Convertir le prospect en JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'initials': initials,
    'name': name,
    'institution': institution,
    'interest': interest,
    'status': status.index,
    'rating': rating,
    'notes': notes,
    'createdAt': createdAt.toIso8601String(),
    'lastContactAt': lastContactAt?.toIso8601String(),
  };
}

/// Données statiques pour les prospects (à remplacer par un vrai API)
class ProspectData {
  final String initials, name, institution, interest;
  final ProspectStatus status;
  final int color;

  const ProspectData({
    required this.initials,
    required this.name,
    required this.institution,
    required this.interest,
    required this.status,
    this.color = 0xFF1E7D34,
  });
}

const List<ProspectData> kProspects = [
  ProspectData(
    initials: 'ML',
    name: 'Marie L.',
    institution: 'Lycée de Biyem-Assi',
    interest: 'Intéressée par Génie Logiciel',
    status: ProspectStatus.relancer,
  ),
  ProspectData(
    initials: 'DP',
    name: 'David P.',
    institution: "Lycée Technique d'Efoulan",
    interest: 'Intéressé par Génie Civil',
    status: ProspectStatus.nouveau,
  ),
  ProspectData(
    initials: 'AS',
    name: 'Anne S.',
    institution: 'Institut Confucius',
    interest: 'Intéressée par Marketing',
    status: ProspectStatus.contacte,
  ),
];
