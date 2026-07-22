// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../relance.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetRelanceCollection on Isar {
  IsarCollection<Relance> get relances => this.collection();
}

const RelanceSchema = CollectionSchema(
  name: r'Relance',
  id: -5093631459962684914,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'dateRelance': PropertySchema(
      id: 1,
      name: r'dateRelance',
      type: IsarType.dateTime,
    ),
    r'description': PropertySchema(
      id: 2,
      name: r'description',
      type: IsarType.string,
    ),
    r'idProspect': PropertySchema(
      id: 3,
      name: r'idProspect',
      type: IsarType.string,
    ),
    r'idRelance': PropertySchema(
      id: 4,
      name: r'idRelance',
      type: IsarType.string,
    ),
    r'sujet': PropertySchema(
      id: 5,
      name: r'sujet',
      type: IsarType.string,
    ),
    r'syncState': PropertySchema(
      id: 6,
      name: r'syncState',
      type: IsarType.byte,
      enumMap: _RelancesyncStateEnumValueMap,
    ),
    r'updatedAt': PropertySchema(
      id: 7,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _relanceEstimateSize,
  serialize: _relanceSerialize,
  deserialize: _relanceDeserialize,
  deserializeProp: _relanceDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'idRelance': IndexSchema(
      id: -9025773614017932817,
      name: r'idRelance',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'idRelance',
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
    r'dateRelance': IndexSchema(
      id: 8982761389709581559,
      name: r'dateRelance',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'dateRelance',
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
      id: 1179170612130135330,
      name: r'prospect',
      target: r'Prospect',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _relanceGetId,
  getLinks: _relanceGetLinks,
  attach: _relanceAttach,
  version: '3.3.2',
);

int _relanceEstimateSize(
  Relance object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.description.length * 3;
  bytesCount += 3 + object.idProspect.length * 3;
  bytesCount += 3 + object.idRelance.length * 3;
  bytesCount += 3 + object.sujet.length * 3;
  return bytesCount;
}

void _relanceSerialize(
  Relance object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeDateTime(offsets[1], object.dateRelance);
  writer.writeString(offsets[2], object.description);
  writer.writeString(offsets[3], object.idProspect);
  writer.writeString(offsets[4], object.idRelance);
  writer.writeString(offsets[5], object.sujet);
  writer.writeByte(offsets[6], object.syncState.index);
  writer.writeDateTime(offsets[7], object.updatedAt);
}

Relance _relanceDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Relance(
    createdAt: reader.readDateTimeOrNull(offsets[0]),
    dateRelance: reader.readDateTime(offsets[1]),
    description: reader.readString(offsets[2]),
    idProspect: reader.readString(offsets[3]),
    idRelance: reader.readString(offsets[4]),
    sujet: reader.readString(offsets[5]),
    syncState:
        _RelancesyncStateValueEnumMap[reader.readByteOrNull(offsets[6])] ??
            SyncState.pending,
    updatedAt: reader.readDateTimeOrNull(offsets[7]),
  );
  object.isarId = id;
  return object;
}

P _relanceDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (_RelancesyncStateValueEnumMap[reader.readByteOrNull(offset)] ??
          SyncState.pending) as P;
    case 7:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _RelancesyncStateEnumValueMap = {
  'pending': 0,
  'syncing': 1,
  'synced': 2,
  'failed': 3,
  'toUpdate': 4,
};
const _RelancesyncStateValueEnumMap = {
  0: SyncState.pending,
  1: SyncState.syncing,
  2: SyncState.synced,
  3: SyncState.failed,
  4: SyncState.toUpdate,
};

Id _relanceGetId(Relance object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _relanceGetLinks(Relance object) {
  return [object.prospect];
}

void _relanceAttach(IsarCollection<dynamic> col, Id id, Relance object) {
  object.isarId = id;
  object.prospect.attach(col, col.isar.collection<Prospect>(), r'prospect', id);
}

extension RelanceByIndex on IsarCollection<Relance> {
  Future<Relance?> getByIdRelance(String idRelance) {
    return getByIndex(r'idRelance', [idRelance]);
  }

  Relance? getByIdRelanceSync(String idRelance) {
    return getByIndexSync(r'idRelance', [idRelance]);
  }

  Future<bool> deleteByIdRelance(String idRelance) {
    return deleteByIndex(r'idRelance', [idRelance]);
  }

  bool deleteByIdRelanceSync(String idRelance) {
    return deleteByIndexSync(r'idRelance', [idRelance]);
  }

  Future<List<Relance?>> getAllByIdRelance(List<String> idRelanceValues) {
    final values = idRelanceValues.map((e) => [e]).toList();
    return getAllByIndex(r'idRelance', values);
  }

  List<Relance?> getAllByIdRelanceSync(List<String> idRelanceValues) {
    final values = idRelanceValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'idRelance', values);
  }

  Future<int> deleteAllByIdRelance(List<String> idRelanceValues) {
    final values = idRelanceValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'idRelance', values);
  }

  int deleteAllByIdRelanceSync(List<String> idRelanceValues) {
    final values = idRelanceValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'idRelance', values);
  }

  Future<Id> putByIdRelance(Relance object) {
    return putByIndex(r'idRelance', object);
  }

  Id putByIdRelanceSync(Relance object, {bool saveLinks = true}) {
    return putByIndexSync(r'idRelance', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByIdRelance(List<Relance> objects) {
    return putAllByIndex(r'idRelance', objects);
  }

  List<Id> putAllByIdRelanceSync(List<Relance> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'idRelance', objects, saveLinks: saveLinks);
  }
}

extension RelanceQueryWhereSort on QueryBuilder<Relance, Relance, QWhere> {
  QueryBuilder<Relance, Relance, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Relance, Relance, QAfterWhere> anyDateRelance() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'dateRelance'),
      );
    });
  }

  QueryBuilder<Relance, Relance, QAfterWhere> anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }
}

