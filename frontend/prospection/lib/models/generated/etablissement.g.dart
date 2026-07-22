// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../etablissement.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetEtablissementCollection on Isar {
  IsarCollection<Etablissement> get etablissements => this.collection();
}

const EtablissementSchema = CollectionSchema(
  name: r'Etablissement',
  id: -2639513812449285182,
  properties: {
    r'adresse': PropertySchema(
      id: 0,
      name: r'adresse',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'idEtablissement': PropertySchema(
      id: 2,
      name: r'idEtablissement',
      type: IsarType.string,
    ),
    r'nomEtablissement': PropertySchema(
      id: 3,
      name: r'nomEtablissement',
      type: IsarType.string,
    ),
    r'region': PropertySchema(
      id: 4,
      name: r'region',
      type: IsarType.string,
    ),
    r'syncState': PropertySchema(
      id: 5,
      name: r'syncState',
      type: IsarType.byte,
      enumMap: _EtablissementsyncStateEnumValueMap,
    ),
    r'telephone': PropertySchema(
      id: 6,
      name: r'telephone',
      type: IsarType.string,
    ),
    r'typeEtablissement': PropertySchema(
      id: 7,
      name: r'typeEtablissement',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 8,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'ville': PropertySchema(
      id: 9,
      name: r'ville',
      type: IsarType.string,
    )
  },
  estimateSize: _etablissementEstimateSize,
  serialize: _etablissementSerialize,
  deserialize: _etablissementDeserialize,
  deserializeProp: _etablissementDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'idEtablissement': IndexSchema(
      id: 7300731876996708612,
      name: r'idEtablissement',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'idEtablissement',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'nomEtablissement': IndexSchema(
      id: 6605071392781864224,
      name: r'nomEtablissement',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'nomEtablissement',
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
  links: {},
  embeddedSchemas: {},
  getId: _etablissementGetId,
  getLinks: _etablissementGetLinks,
  attach: _etablissementAttach,
  version: '3.3.2',
);

int _etablissementEstimateSize(
  Etablissement object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.adresse;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.idEtablissement.length * 3;
  bytesCount += 3 + object.nomEtablissement.length * 3;
  {
    final value = object.region;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.telephone;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.typeEtablissement;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.ville;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _etablissementSerialize(
  Etablissement object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.adresse);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeString(offsets[2], object.idEtablissement);
  writer.writeString(offsets[3], object.nomEtablissement);
  writer.writeString(offsets[4], object.region);
  writer.writeByte(offsets[5], object.syncState.index);
  writer.writeString(offsets[6], object.telephone);
  writer.writeString(offsets[7], object.typeEtablissement);
  writer.writeDateTime(offsets[8], object.updatedAt);
  writer.writeString(offsets[9], object.ville);
}

Etablissement _etablissementDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Etablissement(
    adresse: reader.readStringOrNull(offsets[0]),
    createdAt: reader.readDateTimeOrNull(offsets[1]),
    idEtablissement: reader.readString(offsets[2]),
    nomEtablissement: reader.readString(offsets[3]),
    region: reader.readStringOrNull(offsets[4]),
    syncState: _EtablissementsyncStateValueEnumMap[
            reader.readByteOrNull(offsets[5])] ??
        SyncState.pending,
    telephone: reader.readStringOrNull(offsets[6]),
    typeEtablissement: reader.readStringOrNull(offsets[7]),
    ville: reader.readStringOrNull(offsets[9]),
  );
  object.isarId = id;
  object.updatedAt = reader.readDateTimeOrNull(offsets[8]);
  return object;
}

P _etablissementDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (_EtablissementsyncStateValueEnumMap[
              reader.readByteOrNull(offset)] ??
          SyncState.pending) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _EtablissementsyncStateEnumValueMap = {
  'pending': 0,
  'syncing': 1,
  'synced': 2,
  'failed': 3,
  'toUpdate': 4,
};
const _EtablissementsyncStateValueEnumMap = {
  0: SyncState.pending,
  1: SyncState.syncing,
  2: SyncState.synced,
  3: SyncState.failed,
  4: SyncState.toUpdate,
};

Id _etablissementGetId(Etablissement object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _etablissementGetLinks(Etablissement object) {
  return [];
}

void _etablissementAttach(
    IsarCollection<dynamic> col, Id id, Etablissement object) {
  object.isarId = id;
}

extension EtablissementByIndex on IsarCollection<Etablissement> {
  Future<Etablissement?> getByIdEtablissement(String idEtablissement) {
    return getByIndex(r'idEtablissement', [idEtablissement]);
  }

  Etablissement? getByIdEtablissementSync(String idEtablissement) {
    return getByIndexSync(r'idEtablissement', [idEtablissement]);
  }

  Future<bool> deleteByIdEtablissement(String idEtablissement) {
    return deleteByIndex(r'idEtablissement', [idEtablissement]);
  }

  bool deleteByIdEtablissementSync(String idEtablissement) {
    return deleteByIndexSync(r'idEtablissement', [idEtablissement]);
  }

  Future<List<Etablissement?>> getAllByIdEtablissement(
      List<String> idEtablissementValues) {
    final values = idEtablissementValues.map((e) => [e]).toList();
    return getAllByIndex(r'idEtablissement', values);
  }

  List<Etablissement?> getAllByIdEtablissementSync(
      List<String> idEtablissementValues) {
    final values = idEtablissementValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'idEtablissement', values);
  }

  Future<int> deleteAllByIdEtablissement(List<String> idEtablissementValues) {
    final values = idEtablissementValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'idEtablissement', values);
  }

  int deleteAllByIdEtablissementSync(List<String> idEtablissementValues) {
    final values = idEtablissementValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'idEtablissement', values);
  }

  Future<Id> putByIdEtablissement(Etablissement object) {
    return putByIndex(r'idEtablissement', object);
  }

  Id putByIdEtablissementSync(Etablissement object, {bool saveLinks = true}) {
    return putByIndexSync(r'idEtablissement', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByIdEtablissement(List<Etablissement> objects) {
    return putAllByIndex(r'idEtablissement', objects);
  }

  List<Id> putAllByIdEtablissementSync(List<Etablissement> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'idEtablissement', objects, saveLinks: saveLinks);
  }
}

extension EtablissementQueryWhereSort
    on QueryBuilder<Etablissement, Etablissement, QWhere> {
  QueryBuilder<Etablissement, Etablissement, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterWhere> anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterWhere> anyUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'updatedAt'),
      );
    });
  }
}

