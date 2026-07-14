// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../classe.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetClasseCollection on Isar {
  IsarCollection<Classe> get classes => this.collection();
}

const ClasseSchema = CollectionSchema(
  name: r'Classe',
  id: -6748177226977079863,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'idClasse': PropertySchema(
      id: 1,
      name: r'idClasse',
      type: IsarType.string,
    ),
    r'idEts': PropertySchema(
      id: 2,
      name: r'idEts',
      type: IsarType.string,
    ),
    r'libelleClasse': PropertySchema(
      id: 3,
      name: r'libelleClasse',
      type: IsarType.string,
    ),
    r'syncState': PropertySchema(
      id: 4,
      name: r'syncState',
      type: IsarType.byte,
      enumMap: _ClassesyncStateEnumValueMap,
    ),
    r'updatedAt': PropertySchema(
      id: 5,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _classeEstimateSize,
  serialize: _classeSerialize,
  deserialize: _classeDeserialize,
  deserializeProp: _classeDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'idClasse': IndexSchema(
      id: 4607164231052193247,
      name: r'idClasse',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'idClasse',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'idEts': IndexSchema(
      id: 3458280750964673142,
      name: r'idEts',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'idEts',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'libelleClasse': IndexSchema(
      id: 3529125688671503725,
      name: r'libelleClasse',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'libelleClasse',
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
    r'ets': LinkSchema(
      id: -1186834962189773068,
      name: r'ets',
      target: r'Etablissement',
      single: true,
    ),
    r'prospects': LinkSchema(
      id: 3336785135167154829,
      name: r'prospects',
      target: r'Prospect',
      single: false,
      linkName: r'classe',
    )
  },
  embeddedSchemas: {},
  getId: _classeGetId,
  getLinks: _classeGetLinks,
  attach: _classeAttach,
  version: '3.1.0+1',
);

int _classeEstimateSize(
  Classe object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.idClasse.length * 3;
  bytesCount += 3 + object.idEts.length * 3;
  bytesCount += 3 + object.libelleClasse.length * 3;
  return bytesCount;
}

void _classeSerialize(
  Classe object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.idClasse);
  writer.writeString(offsets[2], object.idEts);
  writer.writeString(offsets[3], object.libelleClasse);
  writer.writeByte(offsets[4], object.syncState.index);
  writer.writeDateTime(offsets[5], object.updatedAt);
}

Classe _classeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Classe(
    createdAt: reader.readDateTimeOrNull(offsets[0]),
    idClasse: reader.readString(offsets[1]),
    idEts: reader.readString(offsets[2]),
    libelleClasse: reader.readString(offsets[3]),
    syncState:
        _ClassesyncStateValueEnumMap[reader.readByteOrNull(offsets[4])] ??
            SyncState.pending,
  );
  object.isarId = id;
  object.updatedAt = reader.readDateTimeOrNull(offsets[5]);
  return object;
}

P _classeDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (_ClassesyncStateValueEnumMap[reader.readByteOrNull(offset)] ??
          SyncState.pending) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _ClassesyncStateEnumValueMap = {
  'pending': 0,
  'syncing': 1,
  'synced': 2,
  'failed': 3,
};
const _ClassesyncStateValueEnumMap = {
  0: SyncState.pending,
  1: SyncState.syncing,
  2: SyncState.synced,
  3: SyncState.failed,
};

Id _classeGetId(Classe object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _classeGetLinks(Classe object) {
  return [object.ets, object.prospects];
}

void _classeAttach(IsarCollection<dynamic> col, Id id, Classe object) {
  object.isarId = id;
  object.ets.attach(col, col.isar.collection<Etablissement>(), r'ets', id);
  object.prospects
      .attach(col, col.isar.collection<Prospect>(), r'prospects', id);
}

extension ClasseByIndex on IsarCollection<Classe> {
  Future<Classe?> getByIdClasse(String idClasse) {
    return getByIndex(r'idClasse', [idClasse]);
  }

  Classe? getByIdClasseSync(String idClasse) {
    return getByIndexSync(r'idClasse', [idClasse]);
  }

  Future<bool> deleteByIdClasse(String idClasse) {
    return deleteByIndex(r'idClasse', [idClasse]);
  }

  bool deleteByIdClasseSync(String idClasse) {
    return deleteByIndexSync(r'idClasse', [idClasse]);
  }

  Future<List<Classe?>> getAllByIdClasse(List<String> idClasseValues) {
    final values = idClasseValues.map((e) => [e]).toList();
    return getAllByIndex(r'idClasse', values);
  }

  List<Classe?> getAllByIdClasseSync(List<String> idClasseValues) {
    final values = idClasseValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'idClasse', values);
  }

  Future<int> deleteAllByIdClasse(List<String> idClasseValues) {
    final values = idClasseValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'idClasse', values);
  }

  int deleteAllByIdClasseSync(List<String> idClasseValues) {
    final values = idClasseValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'idClasse', values);
  }

  Future<Id> putByIdClasse(Classe object) {
    return putByIndex(r'idClasse', object);
  }

  Id putByIdClasseSync(Classe object, {bool saveLinks = true}) {
    return putByIndexSync(r'idClasse', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByIdClasse(List<Classe> objects) {
    return putAllByIndex(r'idClasse', objects);
  }

  List<Id> putAllByIdClasseSync(List<Classe> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'idClasse', objects, saveLinks: saveLinks);
  }
}