extension RelanceQueryWhere on QueryBuilder<Relance, Relance, QWhereClause> {
  QueryBuilder<Relance, Relance, QAfterWhereClause> isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterWhereClause> isarIdNotEqualTo(
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

  QueryBuilder<Relance, Relance, QAfterWhereClause> isarIdGreaterThan(Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<Relance, Relance, QAfterWhereClause> isarIdLessThan(Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<Relance, Relance, QAfterWhereClause> isarIdBetween(
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

  QueryBuilder<Relance, Relance, QAfterWhereClause> idRelanceEqualTo(
      String idRelance) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'idRelance',
        value: [idRelance],
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterWhereClause> idRelanceNotEqualTo(
      String idRelance) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idRelance',
              lower: [],
              upper: [idRelance],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idRelance',
              lower: [idRelance],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idRelance',
              lower: [idRelance],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idRelance',
              lower: [],
              upper: [idRelance],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Relance, Relance, QAfterWhereClause> idProspectEqualTo(
      String idProspect) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'idProspect',
        value: [idProspect],
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterWhereClause> idProspectNotEqualTo(
      String idProspect) {
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

  QueryBuilder<Relance, Relance, QAfterWhereClause> dateRelanceEqualTo(
      DateTime dateRelance) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'dateRelance',
        value: [dateRelance],
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterWhereClause> dateRelanceNotEqualTo(
      DateTime dateRelance) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateRelance',
              lower: [],
              upper: [dateRelance],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateRelance',
              lower: [dateRelance],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateRelance',
              lower: [dateRelance],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateRelance',
              lower: [],
              upper: [dateRelance],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Relance, Relance, QAfterWhereClause> dateRelanceGreaterThan(
    DateTime dateRelance, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dateRelance',
        lower: [dateRelance],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterWhereClause> dateRelanceLessThan(
    DateTime dateRelance, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dateRelance',
        lower: [],
        upper: [dateRelance],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterWhereClause> dateRelanceBetween(
    DateTime lowerDateRelance,
    DateTime upperDateRelance, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dateRelance',
        lower: [lowerDateRelance],
        includeLower: includeLower,
        upper: [upperDateRelance],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterWhereClause> createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [null],
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterWhereClause> createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterWhereClause> createdAtEqualTo(
      DateTime? createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [createdAt],
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterWhereClause> createdAtNotEqualTo(
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

  QueryBuilder<Relance, Relance, QAfterWhereClause> createdAtGreaterThan(
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

  QueryBuilder<Relance, Relance, QAfterWhereClause> createdAtLessThan(
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

  QueryBuilder<Relance, Relance, QAfterWhereClause> createdAtBetween(
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
}

extension RelanceQueryFilter
    on QueryBuilder<Relance, Relance, QFilterCondition> {
  QueryBuilder<Relance, Relance, QAfterFilterCondition> createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterFilterCondition> createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterFilterCondition> createdAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterFilterCondition> createdAtGreaterThan(
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

  QueryBuilder<Relance, Relance, QAfterFilterCondition> createdAtLessThan(
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

  QueryBuilder<Relance, Relance, QAfterFilterCondition> createdAtBetween(
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

  QueryBuilder<Relance, Relance, QAfterFilterCondition> dateRelanceEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateRelance',
        value: value,
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterFilterCondition> dateRelanceGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateRelance',
        value: value,
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterFilterCondition> dateRelanceLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateRelance',
        value: value,
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterFilterCondition> dateRelanceBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateRelance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterFilterCondition> descriptionEqualTo(
    String value, {
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

  QueryBuilder<Relance, Relance, QAfterFilterCondition> descriptionGreaterThan(
    String value, {
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

  QueryBuilder<Relance, Relance, QAfterFilterCondition> descriptionLessThan(
    String value, {
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

  QueryBuilder<Relance, Relance, QAfterFilterCondition> descriptionBetween(
    String lower,
    String upper, {
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

  QueryBuilder<Relance, Relance, QAfterFilterCondition> descriptionStartsWith(
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

  QueryBuilder<Relance, Relance, QAfterFilterCondition> descriptionEndsWith(
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

  QueryBuilder<Relance, Relance, QAfterFilterCondition> descriptionContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterFilterCondition> descriptionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterFilterCondition> descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterFilterCondition> idProspectEqualTo(
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

  QueryBuilder<Relance, Relance, QAfterFilterCondition> idProspectGreaterThan(
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

  QueryBuilder<Relance, Relance, QAfterFilterCondition> idProspectLessThan(
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

  QueryBuilder<Relance, Relance, QAfterFilterCondition> idProspectBetween(
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

  QueryBuilder<Relance, Relance, QAfterFilterCondition> idProspectStartsWith(
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

  QueryBuilder<Relance, Relance, QAfterFilterCondition> idProspectEndsWith(
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

  QueryBuilder<Relance, Relance, QAfterFilterCondition> idProspectContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idProspect',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterFilterCondition> idProspectMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idProspect',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterFilterCondition> idProspectIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idProspect',
        value: '',
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterFilterCondition> idProspectIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idProspect',
        value: '',
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterFilterCondition> idRelanceEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idRelance',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterFilterCondition> idRelanceGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idRelance',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterFilterCondition> idRelanceLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idRelance',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterFilterCondition> idRelanceBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idRelance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterFilterCondition> idRelanceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'idRelance',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterFilterCondition> idRelanceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'idRelance',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterFilterCondition> idRelanceContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idRelance',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterFilterCondition> idRelanceMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idRelance',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterFilterCondition> idRelanceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idRelance',
        value: '',
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterFilterCondition> idRelanceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idRelance',
        value: '',
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterFilterCondition> isarIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterFilterCondition> isarIdGreaterThan(
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

  QueryBuilder<Relance, Relance, QAfterFilterCondition> isarIdLessThan(
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

  QueryBuilder<Relance, Relance, QAfterFilterCondition> isarIdBetween(
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

  QueryBuilder<Relance, Relance, QAfterFilterCondition> sujetEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sujet',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterFilterCondition> sujetGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sujet',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterFilterCondition> sujetLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sujet',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterFilterCondition> sujetBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sujet',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterFilterCondition> sujetStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sujet',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterFilterCondition> sujetEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sujet',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterFilterCondition> sujetContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sujet',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterFilterCondition> sujetMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sujet',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterFilterCondition> sujetIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sujet',
        value: '',
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterFilterCondition> sujetIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sujet',
        value: '',
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterFilterCondition> syncStateEqualTo(
      SyncState value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncState',
        value: value,
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterFilterCondition> syncStateGreaterThan(
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

  QueryBuilder<Relance, Relance, QAfterFilterCondition> syncStateLessThan(
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

  QueryBuilder<Relance, Relance, QAfterFilterCondition> syncStateBetween(
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

  QueryBuilder<Relance, Relance, QAfterFilterCondition> updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterFilterCondition> updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterFilterCondition> updatedAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Relance, Relance, QAfterFilterCondition> updatedAtGreaterThan(
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

  QueryBuilder<Relance, Relance, QAfterFilterCondition> updatedAtLessThan(
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

  QueryBuilder<Relance, Relance, QAfterFilterCondition> updatedAtBetween(
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

extension RelanceQueryObject
    on QueryBuilder<Relance, Relance, QFilterCondition> {}

extension RelanceQueryLinks
    on QueryBuilder<Relance, Relance, QFilterCondition> {
  QueryBuilder<Relance, Relance, QAfterFilterCondition> prospect(
      FilterQuery<Prospect> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'prospect');
    });
  }

  QueryBuilder<Relance, Relance, QAfterFilterCondition> prospectIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'prospect', 0, true, 0, true);
    });
  }
}

extension RelanceQuerySortBy on QueryBuilder<Relance, Relance, QSortBy> {
  QueryBuilder<Relance, Relance, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Relance, Relance, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Relance, Relance, QAfterSortBy> sortByDateRelance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateRelance', Sort.asc);
    });
  }

  QueryBuilder<Relance, Relance, QAfterSortBy> sortByDateRelanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateRelance', Sort.desc);
    });
  }

  QueryBuilder<Relance, Relance, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<Relance, Relance, QAfterSortBy> sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<Relance, Relance, QAfterSortBy> sortByIdProspect() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idProspect', Sort.asc);
    });
  }

  QueryBuilder<Relance, Relance, QAfterSortBy> sortByIdProspectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idProspect', Sort.desc);
    });
  }

  QueryBuilder<Relance, Relance, QAfterSortBy> sortByIdRelance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idRelance', Sort.asc);
    });
  }

  QueryBuilder<Relance, Relance, QAfterSortBy> sortByIdRelanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idRelance', Sort.desc);
    });
  }

  QueryBuilder<Relance, Relance, QAfterSortBy> sortBySujet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sujet', Sort.asc);
    });
  }

  QueryBuilder<Relance, Relance, QAfterSortBy> sortBySujetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sujet', Sort.desc);
    });
  }

  QueryBuilder<Relance, Relance, QAfterSortBy> sortBySyncState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.asc);
    });
  }

  QueryBuilder<Relance, Relance, QAfterSortBy> sortBySyncStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.desc);
    });
  }

  QueryBuilder<Relance, Relance, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Relance, Relance, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension RelanceQuerySortThenBy
    on QueryBuilder<Relance, Relance, QSortThenBy> {
  QueryBuilder<Relance, Relance, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Relance, Relance, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Relance, Relance, QAfterSortBy> thenByDateRelance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateRelance', Sort.asc);
    });
  }

  QueryBuilder<Relance, Relance, QAfterSortBy> thenByDateRelanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateRelance', Sort.desc);
    });
  }

  QueryBuilder<Relance, Relance, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<Relance, Relance, QAfterSortBy> thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<Relance, Relance, QAfterSortBy> thenByIdProspect() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idProspect', Sort.asc);
    });
  }

  QueryBuilder<Relance, Relance, QAfterSortBy> thenByIdProspectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idProspect', Sort.desc);
    });
  }

  QueryBuilder<Relance, Relance, QAfterSortBy> thenByIdRelance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idRelance', Sort.asc);
    });
  }

  QueryBuilder<Relance, Relance, QAfterSortBy> thenByIdRelanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idRelance', Sort.desc);
    });
  }

  QueryBuilder<Relance, Relance, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<Relance, Relance, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<Relance, Relance, QAfterSortBy> thenBySujet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sujet', Sort.asc);
    });
  }

  QueryBuilder<Relance, Relance, QAfterSortBy> thenBySujetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sujet', Sort.desc);
    });
  }

  QueryBuilder<Relance, Relance, QAfterSortBy> thenBySyncState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.asc);
    });
  }

  QueryBuilder<Relance, Relance, QAfterSortBy> thenBySyncStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.desc);
    });
  }

  QueryBuilder<Relance, Relance, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Relance, Relance, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension RelanceQueryWhereDistinct
    on QueryBuilder<Relance, Relance, QDistinct> {
  QueryBuilder<Relance, Relance, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<Relance, Relance, QDistinct> distinctByDateRelance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateRelance');
    });
  }

  QueryBuilder<Relance, Relance, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Relance, Relance, QDistinct> distinctByIdProspect(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idProspect', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Relance, Relance, QDistinct> distinctByIdRelance(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idRelance', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Relance, Relance, QDistinct> distinctBySujet(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sujet', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Relance, Relance, QDistinct> distinctBySyncState() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncState');
    });
  }

  QueryBuilder<Relance, Relance, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension RelanceQueryProperty
    on QueryBuilder<Relance, Relance, QQueryProperty> {
  QueryBuilder<Relance, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<Relance, DateTime?, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<Relance, DateTime, QQueryOperations> dateRelanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateRelance');
    });
  }

  QueryBuilder<Relance, String, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<Relance, String, QQueryOperations> idProspectProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idProspect');
    });
  }

  QueryBuilder<Relance, String, QQueryOperations> idRelanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idRelance');
    });
  }

  QueryBuilder<Relance, String, QQueryOperations> sujetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sujet');
    });
  }

  QueryBuilder<Relance, SyncState, QQueryOperations> syncStateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncState');
    });
  }

  QueryBuilder<Relance, DateTime?, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
