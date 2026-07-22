import 'package:isar_community/isar.dart';
import 'package:isetagcom/utils/status.dart';
import 'pros.dart'; // ✅ IMPORT PROSPECT MODEL

part 'generated/relance.g.dart';

@collection
class Relance {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  String idRelance;

  @Index()
  late String idProspect;

  @Index()
  late DateTime dateRelance;

  late String sujet;
  late String description;

  @Index()
  DateTime? createdAt; // server will provide it, but we store it

  DateTime? updatedAt;

  @enumerated
  SyncState syncState =
      SyncState.pending; // pending, synced, toUpdate, toDelete

  // ✅ NEW: Relationship to Prospect
  // This allows us to load the prospect and check if it's synced
  final prospect = IsarLink<Prospect>();

  Relance({
    required this.idRelance,
    required this.idProspect,
    required this.dateRelance,
    required this.sujet,
    required this.description,
    this.createdAt,
    this.updatedAt,
    this.syncState = SyncState.pending,
  });

  Relance copyWith({
    String? idRelance,
    String? idProspect,
    DateTime? dateRelance,
    String? sujet,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    SyncState? syncState,
  }) {
    return Relance(
      idRelance: idRelance ?? this.idRelance,
      idProspect: idProspect ?? this.idProspect,
      dateRelance: dateRelance ?? this.dateRelance,
      sujet: sujet ?? this.sujet,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncState: syncState ?? this.syncState,
    );
  }

  Map<String, dynamic> toJsonApi() {
    return {
      'idRelance': idRelance,
      'idProspect': idProspect,
      'dateRelance': dateRelance.toIso8601String(),
      'sujet': sujet,
      'description': description,
    };
  }
}