extension ClasseQueryWhereSort on QueryBuilder<Classe, Classe, QWhere> {
  QueryBuilder<Classe, Classe, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Classe, Classe, QAfterWhere> anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }

  QueryBuilder<Classe, Classe, QAfterWhere> anyUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'updatedAt'),
      );
    });
  }
}

extension ClasseQueryWhere on QueryBuilder<Classe, Classe, QWhereClause> {
  QueryBuilder<Classe, Classe, QAfterWhereClause> isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterWhereClause> isarIdNotEqualTo(Id isarId) {
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

  QueryBuilder<Classe, Classe, QAfterWhereClause> isarIdGreaterThan(Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<Classe, Classe, QAfterWhereClause> isarIdLessThan(Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<Classe, Classe, QAfterWhereClause> isarIdBetween(
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

  QueryBuilder<Classe, Classe, QAfterWhereClause> idClasseEqualTo(
      String idClasse) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'idClasse',
        value: [idClasse],
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterWhereClause> idClasseNotEqualTo(
      String idClasse) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idClasse',
              lower: [],
              upper: [idClasse],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idClasse',
              lower: [idClasse],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idClasse',
              lower: [idClasse],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idClasse',
              lower: [],
              upper: [idClasse],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Classe, Classe, QAfterWhereClause> idEtsEqualTo(String idEts) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'idEts',
        value: [idEts],
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterWhereClause> idEtsNotEqualTo(
      String idEts) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idEts',
              lower: [],
              upper: [idEts],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idEts',
              lower: [idEts],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idEts',
              lower: [idEts],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idEts',
              lower: [],
              upper: [idEts],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Classe, Classe, QAfterWhereClause> libelleClasseEqualTo(
      String libelleClasse) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'libelleClasse',
        value: [libelleClasse],
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterWhereClause> libelleClasseNotEqualTo(
      String libelleClasse) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'libelleClasse',
              lower: [],
              upper: [libelleClasse],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'libelleClasse',
              lower: [libelleClasse],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'libelleClasse',
              lower: [libelleClasse],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'libelleClasse',
              lower: [],
              upper: [libelleClasse],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Classe, Classe, QAfterWhereClause> createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [null],
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterWhereClause> createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterWhereClause> createdAtEqualTo(
      DateTime? createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [createdAt],
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterWhereClause> createdAtNotEqualTo(
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

  QueryBuilder<Classe, Classe, QAfterWhereClause> createdAtGreaterThan(
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

  QueryBuilder<Classe, Classe, QAfterWhereClause> createdAtLessThan(
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

  QueryBuilder<Classe, Classe, QAfterWhereClause> createdAtBetween(
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

  QueryBuilder<Classe, Classe, QAfterWhereClause> updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'updatedAt',
        value: [null],
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterWhereClause> updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterWhereClause> updatedAtEqualTo(
      DateTime? updatedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'updatedAt',
        value: [updatedAt],
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterWhereClause> updatedAtNotEqualTo(
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

  QueryBuilder<Classe, Classe, QAfterWhereClause> updatedAtGreaterThan(
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

  QueryBuilder<Classe, Classe, QAfterWhereClause> updatedAtLessThan(
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

  QueryBuilder<Classe, Classe, QAfterWhereClause> updatedAtBetween(
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

extension ClasseQueryFilter on QueryBuilder<Classe, Classe, QFilterCondition> {
  QueryBuilder<Classe, Classe, QAfterFilterCondition> createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition> createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition> createdAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition> createdAtGreaterThan(
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

  QueryBuilder<Classe, Classe, QAfterFilterCondition> createdAtLessThan(
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

  QueryBuilder<Classe, Classe, QAfterFilterCondition> createdAtBetween(
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

  QueryBuilder<Classe, Classe, QAfterFilterCondition> idClasseEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idClasse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition> idClasseGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idClasse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition> idClasseLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idClasse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition> idClasseBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idClasse',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition> idClasseStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'idClasse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition> idClasseEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'idClasse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition> idClasseContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idClasse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition> idClasseMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idClasse',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition> idClasseIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idClasse',
        value: '',
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition> idClasseIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idClasse',
        value: '',
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition> idEtsEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idEts',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition> idEtsGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idEts',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition> idEtsLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idEts',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition> idEtsBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idEts',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition> idEtsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'idEts',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition> idEtsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'idEts',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition> idEtsContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idEts',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition> idEtsMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idEts',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition> idEtsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idEts',
        value: '',
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition> idEtsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idEts',
        value: '',
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition> isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition> isarIdGreaterThan(
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

  QueryBuilder<Classe, Classe, QAfterFilterCondition> isarIdLessThan(
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

  QueryBuilder<Classe, Classe, QAfterFilterCondition> isarIdBetween(
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

  QueryBuilder<Classe, Classe, QAfterFilterCondition> libelleClasseEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'libelleClasse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition> libelleClasseGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'libelleClasse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition> libelleClasseLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'libelleClasse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition> libelleClasseBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'libelleClasse',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition> libelleClasseStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'libelleClasse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition> libelleClasseEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'libelleClasse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition> libelleClasseContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'libelleClasse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition> libelleClasseMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'libelleClasse',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition> libelleClasseIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'libelleClasse',
        value: '',
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition>
      libelleClasseIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'libelleClasse',
        value: '',
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition> syncStateEqualTo(
      SyncState value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncState',
        value: value,
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition> syncStateGreaterThan(
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

  QueryBuilder<Classe, Classe, QAfterFilterCondition> syncStateLessThan(
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

  QueryBuilder<Classe, Classe, QAfterFilterCondition> syncStateBetween(
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

  QueryBuilder<Classe, Classe, QAfterFilterCondition> updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition> updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition> updatedAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition> updatedAtGreaterThan(
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

  QueryBuilder<Classe, Classe, QAfterFilterCondition> updatedAtLessThan(
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

  QueryBuilder<Classe, Classe, QAfterFilterCondition> updatedAtBetween(
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

extension ClasseQueryObject on QueryBuilder<Classe, Classe, QFilterCondition> {}

extension ClasseQueryLinks on QueryBuilder<Classe, Classe, QFilterCondition> {
  QueryBuilder<Classe, Classe, QAfterFilterCondition> ets(
      FilterQuery<Etablissement> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'ets');
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition> etsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'ets', 0, true, 0, true);
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition> prospects(
      FilterQuery<Prospect> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'prospects');
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition> prospectsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'prospects', length, true, length, true);
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition> prospectsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'prospects', 0, true, 0, true);
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition> prospectsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'prospects', 0, false, 999999, true);
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition> prospectsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'prospects', 0, true, length, include);
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition>
      prospectsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'prospects', length, include, 999999, true);
    });
  }

  QueryBuilder<Classe, Classe, QAfterFilterCondition> prospectsLengthBetween(
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

extension ClasseQuerySortBy on QueryBuilder<Classe, Classe, QSortBy> {
  QueryBuilder<Classe, Classe, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Classe, Classe, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Classe, Classe, QAfterSortBy> sortByIdClasse() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idClasse', Sort.asc);
    });
  }

  QueryBuilder<Classe, Classe, QAfterSortBy> sortByIdClasseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idClasse', Sort.desc);
    });
  }

  QueryBuilder<Classe, Classe, QAfterSortBy> sortByIdEts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idEts', Sort.asc);
    });
  }

  QueryBuilder<Classe, Classe, QAfterSortBy> sortByIdEtsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idEts', Sort.desc);
    });
  }

  QueryBuilder<Classe, Classe, QAfterSortBy> sortByLibelleClasse() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libelleClasse', Sort.asc);
    });
  }

  QueryBuilder<Classe, Classe, QAfterSortBy> sortByLibelleClasseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libelleClasse', Sort.desc);
    });
  }

  QueryBuilder<Classe, Classe, QAfterSortBy> sortBySyncState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.asc);
    });
  }