extension EtablissementQueryWhere
    on QueryBuilder<Etablissement, Etablissement, QWhereClause> {
  QueryBuilder<Etablissement, Etablissement, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterWhereClause>
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

  QueryBuilder<Etablissement, Etablissement, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterWhereClause> isarIdBetween(
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

  QueryBuilder<Etablissement, Etablissement, QAfterWhereClause>
      idEtablissementEqualTo(String idEtablissement) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'idEtablissement',
        value: [idEtablissement],
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterWhereClause>
      idEtablissementNotEqualTo(String idEtablissement) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idEtablissement',
              lower: [],
              upper: [idEtablissement],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idEtablissement',
              lower: [idEtablissement],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idEtablissement',
              lower: [idEtablissement],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idEtablissement',
              lower: [],
              upper: [idEtablissement],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterWhereClause>
      nomEtablissementEqualTo(String nomEtablissement) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'nomEtablissement',
        value: [nomEtablissement],
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterWhereClause>
      nomEtablissementNotEqualTo(String nomEtablissement) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'nomEtablissement',
              lower: [],
              upper: [nomEtablissement],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'nomEtablissement',
              lower: [nomEtablissement],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'nomEtablissement',
              lower: [nomEtablissement],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'nomEtablissement',
              lower: [],
              upper: [nomEtablissement],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterWhereClause>
      createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [null],
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterWhereClause>
      createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterWhereClause>
      createdAtEqualTo(DateTime? createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [createdAt],
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterWhereClause>
      createdAtNotEqualTo(DateTime? createdAt) {
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

  QueryBuilder<Etablissement, Etablissement, QAfterWhereClause>
      createdAtGreaterThan(
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

  QueryBuilder<Etablissement, Etablissement, QAfterWhereClause>
      createdAtLessThan(
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

  QueryBuilder<Etablissement, Etablissement, QAfterWhereClause>
      createdAtBetween(
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

  QueryBuilder<Etablissement, Etablissement, QAfterWhereClause>
      updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'updatedAt',
        value: [null],
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterWhereClause>
      updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterWhereClause>
      updatedAtEqualTo(DateTime? updatedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'updatedAt',
        value: [updatedAt],
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterWhereClause>
      updatedAtNotEqualTo(DateTime? updatedAt) {
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

  QueryBuilder<Etablissement, Etablissement, QAfterWhereClause>
      updatedAtGreaterThan(
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

  QueryBuilder<Etablissement, Etablissement, QAfterWhereClause>
      updatedAtLessThan(
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

  QueryBuilder<Etablissement, Etablissement, QAfterWhereClause>
      updatedAtBetween(
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

extension EtablissementQueryFilter
    on QueryBuilder<Etablissement, Etablissement, QFilterCondition> {
  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      adresseIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'adresse',
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      adresseIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'adresse',
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      adresseEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'adresse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      adresseGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'adresse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      adresseLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'adresse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      adresseBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'adresse',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      adresseStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'adresse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      adresseEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'adresse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      adresseContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'adresse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      adresseMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'adresse',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      adresseIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'adresse',
        value: '',
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      adresseIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'adresse',
        value: '',
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      createdAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
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

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      createdAtLessThan(
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

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      createdAtBetween(
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

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      idEtablissementEqualTo(
    String value, {
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

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      idEtablissementGreaterThan(
    String value, {
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

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      idEtablissementLessThan(
    String value, {
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

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      idEtablissementBetween(
    String lower,
    String upper, {
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

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      idEtablissementStartsWith(
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

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      idEtablissementEndsWith(
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

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      idEtablissementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idEtablissement',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      idEtablissementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idEtablissement',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      idEtablissementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idEtablissement',
        value: '',
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      idEtablissementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idEtablissement',
        value: '',
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
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

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
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

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
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

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      nomEtablissementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nomEtablissement',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      nomEtablissementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nomEtablissement',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      nomEtablissementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nomEtablissement',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      nomEtablissementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nomEtablissement',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      nomEtablissementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nomEtablissement',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      nomEtablissementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nomEtablissement',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      nomEtablissementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nomEtablissement',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      nomEtablissementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nomEtablissement',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      nomEtablissementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nomEtablissement',
        value: '',
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      nomEtablissementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nomEtablissement',
        value: '',
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      regionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'region',
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      regionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'region',
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      regionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'region',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      regionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'region',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      regionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'region',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      regionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'region',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      regionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'region',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      regionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'region',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      regionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'region',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      regionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'region',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      regionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'region',
        value: '',
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      regionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'region',
        value: '',
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      syncStateEqualTo(SyncState value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncState',
        value: value,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
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

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
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

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
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

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      telephoneIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'telephone',
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      telephoneIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'telephone',
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      telephoneEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'telephone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      telephoneGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'telephone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      telephoneLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'telephone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      telephoneBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'telephone',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      telephoneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'telephone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      telephoneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'telephone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      telephoneContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'telephone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      telephoneMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'telephone',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      telephoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'telephone',
        value: '',
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      telephoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'telephone',
        value: '',
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      typeEtablissementIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'typeEtablissement',
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      typeEtablissementIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'typeEtablissement',
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      typeEtablissementEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'typeEtablissement',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      typeEtablissementGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'typeEtablissement',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      typeEtablissementLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'typeEtablissement',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      typeEtablissementBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'typeEtablissement',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      typeEtablissementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'typeEtablissement',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      typeEtablissementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'typeEtablissement',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      typeEtablissementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'typeEtablissement',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      typeEtablissementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'typeEtablissement',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      typeEtablissementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'typeEtablissement',
        value: '',
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      typeEtablissementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'typeEtablissement',
        value: '',
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      updatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
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

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      updatedAtLessThan(
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

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      updatedAtBetween(
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

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      villeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'ville',
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      villeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'ville',
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      villeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ville',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      villeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ville',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      villeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ville',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      villeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ville',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      villeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ville',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      villeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ville',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      villeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ville',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      villeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ville',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      villeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ville',
        value: '',
      ));
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterFilterCondition>
      villeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ville',
        value: '',
      ));
    });
  }
}

extension EtablissementQueryObject
    on QueryBuilder<Etablissement, Etablissement, QFilterCondition> {}

extension EtablissementQueryLinks
    on QueryBuilder<Etablissement, Etablissement, QFilterCondition> {}

extension EtablissementQuerySortBy
    on QueryBuilder<Etablissement, Etablissement, QSortBy> {
  QueryBuilder<Etablissement, Etablissement, QAfterSortBy> sortByAdresse() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'adresse', Sort.asc);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterSortBy> sortByAdresseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'adresse', Sort.desc);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterSortBy>
      sortByIdEtablissement() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idEtablissement', Sort.asc);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterSortBy>
      sortByIdEtablissementDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idEtablissement', Sort.desc);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterSortBy>
      sortByNomEtablissement() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nomEtablissement', Sort.asc);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterSortBy>
      sortByNomEtablissementDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nomEtablissement', Sort.desc);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterSortBy> sortByRegion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'region', Sort.asc);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterSortBy> sortByRegionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'region', Sort.desc);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterSortBy> sortBySyncState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.asc);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterSortBy>
      sortBySyncStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.desc);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterSortBy> sortByTelephone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'telephone', Sort.asc);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterSortBy>
      sortByTelephoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'telephone', Sort.desc);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterSortBy>
      sortByTypeEtablissement() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeEtablissement', Sort.asc);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterSortBy>
      sortByTypeEtablissementDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeEtablissement', Sort.desc);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterSortBy> sortByVille() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ville', Sort.asc);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterSortBy> sortByVilleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ville', Sort.desc);
    });
  }
}

extension EtablissementQuerySortThenBy
    on QueryBuilder<Etablissement, Etablissement, QSortThenBy> {
  QueryBuilder<Etablissement, Etablissement, QAfterSortBy> thenByAdresse() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'adresse', Sort.asc);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterSortBy> thenByAdresseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'adresse', Sort.desc);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterSortBy>
      thenByIdEtablissement() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idEtablissement', Sort.asc);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterSortBy>
      thenByIdEtablissementDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idEtablissement', Sort.desc);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterSortBy>
      thenByNomEtablissement() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nomEtablissement', Sort.asc);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterSortBy>
      thenByNomEtablissementDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nomEtablissement', Sort.desc);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterSortBy> thenByRegion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'region', Sort.asc);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterSortBy> thenByRegionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'region', Sort.desc);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterSortBy> thenBySyncState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.asc);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterSortBy>
      thenBySyncStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.desc);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterSortBy> thenByTelephone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'telephone', Sort.asc);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterSortBy>
      thenByTelephoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'telephone', Sort.desc);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterSortBy>
      thenByTypeEtablissement() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeEtablissement', Sort.asc);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterSortBy>
      thenByTypeEtablissementDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeEtablissement', Sort.desc);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterSortBy> thenByVille() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ville', Sort.asc);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QAfterSortBy> thenByVilleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ville', Sort.desc);
    });
  }
}

extension EtablissementQueryWhereDistinct
    on QueryBuilder<Etablissement, Etablissement, QDistinct> {
  QueryBuilder<Etablissement, Etablissement, QDistinct> distinctByAdresse(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'adresse', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<Etablissement, Etablissement, QDistinct>
      distinctByIdEtablissement({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idEtablissement',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QDistinct>
      distinctByNomEtablissement({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nomEtablissement',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QDistinct> distinctByRegion(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'region', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QDistinct> distinctBySyncState() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncState');
    });
  }

  QueryBuilder<Etablissement, Etablissement, QDistinct> distinctByTelephone(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'telephone', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QDistinct>
      distinctByTypeEtablissement({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'typeEtablissement',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Etablissement, Etablissement, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<Etablissement, Etablissement, QDistinct> distinctByVille(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ville', caseSensitive: caseSensitive);
    });
  }
}

extension EtablissementQueryProperty
    on QueryBuilder<Etablissement, Etablissement, QQueryProperty> {
  QueryBuilder<Etablissement, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<Etablissement, String?, QQueryOperations> adresseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'adresse');
    });
  }

  QueryBuilder<Etablissement, DateTime?, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<Etablissement, String, QQueryOperations>
      idEtablissementProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idEtablissement');
    });
  }

  QueryBuilder<Etablissement, String, QQueryOperations>
      nomEtablissementProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nomEtablissement');
    });
  }

  QueryBuilder<Etablissement, String?, QQueryOperations> regionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'region');
    });
  }

  QueryBuilder<Etablissement, SyncState, QQueryOperations> syncStateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncState');
    });
  }

  QueryBuilder<Etablissement, String?, QQueryOperations> telephoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'telephone');
    });
  }

  QueryBuilder<Etablissement, String?, QQueryOperations>
      typeEtablissementProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'typeEtablissement');
    });
  }

  QueryBuilder<Etablissement, DateTime?, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<Etablissement, String?, QQueryOperations> villeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ville');
    });
  }
}
