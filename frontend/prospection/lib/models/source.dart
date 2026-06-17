import 'package:isar/isar.dart';
import '../utils/status.dart';
import 'fiche.dart';

part 'generated/source.g.dart';

@collection
class Source {
  /// Local Isar ID
  Id isarId = Isar.autoIncrement;

  /// Server ID
  @Index(unique: true)
  String idSource;

  String libelleSource;

  DateTime createdAt;

  /// One Source -> Many Fiches
  @Backlink(to: 'source')
  final fiches = IsarLinks<Fiche>();
  @enumerated
  SyncState syncState = SyncState.pending;

  Source({
    required this.idSource,
    required this.libelleSource,
    required this.createdAt,
  });

  factory Source.fromJson(Map<String, dynamic> json) => Source(
        idSource: json['idSource'],
        libelleSource: json['libelleSource'] ?? '',
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : DateTime.now(),
      );

  /// For UI
  Map<String, dynamic> toLocalJson() {
    return {
      'idSource': idSource,
      'libelleSource': libelleSource,
      'createdAt': createdAt.toIso8601String(),
      'fiches': fiches.map((f) => f.toLocalJson()).toList(),
    };
  }

  /// For API
  Map<String, dynamic> toJsonApi() {
    return {
      'idSource': idSource,
      'libelleSource': libelleSource,
      'createdAt': createdAt.toIso8601String(),

      // Only send IDs
      'fiches': fiches.map((f) => f.idFiche).toList(),
    };
  }
}
