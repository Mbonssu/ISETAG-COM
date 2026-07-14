// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../specialite.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSpecialiteCollection on Isar {
  IsarCollection<Specialite> get specialites => this.collection();
}

const SpecialiteSchema = CollectionSchema(
  name: r'Specialite',
  id: -2223080552357303567,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'description': PropertySchema(
      id: 1,
      name: r'description',
      type: IsarType.string,
    ),
    r'idSpecialite': PropertySchema(
      id: 2,
      name: r'idSpecialite',
      type: IsarType.string,
    ),
    r'libelleSpecialite': PropertySchema(
      id: 3,
      name: r'libelleSpecialite',
      type: IsarType.string,
    ),
    r'syncState': PropertySchema(
      id: 4,
      name: r'syncState',
      type: IsarType.byte,
      enumMap: _SpecialitesyncStateEnumValueMap,
    ),
    r'updatedAt': PropertySchema(
      id: 5,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _specialiteEstimateSize,
  serialize: _specialiteSerialize,
  deserialize: _specialiteDeserialize,
  deserializeProp: _specialiteDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'idSpecialite': IndexSchema(
      id: 1402599325489044525,
      name: r'idSpecialite',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'idSpecialite',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'libelleSpecialite': IndexSchema(
      id: -1047299829317154103,
      name: r'libelleSpecialite',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'libelleSpecialite',
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
    r'interets': LinkSchema(
      id: 622436858302323631,
      name: r'interets',
      target: r'InteretFiliere',
      single: false,
      linkName: r'specialite',
    )
  },
  embeddedSchemas: {},
  getId: _specialiteGetId,
  getLinks: _specialiteGetLinks,
  attach: _specialiteAttach,
  version: '3.1.0+1',
);

int _specialiteEstimateSize(
  Specialite object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.description;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.idSpecialite.length * 3;
  bytesCount += 3 + object.libelleSpecialite.length * 3;
  return bytesCount;
}

void _specialiteSerialize(
  Specialite object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.description);
  writer.writeString(offsets[2], object.idSpecialite);
  writer.writeString(offsets[3], object.libelleSpecialite);
  writer.writeByte(offsets[4], object.syncState.index);
  writer.writeDateTime(offsets[5], object.updatedAt);
}

Specialite _specialiteDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Specialite(
    createdAt: reader.readDateTimeOrNull(offsets[0]),
    description: reader.readStringOrNull(offsets[1]),
    idSpecialite: reader.readString(offsets[2]),
    libelleSpecialite: reader.readString(offsets[3]),
    syncState:
        _SpecialitesyncStateValueEnumMap[reader.readByteOrNull(offsets[4])] ??
            SyncState.pending,
  );
  object.isarId = id;
  object.updatedAt = reader.readDateTimeOrNull(offsets[5]);
  return object;
}

P _specialiteDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (_SpecialitesyncStateValueEnumMap[reader.readByteOrNull(offset)] ??
          SyncState.pending) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _SpecialitesyncStateEnumValueMap = {
  'pending': 0,
  'syncing': 1,
  'synced': 2,
  'failed': 3,
};
const _SpecialitesyncStateValueEnumMap = {
  0: SyncState.pending,
  1: SyncState.syncing,
  2: SyncState.synced,
  3: SyncState.failed,
};

Id _specialiteGetId(Specialite object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _specialiteGetLinks(Specialite object) {
  return [object.interets];
}

void _specialiteAttach(IsarCollection<dynamic> col, Id id, Specialite object) {
  object.isarId = id;
  object.interets
      .attach(col, col.isar.collection<InteretFiliere>(), r'interets', id);
}

extension SpecialiteByIndex on IsarCollection<Specialite> {
  Future<Specialite?> getByIdSpecialite(String idSpecialite) {
    return getByIndex(r'idSpecialite', [idSpecialite]);
  }

  Specialite? getByIdSpecialiteSync(String idSpecialite) {
    return getByIndexSync(r'idSpecialite', [idSpecialite]);
  }

  Future<bool> deleteByIdSpecialite(String idSpecialite) {
    return deleteByIndex(r'idSpecialite', [idSpecialite]);
  }

  bool deleteByIdSpecialiteSync(String idSpecialite) {
    return deleteByIndexSync(r'idSpecialite', [idSpecialite]);
  }

  Future<List<Specialite?>> getAllByIdSpecialite(
      List<String> idSpecialiteValues) {
    final values = idSpecialiteValues.map((e) => [e]).toList();
    return getAllByIndex(r'idSpecialite', values);
  }

  List<Specialite?> getAllByIdSpecialiteSync(List<String> idSpecialiteValues) {
    final values = idSpecialiteValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'idSpecialite', values);
  }

  Future<int> deleteAllByIdSpecialite(List<String> idSpecialiteValues) {
    final values = idSpecialiteValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'idSpecialite', values);
  }

  int deleteAllByIdSpecialiteSync(List<String> idSpecialiteValues) {
    final values = idSpecialiteValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'idSpecialite', values);
  }

  Future<Id> putByIdSpecialite(Specialite object) {
    return putByIndex(r'idSpecialite', object);
  }

  Id putByIdSpecialiteSync(Specialite object, {bool saveLinks = true}) {
    return putByIndexSync(r'idSpecialite', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByIdSpecialite(List<Specialite> objects) {
    return putAllByIndex(r'idSpecialite', objects);
  }

  List<Id> putAllByIdSpecialiteSync(List<Specialite> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'idSpecialite', objects, saveLinks: saveLinks);
  }
}

