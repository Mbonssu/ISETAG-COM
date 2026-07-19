// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../source.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSourceCollection on Isar {
  IsarCollection<Source> get sources => this.collection();
}

const SourceSchema = CollectionSchema(
  name: r'Source',
  id: 1877768871581930899,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'idSource': PropertySchema(
      id: 1,
      name: r'idSource',
      type: IsarType.string,
    ),
    r'libelleSource': PropertySchema(
      id: 2,
      name: r'libelleSource',
      type: IsarType.string,
    ),
    r'syncState': PropertySchema(
      id: 3,
      name: r'syncState',
      type: IsarType.byte,
      enumMap: _SourcesyncStateEnumValueMap,
    ),
    r'updatedAt': PropertySchema(
      id: 4,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _sourceEstimateSize,
  serialize: _sourceSerialize,
  deserialize: _sourceDeserialize,
  deserializeProp: _sourceDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'idSource': IndexSchema(
      id: -3244391196164830483,
      name: r'idSource',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'idSource',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'libelleSource': IndexSchema(
      id: -4853023707881506497,
      name: r'libelleSource',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'libelleSource',
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
    r'fiches': LinkSchema(
      id: 6864728480815642963,
      name: r'fiches',
      target: r'Fiche',
      single: false,
      linkName: r'source',
    )
  },
  embeddedSchemas: {},
  getId: _sourceGetId,
  getLinks: _sourceGetLinks,
  attach: _sourceAttach,
  version: '3.3.2',
);

int _sourceEstimateSize(
  Source object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.idSource.length * 3;
  bytesCount += 3 + object.libelleSource.length * 3;
  return bytesCount;
}

void _sourceSerialize(
  Source object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.idSource);
  writer.writeString(offsets[2], object.libelleSource);
  writer.writeByte(offsets[3], object.syncState.index);
  writer.writeDateTime(offsets[4], object.updatedAt);
}

Source _sourceDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Source(
    createdAt: reader.readDateTime(offsets[0]),
    idSource: reader.readString(offsets[1]),
    libelleSource: reader.readString(offsets[2]),
    syncState:
        _SourcesyncStateValueEnumMap[reader.readByteOrNull(offsets[3])] ??
            SyncState.pending,
  );
  object.isarId = id;
  object.updatedAt = reader.readDateTimeOrNull(offsets[4]);
  return object;
}

P _sourceDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (_SourcesyncStateValueEnumMap[reader.readByteOrNull(offset)] ??
          SyncState.pending) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _SourcesyncStateEnumValueMap = {
  'pending': 0,
  'syncing': 1,
  'synced': 2,
  'failed': 3,
  'toUpdate': 4,
};
const _SourcesyncStateValueEnumMap = {
  0: SyncState.pending,
  1: SyncState.syncing,
  2: SyncState.synced,
  3: SyncState.failed,
  4: SyncState.toUpdate,
};

Id _sourceGetId(Source object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _sourceGetLinks(Source object) {
  return [object.fiches];
}

void _sourceAttach(IsarCollection<dynamic> col, Id id, Source object) {
  object.isarId = id;
  object.fiches.attach(col, col.isar.collection<Fiche>(), r'fiches', id);
}

extension SourceByIndex on IsarCollection<Source> {
  Future<Source?> getByIdSource(String idSource) {
    return getByIndex(r'idSource', [idSource]);
  }

  Source? getByIdSourceSync(String idSource) {
    return getByIndexSync(r'idSource', [idSource]);
  }

  Future<bool> deleteByIdSource(String idSource) {
    return deleteByIndex(r'idSource', [idSource]);
  }

  bool deleteByIdSourceSync(String idSource) {
    return deleteByIndexSync(r'idSource', [idSource]);
  }

  Future<List<Source?>> getAllByIdSource(List<String> idSourceValues) {
    final values = idSourceValues.map((e) => [e]).toList();
    return getAllByIndex(r'idSource', values);
  }

  List<Source?> getAllByIdSourceSync(List<String> idSourceValues) {
    final values = idSourceValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'idSource', values);
  }

  Future<int> deleteAllByIdSource(List<String> idSourceValues) {
    final values = idSourceValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'idSource', values);
  }

  int deleteAllByIdSourceSync(List<String> idSourceValues) {
    final values = idSourceValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'idSource', values);
  }

  Future<Id> putByIdSource(Source object) {
    return putByIndex(r'idSource', object);
  }

  Id putByIdSourceSync(Source object, {bool saveLinks = true}) {
    return putByIndexSync(r'idSource', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByIdSource(List<Source> objects) {
    return putAllByIndex(r'idSource', objects);
  }

  List<Id> putAllByIdSourceSync(List<Source> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'idSource', objects, saveLinks: saveLinks);
  }
}

extension SourceQueryWhereSort on QueryBuilder<Source, Source, QWhere> {
  QueryBuilder<Source, Source, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Source, Source, QAfterWhere> anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterWhere> anyUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'updatedAt'),
      );
    });
  }
}

