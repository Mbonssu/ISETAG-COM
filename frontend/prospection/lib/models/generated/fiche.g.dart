// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../fiche.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFicheCollection on Isar {
  IsarCollection<Fiche> get fiches => this.collection();
}

const FicheSchema = CollectionSchema(
  name: r'Fiche',
  id: -4109940921288365482,
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
    r'dateCollecte': PropertySchema(
      id: 2,
      name: r'dateCollecte',
      type: IsarType.dateTime,
    ),
    r'idFiche': PropertySchema(
      id: 3,
      name: r'idFiche',
      type: IsarType.string,
    ),
    r'idSrc': PropertySchema(
      id: 4,
      name: r'idSrc',
      type: IsarType.string,
    ),
    r'isCurrent': PropertySchema(
      id: 5,
      name: r'isCurrent',
      type: IsarType.bool,
    ),
    r'scoreInteret': PropertySchema(
      id: 6,
      name: r'scoreInteret',
      type: IsarType.long,
    ),
    r'syncState': PropertySchema(
      id: 7,
      name: r'syncState',
      type: IsarType.byte,
      enumMap: _FichesyncStateEnumValueMap,
    ),
    r'updatedAt': PropertySchema(
      id: 8,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _ficheEstimateSize,
  serialize: _ficheSerialize,
  deserialize: _ficheDeserialize,
  deserializeProp: _ficheDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'idFiche': IndexSchema(
      id: 3677606755709757536,
      name: r'idFiche',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'idFiche',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'idSrc': IndexSchema(
      id: -3245292819023643322,
      name: r'idSrc',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'idSrc',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'dateCollecte': IndexSchema(
      id: -149293670996443081,
      name: r'dateCollecte',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'dateCollecte',
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
    ),
    r'updatedAt': IndexSchema(
      id: -6238191080293565125,
      name: r'updatedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'updatedAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {
    r'source': LinkSchema(
      id: -5193227564200538342,
      name: r'source',
      target: r'Source',
      single: true,
    ),
    r'prospects': LinkSchema(
      id: 8768874696013171520,
      name: r'prospects',
      target: r'Prospect',
      single: false,
      linkName: r'fiche',
    )
  },
  embeddedSchemas: {},
  getId: _ficheGetId,
  getLinks: _ficheGetLinks,
  attach: _ficheAttach,
  version: '3.1.0+1',
);

int _ficheEstimateSize(
  Fiche object,
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
  bytesCount += 3 + object.idFiche.length * 3;
  bytesCount += 3 + object.idSrc.length * 3;
  return bytesCount;
}

void _ficheSerialize(
  Fiche object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.commentaire);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeDateTime(offsets[2], object.dateCollecte);
  writer.writeString(offsets[3], object.idFiche);
  writer.writeString(offsets[4], object.idSrc);
  writer.writeBool(offsets[5], object.isCurrent);
  writer.writeLong(offsets[6], object.scoreInteret);
  writer.writeByte(offsets[7], object.syncState.index);
  writer.writeDateTime(offsets[8], object.updatedAt);
}

Fiche _ficheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Fiche(
    commentaire: reader.readStringOrNull(offsets[0]),
    createdAt: reader.readDateTime(offsets[1]),
    dateCollecte: reader.readDateTime(offsets[2]),
    idFiche: reader.readString(offsets[3]),
    idSrc: reader.readString(offsets[4]),
    isCurrent: reader.readBool(offsets[5]),
    scoreInteret: reader.readLongOrNull(offsets[6]),
    syncState: _FichesyncStateValueEnumMap[reader.readByteOrNull(offsets[7])] ??
        SyncState.pending,
  );
  object.isarId = id;
  object.updatedAt = reader.readDateTimeOrNull(offsets[8]);
  return object;
}

P _ficheDeserializeProp<P>(
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
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    case 7:
      return (_FichesyncStateValueEnumMap[reader.readByteOrNull(offset)] ??
          SyncState.pending) as P;
    case 8:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _FichesyncStateEnumValueMap = {
  'pending': 0,
  'syncing': 1,
  'synced': 2,
  'failed': 3,
};
const _FichesyncStateValueEnumMap = {
  0: SyncState.pending,
  1: SyncState.syncing,
  2: SyncState.synced,
  3: SyncState.failed,
};

Id _ficheGetId(Fiche object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _ficheGetLinks(Fiche object) {
  return [object.source, object.prospects];
}

void _ficheAttach(IsarCollection<dynamic> col, Id id, Fiche object) {
  object.isarId = id;
  object.source.attach(col, col.isar.collection<Source>(), r'source', id);
  object.prospects
      .attach(col, col.isar.collection<Prospect>(), r'prospects', id);
}

extension FicheByIndex on IsarCollection<Fiche> {
  Future<Fiche?> getByIdFiche(String idFiche) {
    return getByIndex(r'idFiche', [idFiche]);
  }

  Fiche? getByIdFicheSync(String idFiche) {
    return getByIndexSync(r'idFiche', [idFiche]);
  }

  Future<bool> deleteByIdFiche(String idFiche) {
    return deleteByIndex(r'idFiche', [idFiche]);
  }

  bool deleteByIdFicheSync(String idFiche) {
    return deleteByIndexSync(r'idFiche', [idFiche]);
  }

  Future<List<Fiche?>> getAllByIdFiche(List<String> idFicheValues) {
    final values = idFicheValues.map((e) => [e]).toList();
    return getAllByIndex(r'idFiche', values);
  }

  List<Fiche?> getAllByIdFicheSync(List<String> idFicheValues) {
    final values = idFicheValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'idFiche', values);
  }

  Future<int> deleteAllByIdFiche(List<String> idFicheValues) {
    final values = idFicheValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'idFiche', values);
  }

  int deleteAllByIdFicheSync(List<String> idFicheValues) {
    final values = idFicheValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'idFiche', values);
  }

  Future<Id> putByIdFiche(Fiche object) {
    return putByIndex(r'idFiche', object);
  }

  Id putByIdFicheSync(Fiche object, {bool saveLinks = true}) {
    return putByIndexSync(r'idFiche', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByIdFiche(List<Fiche> objects) {
    return putAllByIndex(r'idFiche', objects);
  }

  List<Id> putAllByIdFicheSync(List<Fiche> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'idFiche', objects, saveLinks: saveLinks);
  }
}

extension FicheQueryWhereSort on QueryBuilder<Fiche, Fiche, QWhere> {
  QueryBuilder<Fiche, Fiche, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterWhere> anyDateCollecte() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'dateCollecte'),
      );
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterWhere> anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterWhere> anyUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'updatedAt'),
      );
    });
  }
}