extension SpecialiteQueryWhereSort
    on QueryBuilder<Specialite, Specialite, QWhere> {
  QueryBuilder<Specialite, Specialite, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterWhere> anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterWhere> anyUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'updatedAt'),
      );
    });
  }
}

extension SpecialiteQueryWhere
    on QueryBuilder<Specialite, Specialite, QWhereClause> {
  QueryBuilder<Specialite, Specialite, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterWhereClause> isarIdNotEqualTo(
      Id isarId) {
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

  QueryBuilder<Specialite, Specialite, QAfterWhereClause> isarIdGreaterThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterWhereClause> isarIdBetween(
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

  QueryBuilder<Specialite, Specialite, QAfterWhereClause> idSpecialiteEqualTo(
      String idSpecialite) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'idSpecialite',
        value: [idSpecialite],
      ));
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterWhereClause>
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

  QueryBuilder<Specialite, Specialite, QAfterWhereClause>
      libelleSpecialiteEqualTo(String libelleSpecialite) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'libelleSpecialite',
        value: [libelleSpecialite],
      ));
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterWhereClause>
      libelleSpecialiteNotEqualTo(String libelleSpecialite) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'libelleSpecialite',
              lower: [],
              upper: [libelleSpecialite],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'libelleSpecialite',
              lower: [libelleSpecialite],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'libelleSpecialite',
              lower: [libelleSpecialite],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'libelleSpecialite',
              lower: [],
              upper: [libelleSpecialite],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterWhereClause> createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [null],
      ));
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterWhereClause> createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterWhereClause> createdAtEqualTo(
      DateTime? createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [createdAt],
      ));
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterWhereClause> createdAtNotEqualTo(
      DateTime? createdAt) {
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

  QueryBuilder<Specialite, Specialite, QAfterWhereClause> createdAtGreaterThan(
    DateTime? createdAt, {
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

  QueryBuilder<Specialite, Specialite, QAfterWhereClause> createdAtLessThan(
    DateTime? createdAt, {
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

  QueryBuilder<Specialite, Specialite, QAfterWhereClause> createdAtBetween(
    DateTime? lowerCreatedAt,
    DateTime? upperCreatedAt, {
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

  QueryBuilder<Specialite, Specialite, QAfterWhereClause> updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'updatedAt',
        value: [null],
      ));
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterWhereClause> updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterWhereClause> updatedAtEqualTo(
      DateTime? updatedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'updatedAt',
        value: [updatedAt],
      ));
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterWhereClause> updatedAtNotEqualTo(
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

  QueryBuilder<Specialite, Specialite, QAfterWhereClause> updatedAtGreaterThan(
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

  QueryBuilder<Specialite, Specialite, QAfterWhereClause> updatedAtLessThan(
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

  QueryBuilder<Specialite, Specialite, QAfterWhereClause> updatedAtBetween(
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

extension SpecialiteQueryFilter
    on QueryBuilder<Specialite, Specialite, QFilterCondition> {
  QueryBuilder<Specialite, Specialite, QAfterFilterCondition>
      createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition>
      createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition> createdAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime? value, {
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

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition> createdAtLessThan(
    DateTime? value, {
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

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition> createdAtBetween(
    DateTime? lower,
    DateTime? upper, {
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

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition>
      descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition>
      descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition>
      descriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition>
      descriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition>
      descriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition>
      descriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition>
      descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition>
      descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition>
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

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition>
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

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition>
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

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition>
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

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition>
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

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition>
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

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition>
      idSpecialiteContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idSpecialite',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition>
      idSpecialiteMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idSpecialite',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition>
      idSpecialiteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idSpecialite',
        value: '',
      ));
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition>
      idSpecialiteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idSpecialite',
        value: '',
      ));
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition> isarIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition> isarIdGreaterThan(
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

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition> isarIdLessThan(
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

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition> isarIdBetween(
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

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition>
      libelleSpecialiteEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'libelleSpecialite',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition>
      libelleSpecialiteGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'libelleSpecialite',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition>
      libelleSpecialiteLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'libelleSpecialite',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition>
      libelleSpecialiteBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'libelleSpecialite',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition>
      libelleSpecialiteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'libelleSpecialite',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition>
      libelleSpecialiteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'libelleSpecialite',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition>
      libelleSpecialiteContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'libelleSpecialite',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition>
      libelleSpecialiteMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'libelleSpecialite',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition>
      libelleSpecialiteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'libelleSpecialite',
        value: '',
      ));
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition>
      libelleSpecialiteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'libelleSpecialite',
        value: '',
      ));
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition> syncStateEqualTo(
      SyncState value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncState',
        value: value,
      ));
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition>
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

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition> syncStateLessThan(
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

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition> syncStateBetween(
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

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition>
      updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition>
      updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition> updatedAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition>
      updatedAtGreaterThan(
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

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition> updatedAtLessThan(
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

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition> updatedAtBetween(
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

extension SpecialiteQueryObject
    on QueryBuilder<Specialite, Specialite, QFilterCondition> {}

extension SpecialiteQueryLinks
    on QueryBuilder<Specialite, Specialite, QFilterCondition> {
  QueryBuilder<Specialite, Specialite, QAfterFilterCondition> interets(
      FilterQuery<InteretFiliere> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'interets');
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition>
      interetsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'interets', length, true, length, true);
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition>
      interetsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'interets', 0, true, 0, true);
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition>
      interetsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'interets', 0, false, 999999, true);
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition>
      interetsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'interets', 0, true, length, include);
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition>
      interetsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'interets', length, include, 999999, true);
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterFilterCondition>
      interetsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'interets', lower, includeLower, upper, includeUpper);
    });
  }
}

extension SpecialiteQuerySortBy
    on QueryBuilder<Specialite, Specialite, QSortBy> {
  QueryBuilder<Specialite, Specialite, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterSortBy> sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterSortBy> sortByIdSpecialite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idSpecialite', Sort.asc);
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterSortBy> sortByIdSpecialiteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idSpecialite', Sort.desc);
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterSortBy> sortByLibelleSpecialite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libelleSpecialite', Sort.asc);
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterSortBy>
      sortByLibelleSpecialiteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libelleSpecialite', Sort.desc);
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterSortBy> sortBySyncState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.asc);
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterSortBy> sortBySyncStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.desc);
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension SpecialiteQuerySortThenBy
    on QueryBuilder<Specialite, Specialite, QSortThenBy> {
  QueryBuilder<Specialite, Specialite, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterSortBy> thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterSortBy> thenByIdSpecialite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idSpecialite', Sort.asc);
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterSortBy> thenByIdSpecialiteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idSpecialite', Sort.desc);
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterSortBy> thenByLibelleSpecialite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libelleSpecialite', Sort.asc);
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterSortBy>
      thenByLibelleSpecialiteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libelleSpecialite', Sort.desc);
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterSortBy> thenBySyncState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.asc);
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterSortBy> thenBySyncStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.desc);
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Specialite, Specialite, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension SpecialiteQueryWhereDistinct
    on QueryBuilder<Specialite, Specialite, QDistinct> {
  QueryBuilder<Specialite, Specialite, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<Specialite, Specialite, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Specialite, Specialite, QDistinct> distinctByIdSpecialite(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idSpecialite', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Specialite, Specialite, QDistinct> distinctByLibelleSpecialite(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libelleSpecialite',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Specialite, Specialite, QDistinct> distinctBySyncState() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncState');
    });
  }

  QueryBuilder<Specialite, Specialite, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension SpecialiteQueryProperty
    on QueryBuilder<Specialite, Specialite, QQueryProperty> {
  QueryBuilder<Specialite, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<Specialite, DateTime?, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<Specialite, String?, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<Specialite, String, QQueryOperations> idSpecialiteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idSpecialite');
    });
  }

  QueryBuilder<Specialite, String, QQueryOperations>
      libelleSpecialiteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libelleSpecialite');
    });
  }

  QueryBuilder<Specialite, SyncState, QQueryOperations> syncStateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncState');
    });
  }

  QueryBuilder<Specialite, DateTime?, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
