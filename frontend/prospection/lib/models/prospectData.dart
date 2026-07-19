import 'package:isetagcom/models/classe.dart';
import 'package:isetagcom/models/etablissement.dart';
import 'package:isetagcom/models/pros.dart';

import '../utils/status.dart';

/// Modèle de données pour un prospect
// class Prospect {
//   final String id,initials;
//   final String name;
//   final String institution;
//   final String interest;
//   final ProspectStatus status;
//   final int? rating;
//   final String? notes;
//   final DateTime createdAt;
//   final DateTime? lastContactAt;

//   const Prospect({
//     required this.id,
//     required this.initials,
//     required this.name,
//     required this.institution,
//     required this.interest,
//     required this.status,
//     this.rating,
//     this.notes,
//     required this.createdAt,
//     this.lastContactAt,
//   });

//   /// Factory constructor pour créer un prospect depuis JSON
//   factory Prospect.fromJson(Map<String, dynamic> json) {
//     return Prospect(
//       id: json['id'],
//       initials: json['initials'],
//       name: json['name'],
//       institution: json['institution'],
//       interest: json['interest'],
//       status: ProspectStatus.values[json['status'] ?? 1],
//       rating: json['rating'],
//       notes: json['notes'],
//       createdAt: DateTime.parse(json['createdAt']),
//       lastContactAt: json['lastContactAt'] != null
//           ? DateTime.parse(json['lastContactAt'])
//           : null,
//     );
//   }

//   /// Convertir le prospect en JSON
//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'initials': initials,
//     'name': name,
//     'institution': institution,
//     'interest': interest,
//     'status': status.index,
//     'rating': rating,
//     'notes': notes,
//     'createdAt': createdAt.toIso8601String(),
//     'lastContactAt': lastContactAt?.toIso8601String(),
//   };
// }

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
  ProspectData(
    initials: 'MS',
    name: 'Milenne S.',
    institution: 'Institut Confucius laurent',
    interest: 'Intéressée par Marketing',
    status: ProspectStatus.contacte,
  ),
];

class ProspectCard {
  final int id;
  final String name;
  final String? phone;

  ProspectCard({required this.id, required this.name, this.phone});
}

class ProspectDetails {
  // final String id;
  // final String nom;
  // final String? telephone;
  // final String? email;
  // final String? addresse;
  final Etablissement etablissement;
  final Classe classe;
  // final String? commentaire;
  final Prospect prosp;
  final List<SpecialityDetail> specialities;
  final int color;
  // final SyncState syncState = SyncState.pending;
  // final ProspectStatus ps;

  ProspectDetails({
    // required this.id,
    // required this.nom,
    required this.prosp,
    required this.etablissement,
    required this.classe,
    required this.specialities,
    this.color = 0xFF1E7D34,
    // required this.ps,
    // this.commentaire,
    // this.telephone,
    // this.email,
    // this.addresse,
  });

  Map<String, dynamic> toLocalJson() {
    return {
      'ets': etablissement,
      'class': classe,
      'Prospect_info': prosp.toLocalJson(),
      'Specialities_info': specialities.map((sp) => sp.toLocalJson()).toList(),
    };
  }
}

class SpecialityDetail {
  final String libelleSpecialite;
  final int orderPreference;
  final int niveau;
  final String? commentaire;

  SpecialityDetail(
      {required this.libelleSpecialite,
      required this.orderPreference,
      required this.niveau,
      this.commentaire});

  Map<String, dynamic> toLocalJson() {
    return {
      'libelleSpecialite': libelleSpecialite,
      'orderPreference': orderPreference,
      'niveau': niveau,
      'commentaire': commentaire,
    };
  }
}