extension FicheQueryWhere on QueryBuilder<Fiche, Fiche, QWhereClause> {
  QueryBuilder<Fiche, Fiche, QAfterWhereClause> isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterWhereClause> isarIdNotEqualTo(Id isarId) {
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

  QueryBuilder<Fiche, Fiche, QAfterWhereClause> isarIdGreaterThan(Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterWhereClause> isarIdLessThan(Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterWhereClause> isarIdBetween(
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

  QueryBuilder<Fiche, Fiche, QAfterWhereClause> idFicheEqualTo(String idFiche) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'idFiche',
        value: [idFiche],
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterWhereClause> idFicheNotEqualTo(
      String idFiche) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idFiche',
              lower: [],
              upper: [idFiche],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idFiche',
              lower: [idFiche],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idFiche',
              lower: [idFiche],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idFiche',
              lower: [],
              upper: [idFiche],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterWhereClause> idSrcEqualTo(String idSrc) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'idSrc',
        value: [idSrc],
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterWhereClause> idSrcNotEqualTo(String idSrc) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idSrc',
              lower: [],
              upper: [idSrc],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idSrc',
              lower: [idSrc],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idSrc',
              lower: [idSrc],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idSrc',
              lower: [],
              upper: [idSrc],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterWhereClause> dateCollecteEqualTo(
      DateTime dateCollecte) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'dateCollecte',
        value: [dateCollecte],
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterWhereClause> dateCollecteNotEqualTo(
      DateTime dateCollecte) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateCollecte',
              lower: [],
              upper: [dateCollecte],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateCollecte',
              lower: [dateCollecte],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateCollecte',
              lower: [dateCollecte],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateCollecte',
              lower: [],
              upper: [dateCollecte],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterWhereClause> dateCollecteGreaterThan(
    DateTime dateCollecte, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dateCollecte',
        lower: [dateCollecte],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterWhereClause> dateCollecteLessThan(
    DateTime dateCollecte, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dateCollecte',
        lower: [],
        upper: [dateCollecte],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterWhereClause> dateCollecteBetween(
    DateTime lowerDateCollecte,
    DateTime upperDateCollecte, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dateCollecte',
        lower: [lowerDateCollecte],
        includeLower: includeLower,
        upper: [upperDateCollecte],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterWhereClause> createdAtEqualTo(
      DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [createdAt],
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterWhereClause> createdAtNotEqualTo(
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

  QueryBuilder<Fiche, Fiche, QAfterWhereClause> createdAtGreaterThan(
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

  QueryBuilder<Fiche, Fiche, QAfterWhereClause> createdAtLessThan(
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

  QueryBuilder<Fiche, Fiche, QAfterWhereClause> createdAtBetween(
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

  QueryBuilder<Fiche, Fiche, QAfterWhereClause> updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'updatedAt',
        value: [null],
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterWhereClause> updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterWhereClause> updatedAtEqualTo(
      DateTime? updatedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'updatedAt',
        value: [updatedAt],
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterWhereClause> updatedAtNotEqualTo(
      DateTime? updatedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [],
              upper: [updatedAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [updatedAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [updatedAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [],
              upper: [updatedAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterWhereClause> updatedAtGreaterThan(
    DateTime? updatedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [updatedAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterWhereClause> updatedAtLessThan(
    DateTime? updatedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [],
        upper: [updatedAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterWhereClause> updatedAtBetween(
    DateTime? lowerUpdatedAt,
    DateTime? upperUpdatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [lowerUpdatedAt],
        includeLower: includeLower,
        upper: [upperUpdatedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension FicheQueryFilter on QueryBuilder<Fiche, Fiche, QFilterCondition> {
  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> commentaireIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'commentaire',
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> commentaireIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'commentaire',
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> commentaireEqualTo(
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

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> commentaireGreaterThan(
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

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> commentaireLessThan(
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

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> commentaireBetween(
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

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> commentaireStartsWith(
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

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> commentaireEndsWith(
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

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> commentaireContains(
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

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> commentaireMatches(
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

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> commentaireIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'commentaire',
        value: '',
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> commentaireIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'commentaire',
        value: '',
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> createdAtGreaterThan(
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

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> createdAtLessThan(
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

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> createdAtBetween(
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

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> dateCollecteEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateCollecte',
        value: value,
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> dateCollecteGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateCollecte',
        value: value,
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> dateCollecteLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateCollecte',
        value: value,
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> dateCollecteBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateCollecte',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> idFicheEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idFiche',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> idFicheGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idFiche',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> idFicheLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idFiche',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> idFicheBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idFiche',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> idFicheStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'idFiche',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> idFicheEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'idFiche',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> idFicheContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idFiche',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> idFicheMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idFiche',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> idFicheIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idFiche',
        value: '',
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> idFicheIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idFiche',
        value: '',
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> idSrcEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idSrc',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> idSrcGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idSrc',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> idSrcLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idSrc',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> idSrcBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idSrc',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> idSrcStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'idSrc',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> idSrcEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'idSrc',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> idSrcContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idSrc',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> idSrcMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idSrc',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> idSrcIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idSrc',
        value: '',
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> idSrcIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idSrc',
        value: '',
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> isCurrentEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCurrent',
        value: value,
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> isarIdGreaterThan(
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

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> isarIdLessThan(
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

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> isarIdBetween(
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

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> scoreInteretIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'scoreInteret',
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> scoreInteretIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'scoreInteret',
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> scoreInteretEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scoreInteret',
        value: value,
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> scoreInteretGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scoreInteret',
        value: value,
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> scoreInteretLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scoreInteret',
        value: value,
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> scoreInteretBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scoreInteret',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> syncStateEqualTo(
      SyncState value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncState',
        value: value,
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> syncStateGreaterThan(
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

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> syncStateLessThan(
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

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> syncStateBetween(
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

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> updatedAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> updatedAtGreaterThan(
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

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> updatedAtLessThan(
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

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> updatedAtBetween(
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

extension FicheQueryObject on QueryBuilder<Fiche, Fiche, QFilterCondition> {}

extension FicheQueryLinks on QueryBuilder<Fiche, Fiche, QFilterCondition> {
  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> source(
      FilterQuery<Source> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'source');
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> sourceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'source', 0, true, 0, true);
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> prospects(
      FilterQuery<Prospect> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'prospects');
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> prospectsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'prospects', length, true, length, true);
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> prospectsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'prospects', 0, true, 0, true);
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> prospectsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'prospects', 0, false, 999999, true);
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> prospectsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'prospects', 0, true, length, include);
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> prospectsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'prospects', length, include, 999999, true);
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterFilterCondition> prospectsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'prospects', lower, includeLower, upper, includeUpper);
    });
  }
}

extension FicheQuerySortBy on QueryBuilder<Fiche, Fiche, QSortBy> {
  QueryBuilder<Fiche, Fiche, QAfterSortBy> sortByCommentaire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commentaire', Sort.asc);
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterSortBy> sortByCommentaireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commentaire', Sort.desc);
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterSortBy> sortByDateCollecte() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCollecte', Sort.asc);
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterSortBy> sortByDateCollecteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCollecte', Sort.desc);
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterSortBy> sortByIdFiche() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idFiche', Sort.asc);
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterSortBy> sortByIdFicheDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idFiche', Sort.desc);
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterSortBy> sortByIdSrc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idSrc', Sort.asc);
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterSortBy> sortByIdSrcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idSrc', Sort.desc);
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterSortBy> sortByIsCurrent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCurrent', Sort.asc);
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterSortBy> sortByIsCurrentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCurrent', Sort.desc);
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterSortBy> sortByScoreInteret() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scoreInteret', Sort.asc);
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterSortBy> sortByScoreInteretDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scoreInteret', Sort.desc);
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterSortBy> sortBySyncState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.asc);
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterSortBy> sortBySyncStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.desc);
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension FicheQuerySortThenBy on QueryBuilder<Fiche, Fiche, QSortThenBy> {
  QueryBuilder<Fiche, Fiche, QAfterSortBy> thenByCommentaire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commentaire', Sort.asc);
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterSortBy> thenByCommentaireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commentaire', Sort.desc);
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterSortBy> thenByDateCollecte() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCollecte', Sort.asc);
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterSortBy> thenByDateCollecteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCollecte', Sort.desc);
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterSortBy> thenByIdFiche() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idFiche', Sort.asc);
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterSortBy> thenByIdFicheDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idFiche', Sort.desc);
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterSortBy> thenByIdSrc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idSrc', Sort.asc);
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterSortBy> thenByIdSrcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idSrc', Sort.desc);
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterSortBy> thenByIsCurrent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCurrent', Sort.asc);
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterSortBy> thenByIsCurrentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCurrent', Sort.desc);
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterSortBy> thenByScoreInteret() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scoreInteret', Sort.asc);
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterSortBy> thenByScoreInteretDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scoreInteret', Sort.desc);
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterSortBy> thenBySyncState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.asc);
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterSortBy> thenBySyncStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.desc);
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Fiche, Fiche, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension FicheQueryWhereDistinct on QueryBuilder<Fiche, Fiche, QDistinct> {
  QueryBuilder<Fiche, Fiche, QDistinct> distinctByCommentaire(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'commentaire', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Fiche, Fiche, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<Fiche, Fiche, QDistinct> distinctByDateCollecte() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateCollecte');
    });
  }

  QueryBuilder<Fiche, Fiche, QDistinct> distinctByIdFiche(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idFiche', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Fiche, Fiche, QDistinct> distinctByIdSrc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idSrc', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Fiche, Fiche, QDistinct> distinctByIsCurrent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCurrent');
    });
  }

  QueryBuilder<Fiche, Fiche, QDistinct> distinctByScoreInteret() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scoreInteret');
    });
  }

  QueryBuilder<Fiche, Fiche, QDistinct> distinctBySyncState() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncState');
    });
  }

  QueryBuilder<Fiche, Fiche, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension FicheQueryProperty on QueryBuilder<Fiche, Fiche, QQueryProperty> {
  QueryBuilder<Fiche, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<Fiche, String?, QQueryOperations> commentaireProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'commentaire');
    });
  }

  QueryBuilder<Fiche, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<Fiche, DateTime, QQueryOperations> dateCollecteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateCollecte');
    });
  }

  QueryBuilder<Fiche, String, QQueryOperations> idFicheProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idFiche');
    });
  }

  QueryBuilder<Fiche, String, QQueryOperations> idSrcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idSrc');
    });
  }

  QueryBuilder<Fiche, bool, QQueryOperations> isCurrentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCurrent');
    });
  }

  QueryBuilder<Fiche, int?, QQueryOperations> scoreInteretProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scoreInteret');
    });
  }

  QueryBuilder<Fiche, SyncState, QQueryOperations> syncStateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncState');
    });
  }

  QueryBuilder<Fiche, DateTime?, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