  QueryBuilder<Classe, Classe, QAfterSortBy> sortBySyncStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.desc);
    });
  }

  QueryBuilder<Classe, Classe, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Classe, Classe, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension ClasseQuerySortThenBy on QueryBuilder<Classe, Classe, QSortThenBy> {
  QueryBuilder<Classe, Classe, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Classe, Classe, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Classe, Classe, QAfterSortBy> thenByIdClasse() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idClasse', Sort.asc);
    });
  }

  QueryBuilder<Classe, Classe, QAfterSortBy> thenByIdClasseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idClasse', Sort.desc);
    });
  }

  QueryBuilder<Classe, Classe, QAfterSortBy> thenByIdEts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idEts', Sort.asc);
    });
  }

  QueryBuilder<Classe, Classe, QAfterSortBy> thenByIdEtsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idEts', Sort.desc);
    });
  }

  QueryBuilder<Classe, Classe, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<Classe, Classe, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<Classe, Classe, QAfterSortBy> thenByLibelleClasse() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libelleClasse', Sort.asc);
    });
  }

  QueryBuilder<Classe, Classe, QAfterSortBy> thenByLibelleClasseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libelleClasse', Sort.desc);
    });
  }

  QueryBuilder<Classe, Classe, QAfterSortBy> thenBySyncState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.asc);
    });
  }

  QueryBuilder<Classe, Classe, QAfterSortBy> thenBySyncStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.desc);
    });
  }

  QueryBuilder<Classe, Classe, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Classe, Classe, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension ClasseQueryWhereDistinct on QueryBuilder<Classe, Classe, QDistinct> {
  QueryBuilder<Classe, Classe, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<Classe, Classe, QDistinct> distinctByIdClasse(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idClasse', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Classe, Classe, QDistinct> distinctByIdEts(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idEts', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Classe, Classe, QDistinct> distinctByLibelleClasse(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libelleClasse',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Classe, Classe, QDistinct> distinctBySyncState() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncState');
    });
  }

  QueryBuilder<Classe, Classe, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension ClasseQueryProperty on QueryBuilder<Classe, Classe, QQueryProperty> {
  QueryBuilder<Classe, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<Classe, DateTime?, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<Classe, String, QQueryOperations> idClasseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idClasse');
    });
  }

  QueryBuilder<Classe, String, QQueryOperations> idEtsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idEts');
    });
  }

  QueryBuilder<Classe, String, QQueryOperations> libelleClasseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libelleClasse');
    });
  }

  QueryBuilder<Classe, SyncState, QQueryOperations> syncStateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncState');
    });
  }

  QueryBuilder<Classe, DateTime?, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
