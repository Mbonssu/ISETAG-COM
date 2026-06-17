// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../interet_filiere.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetInteretFiliereCollection on Isar {
  IsarCollection<InteretFiliere> get interetFilieres => this.collection();
}

const InteretFiliereSchema = CollectionSchema(
  name: r'InteretFiliere',
  id: -6520319876669841451,
  properties: {
    r'commentaire': PropertySchema(
      id: 0,
      name: r'commentaire',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'idInteret': PropertySchema(
      id: 2,
      name: r'idInteret',
      type: IsarType.string,
    ),
    r'idProspect': PropertySchema(
      id: 3,
      name: r'idProspect',
      type: IsarType.string,
    ),
    r'idSpecialite': PropertySchema(
      id: 4,
      name: r'idSpecialite',
      type: IsarType.string,
    ),
    r'niveauInteret': PropertySchema(
      id: 5,
      name: r'niveauInteret',
      type: IsarType.long,
    ),
    r'ordrePreference': PropertySchema(
      id: 6,
      name: r'ordrePreference',
      type: IsarType.long,
    ),
    r'syncState': PropertySchema(
      id: 7,
      name: r'syncState',
      type: IsarType.byte,
      enumMap: _InteretFilieresyncStateEnumValueMap,
    )
  },
  estimateSize: _interetFiliereEstimateSize,
  serialize: _interetFiliereSerialize,
  deserialize: _interetFiliereDeserialize,
  deserializeProp: _interetFiliereDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'idInteret': IndexSchema(
      id: 1958392682715353677,
      name: r'idInteret',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'idInteret',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'idProspect': IndexSchema(
      id: -6185438842360057898,
      name: r'idProspect',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'idProspect',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'idSpecialite': IndexSchema(
      id: 1402599325489044525,
      name: r'idSpecialite',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'idSpecialite',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'ordrePreference': IndexSchema(
      id: -193116251213232735,
      name: r'ordrePreference',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'ordrePreference',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'niveauInteret': IndexSchema(
      id: 8284816322365276627,
      name: r'niveauInteret',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'niveauInteret',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'createdAt': IndexSchema(
      id: -3433535483987302584,
      name: r'createdAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'createdAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {
    r'prospect': LinkSchema(
      id: -8917783500577030721,
      name: r'prospect',
      target: r'Prospect',
      single: true,
    ),
    r'specialite': LinkSchema(
      id: 8505983163657801807,
      name: r'specialite',
      target: r'Specialite',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _interetFiliereGetId,
  getLinks: _interetFiliereGetLinks,
  attach: _interetFiliereAttach,
  version: '3.1.0+1',
);

int _interetFiliereEstimateSize(
  InteretFiliere object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.commentaire;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.idInteret.length * 3;
  bytesCount += 3 + object.idProspect.length * 3;
  bytesCount += 3 + object.idSpecialite.length * 3;
  return bytesCount;
}

void _interetFiliereSerialize(
  InteretFiliere object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.commentaire);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeString(offsets[2], object.idInteret);
  writer.writeString(offsets[3], object.idProspect);
  writer.writeString(offsets[4], object.idSpecialite);
  writer.writeLong(offsets[5], object.niveauInteret);
  writer.writeLong(offsets[6], object.ordrePreference);
  writer.writeByte(offsets[7], object.syncState.index);
}

InteretFiliere _interetFiliereDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = InteretFiliere(
    commentaire: reader.readStringOrNull(offsets[0]),
    createdAt: reader.readDateTime(offsets[1]),
    idInteret: reader.readString(offsets[2]),
    idProspect: reader.readString(offsets[3]),
    idSpecialite: reader.readString(offsets[4]),
    niveauInteret: reader.readLong(offsets[5]),
    ordrePreference: reader.readLong(offsets[6]),
  );
  object.isarId = id;
  object.syncState =
      _InteretFilieresyncStateValueEnumMap[reader.readByteOrNull(offsets[7])] ??
          SyncState.pending;
  return object;
}

P _interetFiliereDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (_InteretFilieresyncStateValueEnumMap[
              reader.readByteOrNull(offset)] ??
          SyncState.pending) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _InteretFilieresyncStateEnumValueMap = {
  'pending': 0,
  'syncing': 1,
  'synced': 2,
  'failed': 3,
};
const _InteretFilieresyncStateValueEnumMap = {
  0: SyncState.pending,
  1: SyncState.syncing,
  2: SyncState.synced,
  3: SyncState.failed,
};

Id _interetFiliereGetId(InteretFiliere object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _interetFiliereGetLinks(InteretFiliere object) {
  return [object.prospect, object.specialite];
}

void _interetFiliereAttach(
    IsarCollection<dynamic> col, Id id, InteretFiliere object) {
  object.isarId = id;
  object.prospect.attach(col, col.isar.collection<Prospect>(), r'prospect', id);
  object.specialite
      .attach(col, col.isar.collection<Specialite>(), r'specialite', id);
}

extension InteretFiliereByIndex on IsarCollection<InteretFiliere> {
  Future<InteretFiliere?> getByIdInteret(String idInteret) {
    return getByIndex(r'idInteret', [idInteret]);
  }

  InteretFiliere? getByIdInteretSync(String idInteret) {
    return getByIndexSync(r'idInteret', [idInteret]);
  }

  Future<bool> deleteByIdInteret(String idInteret) {
    return deleteByIndex(r'idInteret', [idInteret]);
  }

  bool deleteByIdInteretSync(String idInteret) {
    return deleteByIndexSync(r'idInteret', [idInteret]);
  }

  Future<List<InteretFiliere?>> getAllByIdInteret(
      List<String> idInteretValues) {
    final values = idInteretValues.map((e) => [e]).toList();
    return getAllByIndex(r'idInteret', values);
  }

  List<InteretFiliere?> getAllByIdInteretSync(List<String> idInteretValues) {
    final values = idInteretValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'idInteret', values);
  }

  Future<int> deleteAllByIdInteret(List<String> idInteretValues) {
    final values = idInteretValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'idInteret', values);
  }

  int deleteAllByIdInteretSync(List<String> idInteretValues) {
    final values = idInteretValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'idInteret', values);
  }

  Future<Id> putByIdInteret(InteretFiliere object) {
    return putByIndex(r'idInteret', object);
  }

  Id putByIdInteretSync(InteretFiliere object, {bool saveLinks = true}) {
    return putByIndexSync(r'idInteret', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByIdInteret(List<InteretFiliere> objects) {
    return putAllByIndex(r'idInteret', objects);
  }

  List<Id> putAllByIdInteretSync(List<InteretFiliere> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'idInteret', objects, saveLinks: saveLinks);
  }
}

extension InteretFiliereQueryWhereSort
    on QueryBuilder<InteretFiliere, InteretFiliere, QWhere> {
  QueryBuilder<InteretFiliere, InteretFiliere, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterWhere>
      anyOrdrePreference() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'ordrePreference'),
      );
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterWhere> anyNiveauInteret() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'niveauInteret'),
      );
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterWhere> anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }
}

extension InteretFiliereQueryWhere
    on QueryBuilder<InteretFiliere, InteretFiliere, QWhereClause> {
  QueryBuilder<InteretFiliere, InteretFiliere, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterWhereClause>
      isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterWhereClause> isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterWhereClause>
      idInteretEqualTo(String idInteret) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'idInteret',
        value: [idInteret],
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterWhereClause>
      idInteretNotEqualTo(String idInteret) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idInteret',
              lower: [],
              upper: [idInteret],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idInteret',
              lower: [idInteret],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idInteret',
              lower: [idInteret],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idInteret',
              lower: [],
              upper: [idInteret],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterWhereClause>
      idProspectEqualTo(String idProspect) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'idProspect',
        value: [idProspect],
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterWhereClause>
      idProspectNotEqualTo(String idProspect) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idProspect',
              lower: [],
              upper: [idProspect],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idProspect',
              lower: [idProspect],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idProspect',
              lower: [idProspect],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idProspect',
              lower: [],
              upper: [idProspect],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterWhereClause>
      idSpecialiteEqualTo(String idSpecialite) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'idSpecialite',
        value: [idSpecialite],
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterWhereClause>
      idSpecialiteNotEqualTo(String idSpecialite) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idSpecialite',
              lower: [],
              upper: [idSpecialite],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idSpecialite',
              lower: [idSpecialite],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idSpecialite',
              lower: [idSpecialite],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idSpecialite',
              lower: [],
              upper: [idSpecialite],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterWhereClause>
      ordrePreferenceEqualTo(int ordrePreference) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'ordrePreference',
        value: [ordrePreference],
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterWhereClause>
      ordrePreferenceNotEqualTo(int ordrePreference) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ordrePreference',
              lower: [],
              upper: [ordrePreference],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ordrePreference',
              lower: [ordrePreference],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ordrePreference',
              lower: [ordrePreference],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ordrePreference',
              lower: [],
              upper: [ordrePreference],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterWhereClause>
      ordrePreferenceGreaterThan(
    int ordrePreference, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'ordrePreference',
        lower: [ordrePreference],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterWhereClause>
      ordrePreferenceLessThan(
    int ordrePreference, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'ordrePreference',
        lower: [],
        upper: [ordrePreference],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterWhereClause>
      ordrePreferenceBetween(
    int lowerOrdrePreference,
    int upperOrdrePreference, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'ordrePreference',
        lower: [lowerOrdrePreference],
        includeLower: includeLower,
        upper: [upperOrdrePreference],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterWhereClause>
      niveauInteretEqualTo(int niveauInteret) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'niveauInteret',
        value: [niveauInteret],
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterWhereClause>
      niveauInteretNotEqualTo(int niveauInteret) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'niveauInteret',
              lower: [],
              upper: [niveauInteret],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'niveauInteret',
              lower: [niveauInteret],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'niveauInteret',
              lower: [niveauInteret],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'niveauInteret',
              lower: [],
              upper: [niveauInteret],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterWhereClause>
      niveauInteretGreaterThan(
    int niveauInteret, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'niveauInteret',
        lower: [niveauInteret],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterWhereClause>
      niveauInteretLessThan(
    int niveauInteret, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'niveauInteret',
        lower: [],
        upper: [niveauInteret],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterWhereClause>
      niveauInteretBetween(
    int lowerNiveauInteret,
    int upperNiveauInteret, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'niveauInteret',
        lower: [lowerNiveauInteret],
        includeLower: includeLower,
        upper: [upperNiveauInteret],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterWhereClause>
      createdAtEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [createdAt],
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterWhereClause>
      createdAtNotEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [],
              upper: [createdAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [createdAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [createdAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [],
              upper: [createdAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterWhereClause>
      createdAtGreaterThan(
    DateTime createdAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [createdAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterWhereClause>
      createdAtLessThan(
    DateTime createdAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [],
        upper: [createdAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterWhereClause>
      createdAtBetween(
    DateTime lowerCreatedAt,
    DateTime upperCreatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [lowerCreatedAt],
        includeLower: includeLower,
        upper: [upperCreatedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension InteretFiliereQueryFilter
    on QueryBuilder<InteretFiliere, InteretFiliere, QFilterCondition> {
  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      commentaireIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'commentaire',
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      commentaireIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'commentaire',
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      commentaireEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'commentaire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      commentaireGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'commentaire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      commentaireLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'commentaire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      commentaireBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'commentaire',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      commentaireStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'commentaire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      commentaireEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'commentaire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      commentaireContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'commentaire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      commentaireMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'commentaire',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      commentaireIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'commentaire',
        value: '',
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      commentaireIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'commentaire',
        value: '',
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      idInteretEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idInteret',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      idInteretGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idInteret',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      idInteretLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idInteret',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      idInteretBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idInteret',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      idInteretStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'idInteret',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      idInteretEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'idInteret',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      idInteretContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idInteret',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      idInteretMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idInteret',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      idInteretIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idInteret',
        value: '',
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      idInteretIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idInteret',
        value: '',
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      idProspectEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idProspect',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      idProspectGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idProspect',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      idProspectLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idProspect',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      idProspectBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idProspect',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      idProspectStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'idProspect',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      idProspectEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'idProspect',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      idProspectContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idProspect',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      idProspectMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idProspect',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      idProspectIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idProspect',
        value: '',
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      idProspectIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idProspect',
        value: '',
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      idSpecialiteEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idSpecialite',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      idSpecialiteGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idSpecialite',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      idSpecialiteLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idSpecialite',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      idSpecialiteBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idSpecialite',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      idSpecialiteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'idSpecialite',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      idSpecialiteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'idSpecialite',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      idSpecialiteContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idSpecialite',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      idSpecialiteMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idSpecialite',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      idSpecialiteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idSpecialite',
        value: '',
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      idSpecialiteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idSpecialite',
        value: '',
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      niveauInteretEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'niveauInteret',
        value: value,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      niveauInteretGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'niveauInteret',
        value: value,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      niveauInteretLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'niveauInteret',
        value: value,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      niveauInteretBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'niveauInteret',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      ordrePreferenceEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ordrePreference',
        value: value,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      ordrePreferenceGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ordrePreference',
        value: value,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      ordrePreferenceLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ordrePreference',
        value: value,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      ordrePreferenceBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ordrePreference',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      syncStateEqualTo(SyncState value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncState',
        value: value,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      syncStateGreaterThan(
    SyncState value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'syncState',
        value: value,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      syncStateLessThan(
    SyncState value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'syncState',
        value: value,
      ));
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      syncStateBetween(
    SyncState lower,
    SyncState upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'syncState',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension InteretFiliereQueryObject
    on QueryBuilder<InteretFiliere, InteretFiliere, QFilterCondition> {}

extension InteretFiliereQueryLinks
    on QueryBuilder<InteretFiliere, InteretFiliere, QFilterCondition> {
  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition> prospect(
      FilterQuery<Prospect> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'prospect');
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      prospectIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'prospect', 0, true, 0, true);
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      specialite(FilterQuery<Specialite> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'specialite');
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterFilterCondition>
      specialiteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'specialite', 0, true, 0, true);
    });
  }
}

extension InteretFiliereQuerySortBy
    on QueryBuilder<InteretFiliere, InteretFiliere, QSortBy> {
  QueryBuilder<InteretFiliere, InteretFiliere, QAfterSortBy>
      sortByCommentaire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commentaire', Sort.asc);
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterSortBy>
      sortByCommentaireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commentaire', Sort.desc);
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterSortBy> sortByIdInteret() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idInteret', Sort.asc);
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterSortBy>
      sortByIdInteretDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idInteret', Sort.desc);
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterSortBy>
      sortByIdProspect() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idProspect', Sort.asc);
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterSortBy>
      sortByIdProspectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idProspect', Sort.desc);
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterSortBy>
      sortByIdSpecialite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idSpecialite', Sort.asc);
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterSortBy>
      sortByIdSpecialiteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idSpecialite', Sort.desc);
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterSortBy>
      sortByNiveauInteret() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'niveauInteret', Sort.asc);
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterSortBy>
      sortByNiveauInteretDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'niveauInteret', Sort.desc);
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterSortBy>
      sortByOrdrePreference() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ordrePreference', Sort.asc);
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterSortBy>
      sortByOrdrePreferenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ordrePreference', Sort.desc);
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterSortBy> sortBySyncState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.asc);
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterSortBy>
      sortBySyncStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.desc);
    });
  }
}

extension InteretFiliereQuerySortThenBy
    on QueryBuilder<InteretFiliere, InteretFiliere, QSortThenBy> {
  QueryBuilder<InteretFiliere, InteretFiliere, QAfterSortBy>
      thenByCommentaire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commentaire', Sort.asc);
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterSortBy>
      thenByCommentaireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commentaire', Sort.desc);
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterSortBy> thenByIdInteret() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idInteret', Sort.asc);
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterSortBy>
      thenByIdInteretDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idInteret', Sort.desc);
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterSortBy>
      thenByIdProspect() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idProspect', Sort.asc);
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterSortBy>
      thenByIdProspectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idProspect', Sort.desc);
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterSortBy>
      thenByIdSpecialite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idSpecialite', Sort.asc);
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterSortBy>
      thenByIdSpecialiteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idSpecialite', Sort.desc);
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterSortBy>
      thenByNiveauInteret() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'niveauInteret', Sort.asc);
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterSortBy>
      thenByNiveauInteretDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'niveauInteret', Sort.desc);
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterSortBy>
      thenByOrdrePreference() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ordrePreference', Sort.asc);
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterSortBy>
      thenByOrdrePreferenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ordrePreference', Sort.desc);
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterSortBy> thenBySyncState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.asc);
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QAfterSortBy>
      thenBySyncStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.desc);
    });
  }
}

extension InteretFiliereQueryWhereDistinct
    on QueryBuilder<InteretFiliere, InteretFiliere, QDistinct> {
  QueryBuilder<InteretFiliere, InteretFiliere, QDistinct> distinctByCommentaire(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'commentaire', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QDistinct> distinctByIdInteret(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idInteret', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QDistinct> distinctByIdProspect(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idProspect', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QDistinct>
      distinctByIdSpecialite({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idSpecialite', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QDistinct>
      distinctByNiveauInteret() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'niveauInteret');
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QDistinct>
      distinctByOrdrePreference() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ordrePreference');
    });
  }

  QueryBuilder<InteretFiliere, InteretFiliere, QDistinct>
      distinctBySyncState() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncState');
    });
  }
}

extension InteretFiliereQueryProperty
    on QueryBuilder<InteretFiliere, InteretFiliere, QQueryProperty> {
  QueryBuilder<InteretFiliere, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<InteretFiliere, String?, QQueryOperations>
      commentaireProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'commentaire');
    });
  }

  QueryBuilder<InteretFiliere, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<InteretFiliere, String, QQueryOperations> idInteretProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idInteret');
    });
  }

  QueryBuilder<InteretFiliere, String, QQueryOperations> idProspectProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idProspect');
    });
  }

  QueryBuilder<InteretFiliere, String, QQueryOperations>
      idSpecialiteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idSpecialite');
    });
  }

  QueryBuilder<InteretFiliere, int, QQueryOperations> niveauInteretProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'niveauInteret');
    });
  }

  QueryBuilder<InteretFiliere, int, QQueryOperations>
      ordrePreferenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ordrePreference');
    });
  }

  QueryBuilder<InteretFiliere, SyncState, QQueryOperations>
      syncStateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncState');
    });
  }
}