extension SourceQueryWhere on QueryBuilder<Source, Source, QWhereClause> {
  QueryBuilder<Source, Source, QAfterWhereClause> isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterWhereClause> isarIdNotEqualTo(Id isarId) {
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

  QueryBuilder<Source, Source, QAfterWhereClause> isarIdGreaterThan(Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterWhereClause> isarIdLessThan(Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterWhereClause> isarIdBetween(
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

  QueryBuilder<Source, Source, QAfterWhereClause> idSourceEqualTo(
      String idSource) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'idSource',
        value: [idSource],
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterWhereClause> idSourceNotEqualTo(
      String idSource) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idSource',
              lower: [],
              upper: [idSource],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idSource',
              lower: [idSource],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idSource',
              lower: [idSource],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idSource',
              lower: [],
              upper: [idSource],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Source, Source, QAfterWhereClause> libelleSourceEqualTo(
      String libelleSource) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'libelleSource',
        value: [libelleSource],
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterWhereClause> libelleSourceNotEqualTo(
      String libelleSource) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'libelleSource',
              lower: [],
              upper: [libelleSource],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'libelleSource',
              lower: [libelleSource],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'libelleSource',
              lower: [libelleSource],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'libelleSource',
              lower: [],
              upper: [libelleSource],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Source, Source, QAfterWhereClause> createdAtEqualTo(
      DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [createdAt],
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterWhereClause> createdAtNotEqualTo(
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

  QueryBuilder<Source, Source, QAfterWhereClause> createdAtGreaterThan(
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

  QueryBuilder<Source, Source, QAfterWhereClause> createdAtLessThan(
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

  QueryBuilder<Source, Source, QAfterWhereClause> createdAtBetween(
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

  QueryBuilder<Source, Source, QAfterWhereClause> updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'updatedAt',
        value: [null],
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterWhereClause> updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterWhereClause> updatedAtEqualTo(
      DateTime? updatedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'updatedAt',
        value: [updatedAt],
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterWhereClause> updatedAtNotEqualTo(
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

  QueryBuilder<Source, Source, QAfterWhereClause> updatedAtGreaterThan(
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

  QueryBuilder<Source, Source, QAfterWhereClause> updatedAtLessThan(
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

  QueryBuilder<Source, Source, QAfterWhereClause> updatedAtBetween(
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

extension SourceQueryFilter on QueryBuilder<Source, Source, QFilterCondition> {
  QueryBuilder<Source, Source, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> createdAtGreaterThan(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> createdAtLessThan(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> createdAtBetween(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> idSourceEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idSource',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> idSourceGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idSource',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> idSourceLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idSource',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> idSourceBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idSource',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> idSourceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'idSource',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> idSourceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'idSource',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> idSourceContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idSource',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> idSourceMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idSource',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> idSourceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idSource',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> idSourceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idSource',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> isarIdGreaterThan(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> isarIdLessThan(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> isarIdBetween(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> libelleSourceEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'libelleSource',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> libelleSourceGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'libelleSource',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> libelleSourceLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'libelleSource',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> libelleSourceBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'libelleSource',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> libelleSourceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'libelleSource',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> libelleSourceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'libelleSource',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> libelleSourceContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'libelleSource',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> libelleSourceMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'libelleSource',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> libelleSourceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'libelleSource',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      libelleSourceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'libelleSource',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> syncStateEqualTo(
      SyncState value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncState',
        value: value,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> syncStateGreaterThan(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> syncStateLessThan(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> syncStateBetween(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> updatedAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> updatedAtGreaterThan(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> updatedAtLessThan(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> updatedAtBetween(
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

extension SourceQueryObject on QueryBuilder<Source, Source, QFilterCondition> {}

extension SourceQueryLinks on QueryBuilder<Source, Source, QFilterCondition> {
  QueryBuilder<Source, Source, QAfterFilterCondition> fiches(
      FilterQuery<Fiche> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'fiches');
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> fichesLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'fiches', length, true, length, true);
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> fichesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'fiches', 0, true, 0, true);
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> fichesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'fiches', 0, false, 999999, true);
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> fichesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'fiches', 0, true, length, include);
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> fichesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'fiches', length, include, 999999, true);
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> fichesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'fiches', lower, includeLower, upper, includeUpper);
    });
  }
}

extension SourceQuerySortBy on QueryBuilder<Source, Source, QSortBy> {
  QueryBuilder<Source, Source, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByIdSource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idSource', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByIdSourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idSource', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByLibelleSource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libelleSource', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByLibelleSourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libelleSource', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortBySyncState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortBySyncStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension SourceQuerySortThenBy on QueryBuilder<Source, Source, QSortThenBy> {
  QueryBuilder<Source, Source, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByIdSource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idSource', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByIdSourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idSource', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByLibelleSource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libelleSource', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByLibelleSourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libelleSource', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenBySyncState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenBySyncStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension SourceQueryWhereDistinct on QueryBuilder<Source, Source, QDistinct> {
  QueryBuilder<Source, Source, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByIdSource(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idSource', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByLibelleSource(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libelleSource',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctBySyncState() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncState');
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension SourceQueryProperty on QueryBuilder<Source, Source, QQueryProperty> {
  QueryBuilder<Source, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<Source, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<Source, String, QQueryOperations> idSourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idSource');
    });
  }

  QueryBuilder<Source, String, QQueryOperations> libelleSourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libelleSource');
    });
  }

  QueryBuilder<Source, SyncState, QQueryOperations> syncStateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncState');
    });
  }

  QueryBuilder<Source, DateTime?, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
