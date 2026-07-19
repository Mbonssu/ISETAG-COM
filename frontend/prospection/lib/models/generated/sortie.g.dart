// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../sortie.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSortieCollection on Isar {
  IsarCollection<Sortie> get sorties => this.collection();
}

const SortieSchema = CollectionSchema(
  name: r'Sortie',
  id: -1758043960676553321,
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
    r'dateSortie': PropertySchema(
      id: 2,
      name: r'dateSortie',
      type: IsarType.dateTime,
    ),
    r'idCampagne': PropertySchema(
      id: 3,
      name: r'idCampagne',
      type: IsarType.string,
    ),
    r'idEtablissement': PropertySchema(
      id: 4,
      name: r'idEtablissement',
      type: IsarType.string,
    ),
    r'idSortie': PropertySchema(
      id: 5,
      name: r'idSortie',
      type: IsarType.string,
    ),
    r'idZone': PropertySchema(
      id: 6,
      name: r'idZone',
      type: IsarType.string,
    ),
    r'objectif': PropertySchema(
      id: 7,
      name: r'objectif',
      type: IsarType.string,
    ),
    r'statut': PropertySchema(
      id: 8,
      name: r'statut',
      type: IsarType.string,
    ),
    r'typeSortie': PropertySchema(
      id: 9,
      name: r'typeSortie',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 10,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _sortieEstimateSize,
  serialize: _sortieSerialize,
  deserialize: _sortieDeserialize,
  deserializeProp: _sortieDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'idSortie': IndexSchema(
      id: 121373801389165956,
      name: r'idSortie',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'idSortie',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'idZone': IndexSchema(
      id: -6617875878800025933,
      name: r'idZone',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'idZone',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'idCampagne': IndexSchema(
      id: 6310864812943436991,
      name: r'idCampagne',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'idCampagne',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'dateSortie': IndexSchema(
      id: 753814907488336613,
      name: r'dateSortie',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'dateSortie',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'statut': IndexSchema(
      id: 898685416201145331,
      name: r'statut',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'statut',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'typeSortie': IndexSchema(
      id: -3720605363565631735,
      name: r'typeSortie',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'typeSortie',
          type: IndexType.hash,
          caseSensitive: true,
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
    r'zone': LinkSchema(
      id: 6036231886614666491,
      name: r'zone',
      target: r'Zone',
      single: true,
    ),
    r'campagne': LinkSchema(
      id: -8627276433068265678,
      name: r'campagne',
      target: r'Campagne',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _sortieGetId,
  getLinks: _sortieGetLinks,
  attach: _sortieAttach,
  version: '3.3.2',
);

int _sortieEstimateSize(
  Sortie object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.commentaire.length * 3;
  bytesCount += 3 + object.idCampagne.length * 3;
  {
    final value = object.idEtablissement;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.idSortie.length * 3;
  bytesCount += 3 + object.idZone.length * 3;
  bytesCount += 3 + object.objectif.length * 3;
  bytesCount += 3 + object.statut.length * 3;
  bytesCount += 3 + object.typeSortie.length * 3;
  return bytesCount;
}

void _sortieSerialize(
  Sortie object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.commentaire);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeDateTime(offsets[2], object.dateSortie);
  writer.writeString(offsets[3], object.idCampagne);
  writer.writeString(offsets[4], object.idEtablissement);
  writer.writeString(offsets[5], object.idSortie);
  writer.writeString(offsets[6], object.idZone);
  writer.writeString(offsets[7], object.objectif);
  writer.writeString(offsets[8], object.statut);
  writer.writeString(offsets[9], object.typeSortie);
  writer.writeDateTime(offsets[10], object.updatedAt);
}

Sortie _sortieDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Sortie(
    commentaire: reader.readString(offsets[0]),
    createdAt: reader.readDateTime(offsets[1]),
    dateSortie: reader.readDateTime(offsets[2]),
    idCampagne: reader.readString(offsets[3]),
    idEtablissement: reader.readStringOrNull(offsets[4]),
    idSortie: reader.readString(offsets[5]),
    idZone: reader.readString(offsets[6]),
    objectif: reader.readString(offsets[7]),
    statut: reader.readString(offsets[8]),
    typeSortie: reader.readString(offsets[9]),
    updatedAt: reader.readDateTimeOrNull(offsets[10]),
  );
  object.isarId = id;
  return object;
}

P _sortieDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _sortieGetId(Sortie object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _sortieGetLinks(Sortie object) {
  return [object.zone, object.campagne];
}

void _sortieAttach(IsarCollection<dynamic> col, Id id, Sortie object) {
  object.isarId = id;
  object.zone.attach(col, col.isar.collection<Zone>(), r'zone', id);
  object.campagne.attach(col, col.isar.collection<Campagne>(), r'campagne', id);
}

extension SortieByIndex on IsarCollection<Sortie> {
  Future<Sortie?> getByIdSortie(String idSortie) {
    return getByIndex(r'idSortie', [idSortie]);
  }

  Sortie? getByIdSortieSync(String idSortie) {
    return getByIndexSync(r'idSortie', [idSortie]);
  }

  Future<bool> deleteByIdSortie(String idSortie) {
    return deleteByIndex(r'idSortie', [idSortie]);
  }

  bool deleteByIdSortieSync(String idSortie) {
    return deleteByIndexSync(r'idSortie', [idSortie]);
  }

  Future<List<Sortie?>> getAllByIdSortie(List<String> idSortieValues) {
    final values = idSortieValues.map((e) => [e]).toList();
    return getAllByIndex(r'idSortie', values);
  }

  List<Sortie?> getAllByIdSortieSync(List<String> idSortieValues) {
    final values = idSortieValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'idSortie', values);
  }

  Future<int> deleteAllByIdSortie(List<String> idSortieValues) {
    final values = idSortieValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'idSortie', values);
  }

  int deleteAllByIdSortieSync(List<String> idSortieValues) {
    final values = idSortieValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'idSortie', values);
  }

  Future<Id> putByIdSortie(Sortie object) {
    return putByIndex(r'idSortie', object);
  }

  Id putByIdSortieSync(Sortie object, {bool saveLinks = true}) {
    return putByIndexSync(r'idSortie', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByIdSortie(List<Sortie> objects) {
    return putAllByIndex(r'idSortie', objects);
  }

  List<Id> putAllByIdSortieSync(List<Sortie> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'idSortie', objects, saveLinks: saveLinks);
  }
}

extension SortieQueryWhereSort on QueryBuilder<Sortie, Sortie, QWhere> {
  QueryBuilder<Sortie, Sortie, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterWhere> anyDateSortie() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'dateSortie'),
      );
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterWhere> anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }
}

extension SortieQueryWhere on QueryBuilder<Sortie, Sortie, QWhereClause> {
  QueryBuilder<Sortie, Sortie, QAfterWhereClause> isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterWhereClause> isarIdNotEqualTo(Id isarId) {
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

  QueryBuilder<Sortie, Sortie, QAfterWhereClause> isarIdGreaterThan(Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterWhereClause> isarIdLessThan(Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterWhereClause> isarIdBetween(
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

  QueryBuilder<Sortie, Sortie, QAfterWhereClause> idSortieEqualTo(
      String idSortie) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'idSortie',
        value: [idSortie],
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterWhereClause> idSortieNotEqualTo(
      String idSortie) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idSortie',
              lower: [],
              upper: [idSortie],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idSortie',
              lower: [idSortie],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idSortie',
              lower: [idSortie],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idSortie',
              lower: [],
              upper: [idSortie],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterWhereClause> idZoneEqualTo(String idZone) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'idZone',
        value: [idZone],
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterWhereClause> idZoneNotEqualTo(
      String idZone) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idZone',
              lower: [],
              upper: [idZone],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idZone',
              lower: [idZone],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idZone',
              lower: [idZone],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idZone',
              lower: [],
              upper: [idZone],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterWhereClause> idCampagneEqualTo(
      String idCampagne) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'idCampagne',
        value: [idCampagne],
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterWhereClause> idCampagneNotEqualTo(
      String idCampagne) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idCampagne',
              lower: [],
              upper: [idCampagne],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idCampagne',
              lower: [idCampagne],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idCampagne',
              lower: [idCampagne],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idCampagne',
              lower: [],
              upper: [idCampagne],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterWhereClause> dateSortieEqualTo(
      DateTime dateSortie) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'dateSortie',
        value: [dateSortie],
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterWhereClause> dateSortieNotEqualTo(
      DateTime dateSortie) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateSortie',
              lower: [],
              upper: [dateSortie],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateSortie',
              lower: [dateSortie],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateSortie',
              lower: [dateSortie],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateSortie',
              lower: [],
              upper: [dateSortie],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterWhereClause> dateSortieGreaterThan(
    DateTime dateSortie, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dateSortie',
        lower: [dateSortie],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterWhereClause> dateSortieLessThan(
    DateTime dateSortie, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dateSortie',
        lower: [],
        upper: [dateSortie],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterWhereClause> dateSortieBetween(
    DateTime lowerDateSortie,
    DateTime upperDateSortie, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dateSortie',
        lower: [lowerDateSortie],
        includeLower: includeLower,
        upper: [upperDateSortie],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterWhereClause> statutEqualTo(String statut) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'statut',
        value: [statut],
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterWhereClause> statutNotEqualTo(
      String statut) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'statut',
              lower: [],
              upper: [statut],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'statut',
              lower: [statut],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'statut',
              lower: [statut],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'statut',
              lower: [],
              upper: [statut],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterWhereClause> typeSortieEqualTo(
      String typeSortie) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'typeSortie',
        value: [typeSortie],
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterWhereClause> typeSortieNotEqualTo(
      String typeSortie) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'typeSortie',
              lower: [],
              upper: [typeSortie],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'typeSortie',
              lower: [typeSortie],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'typeSortie',
              lower: [typeSortie],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'typeSortie',
              lower: [],
              upper: [typeSortie],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterWhereClause> createdAtEqualTo(
      DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [createdAt],
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterWhereClause> createdAtNotEqualTo(
      DateTime createdAt) {
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

  QueryBuilder<Sortie, Sortie, QAfterWhereClause> createdAtGreaterThan(
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

  QueryBuilder<Sortie, Sortie, QAfterWhereClause> createdAtLessThan(
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

  QueryBuilder<Sortie, Sortie, QAfterWhereClause> createdAtBetween(
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

extension SortieQueryFilter on QueryBuilder<Sortie, Sortie, QFilterCondition> {
  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> commentaireEqualTo(
    String value, {
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

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> commentaireGreaterThan(
    String value, {
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

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> commentaireLessThan(
    String value, {
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

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> commentaireBetween(
    String lower,
    String upper, {
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

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> commentaireStartsWith(
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

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> commentaireEndsWith(
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

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> commentaireContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'commentaire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> commentaireMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'commentaire',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> commentaireIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'commentaire',
        value: '',
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> commentaireIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'commentaire',
        value: '',
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> createdAtGreaterThan(
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

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> createdAtLessThan(
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

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> createdAtBetween(
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

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> dateSortieEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateSortie',
        value: value,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> dateSortieGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateSortie',
        value: value,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> dateSortieLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateSortie',
        value: value,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> dateSortieBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateSortie',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> idCampagneEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idCampagne',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> idCampagneGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idCampagne',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> idCampagneLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idCampagne',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> idCampagneBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idCampagne',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> idCampagneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'idCampagne',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> idCampagneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'idCampagne',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> idCampagneContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idCampagne',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> idCampagneMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idCampagne',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> idCampagneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idCampagne',
        value: '',
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> idCampagneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idCampagne',
        value: '',
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> idEtablissementIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'idEtablissement',
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition>
      idEtablissementIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'idEtablissement',
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> idEtablissementEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idEtablissement',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition>
      idEtablissementGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idEtablissement',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> idEtablissementLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idEtablissement',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> idEtablissementBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idEtablissement',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> idEtablissementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'idEtablissement',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> idEtablissementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'idEtablissement',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> idEtablissementContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idEtablissement',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> idEtablissementMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idEtablissement',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> idEtablissementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idEtablissement',
        value: '',
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition>
      idEtablissementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idEtablissement',
        value: '',
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> idSortieEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idSortie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> idSortieGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idSortie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> idSortieLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idSortie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> idSortieBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idSortie',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> idSortieStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'idSortie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> idSortieEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'idSortie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> idSortieContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idSortie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> idSortieMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idSortie',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> idSortieIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idSortie',
        value: '',
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> idSortieIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idSortie',
        value: '',
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> idZoneEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idZone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> idZoneGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idZone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> idZoneLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idZone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> idZoneBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idZone',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> idZoneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'idZone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> idZoneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'idZone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> idZoneContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idZone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> idZoneMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idZone',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> idZoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idZone',
        value: '',
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> idZoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idZone',
        value: '',
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> isarIdGreaterThan(
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

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> isarIdLessThan(
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

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> isarIdBetween(
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

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> objectifEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'objectif',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> objectifGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'objectif',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> objectifLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'objectif',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> objectifBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'objectif',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> objectifStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'objectif',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> objectifEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'objectif',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> objectifContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'objectif',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> objectifMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'objectif',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> objectifIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'objectif',
        value: '',
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> objectifIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'objectif',
        value: '',
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> statutEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'statut',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> statutGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'statut',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> statutLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'statut',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> statutBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'statut',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> statutStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'statut',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> statutEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'statut',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> statutContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'statut',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> statutMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'statut',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> statutIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'statut',
        value: '',
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> statutIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'statut',
        value: '',
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> typeSortieEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'typeSortie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> typeSortieGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'typeSortie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> typeSortieLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'typeSortie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> typeSortieBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'typeSortie',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> typeSortieStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'typeSortie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> typeSortieEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'typeSortie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> typeSortieContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'typeSortie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> typeSortieMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'typeSortie',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> typeSortieIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'typeSortie',
        value: '',
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> typeSortieIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'typeSortie',
        value: '',
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> updatedAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> updatedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> updatedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> updatedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SortieQueryObject on QueryBuilder<Sortie, Sortie, QFilterCondition> {}

extension SortieQueryLinks on QueryBuilder<Sortie, Sortie, QFilterCondition> {
  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> zone(
      FilterQuery<Zone> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'zone');
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> zoneIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'zone', 0, true, 0, true);
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> campagne(
      FilterQuery<Campagne> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'campagne');
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterFilterCondition> campagneIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'campagne', 0, true, 0, true);
    });
  }
}

extension SortieQuerySortBy on QueryBuilder<Sortie, Sortie, QSortBy> {
  QueryBuilder<Sortie, Sortie, QAfterSortBy> sortByCommentaire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commentaire', Sort.asc);
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterSortBy> sortByCommentaireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commentaire', Sort.desc);
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterSortBy> sortByDateSortie() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateSortie', Sort.asc);
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterSortBy> sortByDateSortieDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateSortie', Sort.desc);
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterSortBy> sortByIdCampagne() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idCampagne', Sort.asc);
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterSortBy> sortByIdCampagneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idCampagne', Sort.desc);
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterSortBy> sortByIdEtablissement() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idEtablissement', Sort.asc);
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterSortBy> sortByIdEtablissementDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idEtablissement', Sort.desc);
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterSortBy> sortByIdSortie() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idSortie', Sort.asc);
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterSortBy> sortByIdSortieDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idSortie', Sort.desc);
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterSortBy> sortByIdZone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idZone', Sort.asc);
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterSortBy> sortByIdZoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idZone', Sort.desc);
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterSortBy> sortByObjectif() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'objectif', Sort.asc);
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterSortBy> sortByObjectifDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'objectif', Sort.desc);
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterSortBy> sortByStatut() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statut', Sort.asc);
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterSortBy> sortByStatutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statut', Sort.desc);
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterSortBy> sortByTypeSortie() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeSortie', Sort.asc);
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterSortBy> sortByTypeSortieDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeSortie', Sort.desc);
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension SortieQuerySortThenBy on QueryBuilder<Sortie, Sortie, QSortThenBy> {
  QueryBuilder<Sortie, Sortie, QAfterSortBy> thenByCommentaire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commentaire', Sort.asc);
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterSortBy> thenByCommentaireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commentaire', Sort.desc);
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterSortBy> thenByDateSortie() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateSortie', Sort.asc);
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterSortBy> thenByDateSortieDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateSortie', Sort.desc);
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterSortBy> thenByIdCampagne() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idCampagne', Sort.asc);
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterSortBy> thenByIdCampagneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idCampagne', Sort.desc);
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterSortBy> thenByIdEtablissement() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idEtablissement', Sort.asc);
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterSortBy> thenByIdEtablissementDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idEtablissement', Sort.desc);
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterSortBy> thenByIdSortie() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idSortie', Sort.asc);
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterSortBy> thenByIdSortieDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idSortie', Sort.desc);
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterSortBy> thenByIdZone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idZone', Sort.asc);
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterSortBy> thenByIdZoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idZone', Sort.desc);
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterSortBy> thenByObjectif() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'objectif', Sort.asc);
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterSortBy> thenByObjectifDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'objectif', Sort.desc);
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterSortBy> thenByStatut() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statut', Sort.asc);
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterSortBy> thenByStatutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statut', Sort.desc);
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterSortBy> thenByTypeSortie() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeSortie', Sort.asc);
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterSortBy> thenByTypeSortieDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeSortie', Sort.desc);
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Sortie, Sortie, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension SortieQueryWhereDistinct on QueryBuilder<Sortie, Sortie, QDistinct> {
  QueryBuilder<Sortie, Sortie, QDistinct> distinctByCommentaire(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'commentaire', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Sortie, Sortie, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<Sortie, Sortie, QDistinct> distinctByDateSortie() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateSortie');
    });
  }

  QueryBuilder<Sortie, Sortie, QDistinct> distinctByIdCampagne(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idCampagne', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Sortie, Sortie, QDistinct> distinctByIdEtablissement(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idEtablissement',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Sortie, Sortie, QDistinct> distinctByIdSortie(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idSortie', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Sortie, Sortie, QDistinct> distinctByIdZone(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idZone', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Sortie, Sortie, QDistinct> distinctByObjectif(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'objectif', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Sortie, Sortie, QDistinct> distinctByStatut(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'statut', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Sortie, Sortie, QDistinct> distinctByTypeSortie(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'typeSortie', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Sortie, Sortie, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension SortieQueryProperty on QueryBuilder<Sortie, Sortie, QQueryProperty> {
  QueryBuilder<Sortie, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<Sortie, String, QQueryOperations> commentaireProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'commentaire');
    });
  }

  QueryBuilder<Sortie, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<Sortie, DateTime, QQueryOperations> dateSortieProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateSortie');
    });
  }

  QueryBuilder<Sortie, String, QQueryOperations> idCampagneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idCampagne');
    });
  }

  QueryBuilder<Sortie, String?, QQueryOperations> idEtablissementProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idEtablissement');
    });
  }

  QueryBuilder<Sortie, String, QQueryOperations> idSortieProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idSortie');
    });
  }

  QueryBuilder<Sortie, String, QQueryOperations> idZoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idZone');
    });
  }

  QueryBuilder<Sortie, String, QQueryOperations> objectifProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'objectif');
    });
  }

  QueryBuilder<Sortie, String, QQueryOperations> statutProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'statut');
    });
  }

  QueryBuilder<Sortie, String, QQueryOperations> typeSortieProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'typeSortie');
    });
  }

  QueryBuilder<Sortie, DateTime?, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
