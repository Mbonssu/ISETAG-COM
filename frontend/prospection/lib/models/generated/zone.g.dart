// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../zone.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetZoneCollection on Isar {
  IsarCollection<Zone> get zones => this.collection();
}

const ZoneSchema = CollectionSchema(
  name: r'Zone',
  id: -8664688090062696472,
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
    r'idZone': PropertySchema(
      id: 2,
      name: r'idZone',
      type: IsarType.string,
    ),
    r'libele': PropertySchema(
      id: 3,
      name: r'libele',
      type: IsarType.string,
    ),
    r'lieuArrivee': PropertySchema(
      id: 4,
      name: r'lieuArrivee',
      type: IsarType.string,
    ),
    r'lieuDepart': PropertySchema(
      id: 5,
      name: r'lieuDepart',
      type: IsarType.string,
    ),
    r'pays': PropertySchema(
      id: 6,
      name: r'pays',
      type: IsarType.string,
    ),
    r'quartier': PropertySchema(
      id: 7,
      name: r'quartier',
      type: IsarType.string,
    ),
    r'region': PropertySchema(
      id: 8,
      name: r'region',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 9,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'ville': PropertySchema(
      id: 10,
      name: r'ville',
      type: IsarType.string,
    )
  },
  estimateSize: _zoneEstimateSize,
  serialize: _zoneSerialize,
  deserialize: _zoneDeserialize,
  deserializeProp: _zoneDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'idZone': IndexSchema(
      id: -6617875878800025933,
      name: r'idZone',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'idZone',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'libele': IndexSchema(
      id: 690370265933472510,
      name: r'libele',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'libele',
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
  links: {},
  embeddedSchemas: {},
  getId: _zoneGetId,
  getLinks: _zoneGetLinks,
  attach: _zoneAttach,
  version: '3.3.2',
);

int _zoneEstimateSize(
  Zone object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.description.length * 3;
  bytesCount += 3 + object.idZone.length * 3;
  bytesCount += 3 + object.libele.length * 3;
  bytesCount += 3 + object.lieuArrivee.length * 3;
  bytesCount += 3 + object.lieuDepart.length * 3;
  bytesCount += 3 + object.pays.length * 3;
  bytesCount += 3 + object.quartier.length * 3;
  bytesCount += 3 + object.region.length * 3;
  bytesCount += 3 + object.ville.length * 3;
  return bytesCount;
}

void _zoneSerialize(
  Zone object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.description);
  writer.writeString(offsets[2], object.idZone);
  writer.writeString(offsets[3], object.libele);
  writer.writeString(offsets[4], object.lieuArrivee);
  writer.writeString(offsets[5], object.lieuDepart);
  writer.writeString(offsets[6], object.pays);
  writer.writeString(offsets[7], object.quartier);
  writer.writeString(offsets[8], object.region);
  writer.writeDateTime(offsets[9], object.updatedAt);
  writer.writeString(offsets[10], object.ville);
}

Zone _zoneDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Zone(
    createdAt: reader.readDateTime(offsets[0]),
    description: reader.readString(offsets[1]),
    idZone: reader.readString(offsets[2]),
    libele: reader.readString(offsets[3]),
    lieuArrivee: reader.readString(offsets[4]),
    lieuDepart: reader.readString(offsets[5]),
    pays: reader.readString(offsets[6]),
    quartier: reader.readString(offsets[7]),
    region: reader.readString(offsets[8]),
    updatedAt: reader.readDateTimeOrNull(offsets[9]),
    ville: reader.readString(offsets[10]),
  );
  object.isarId = id;
  return object;
}

P _zoneDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _zoneGetId(Zone object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _zoneGetLinks(Zone object) {
  return [];
}

void _zoneAttach(IsarCollection<dynamic> col, Id id, Zone object) {
  object.isarId = id;
}

extension ZoneByIndex on IsarCollection<Zone> {
  Future<Zone?> getByIdZone(String idZone) {
    return getByIndex(r'idZone', [idZone]);
  }

  Zone? getByIdZoneSync(String idZone) {
    return getByIndexSync(r'idZone', [idZone]);
  }

  Future<bool> deleteByIdZone(String idZone) {
    return deleteByIndex(r'idZone', [idZone]);
  }

  bool deleteByIdZoneSync(String idZone) {
    return deleteByIndexSync(r'idZone', [idZone]);
  }

  Future<List<Zone?>> getAllByIdZone(List<String> idZoneValues) {
    final values = idZoneValues.map((e) => [e]).toList();
    return getAllByIndex(r'idZone', values);
  }

  List<Zone?> getAllByIdZoneSync(List<String> idZoneValues) {
    final values = idZoneValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'idZone', values);
  }

  Future<int> deleteAllByIdZone(List<String> idZoneValues) {
    final values = idZoneValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'idZone', values);
  }

  int deleteAllByIdZoneSync(List<String> idZoneValues) {
    final values = idZoneValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'idZone', values);
  }

  Future<Id> putByIdZone(Zone object) {
    return putByIndex(r'idZone', object);
  }

  Id putByIdZoneSync(Zone object, {bool saveLinks = true}) {
    return putByIndexSync(r'idZone', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByIdZone(List<Zone> objects) {
    return putAllByIndex(r'idZone', objects);
  }

  List<Id> putAllByIdZoneSync(List<Zone> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'idZone', objects, saveLinks: saveLinks);
  }
}

extension ZoneQueryWhereSort on QueryBuilder<Zone, Zone, QWhere> {
  QueryBuilder<Zone, Zone, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Zone, Zone, QAfterWhere> anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }
}

extension ZoneQueryWhere on QueryBuilder<Zone, Zone, QWhereClause> {
  QueryBuilder<Zone, Zone, QAfterWhereClause> isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterWhereClause> isarIdNotEqualTo(Id isarId) {
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

  QueryBuilder<Zone, Zone, QAfterWhereClause> isarIdGreaterThan(Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<Zone, Zone, QAfterWhereClause> isarIdLessThan(Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<Zone, Zone, QAfterWhereClause> isarIdBetween(
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

  QueryBuilder<Zone, Zone, QAfterWhereClause> idZoneEqualTo(String idZone) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'idZone',
        value: [idZone],
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterWhereClause> idZoneNotEqualTo(String idZone) {
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

  QueryBuilder<Zone, Zone, QAfterWhereClause> libeleEqualTo(String libele) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'libele',
        value: [libele],
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterWhereClause> libeleNotEqualTo(String libele) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'libele',
              lower: [],
              upper: [libele],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'libele',
              lower: [libele],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'libele',
              lower: [libele],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'libele',
              lower: [],
              upper: [libele],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Zone, Zone, QAfterWhereClause> createdAtEqualTo(
      DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [createdAt],
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterWhereClause> createdAtNotEqualTo(
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

  QueryBuilder<Zone, Zone, QAfterWhereClause> createdAtGreaterThan(
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

  QueryBuilder<Zone, Zone, QAfterWhereClause> createdAtLessThan(
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

  QueryBuilder<Zone, Zone, QAfterWhereClause> createdAtBetween(
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

extension ZoneQueryFilter on QueryBuilder<Zone, Zone, QFilterCondition> {
  QueryBuilder<Zone, Zone, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> createdAtGreaterThan(
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

  QueryBuilder<Zone, Zone, QAfterFilterCondition> createdAtLessThan(
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

  QueryBuilder<Zone, Zone, QAfterFilterCondition> createdAtBetween(
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

  QueryBuilder<Zone, Zone, QAfterFilterCondition> descriptionEqualTo(
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

  QueryBuilder<Zone, Zone, QAfterFilterCondition> descriptionGreaterThan(
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

  QueryBuilder<Zone, Zone, QAfterFilterCondition> descriptionLessThan(
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

  QueryBuilder<Zone, Zone, QAfterFilterCondition> descriptionBetween(
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

  QueryBuilder<Zone, Zone, QAfterFilterCondition> descriptionStartsWith(
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

  QueryBuilder<Zone, Zone, QAfterFilterCondition> descriptionEndsWith(
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

  QueryBuilder<Zone, Zone, QAfterFilterCondition> descriptionContains(
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

  QueryBuilder<Zone, Zone, QAfterFilterCondition> descriptionMatches(
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

  QueryBuilder<Zone, Zone, QAfterFilterCondition> descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> idZoneEqualTo(
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

  QueryBuilder<Zone, Zone, QAfterFilterCondition> idZoneGreaterThan(
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

  QueryBuilder<Zone, Zone, QAfterFilterCondition> idZoneLessThan(
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

  QueryBuilder<Zone, Zone, QAfterFilterCondition> idZoneBetween(
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

  QueryBuilder<Zone, Zone, QAfterFilterCondition> idZoneStartsWith(
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

  QueryBuilder<Zone, Zone, QAfterFilterCondition> idZoneEndsWith(
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

  QueryBuilder<Zone, Zone, QAfterFilterCondition> idZoneContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idZone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> idZoneMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idZone',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> idZoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idZone',
        value: '',
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> idZoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idZone',
        value: '',
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> isarIdGreaterThan(
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

  QueryBuilder<Zone, Zone, QAfterFilterCondition> isarIdLessThan(
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

  QueryBuilder<Zone, Zone, QAfterFilterCondition> isarIdBetween(
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

  QueryBuilder<Zone, Zone, QAfterFilterCondition> libeleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'libele',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> libeleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'libele',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> libeleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'libele',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> libeleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'libele',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> libeleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'libele',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> libeleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'libele',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> libeleContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'libele',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> libeleMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'libele',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> libeleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'libele',
        value: '',
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> libeleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'libele',
        value: '',
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> lieuArriveeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lieuArrivee',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> lieuArriveeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lieuArrivee',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> lieuArriveeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lieuArrivee',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> lieuArriveeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lieuArrivee',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> lieuArriveeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lieuArrivee',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> lieuArriveeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lieuArrivee',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> lieuArriveeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lieuArrivee',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> lieuArriveeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lieuArrivee',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> lieuArriveeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lieuArrivee',
        value: '',
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> lieuArriveeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lieuArrivee',
        value: '',
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> lieuDepartEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lieuDepart',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> lieuDepartGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lieuDepart',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> lieuDepartLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lieuDepart',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> lieuDepartBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lieuDepart',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> lieuDepartStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lieuDepart',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> lieuDepartEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lieuDepart',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> lieuDepartContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lieuDepart',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> lieuDepartMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lieuDepart',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> lieuDepartIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lieuDepart',
        value: '',
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> lieuDepartIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lieuDepart',
        value: '',
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> paysEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pays',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> paysGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pays',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> paysLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pays',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> paysBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pays',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> paysStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pays',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> paysEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pays',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> paysContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pays',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> paysMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pays',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> paysIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pays',
        value: '',
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> paysIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pays',
        value: '',
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> quartierEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quartier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> quartierGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'quartier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> quartierLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'quartier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> quartierBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'quartier',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> quartierStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'quartier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> quartierEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'quartier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> quartierContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'quartier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> quartierMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'quartier',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> quartierIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quartier',
        value: '',
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> quartierIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'quartier',
        value: '',
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> regionEqualTo(
    String value, {
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

  QueryBuilder<Zone, Zone, QAfterFilterCondition> regionGreaterThan(
    String value, {
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

  QueryBuilder<Zone, Zone, QAfterFilterCondition> regionLessThan(
    String value, {
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

  QueryBuilder<Zone, Zone, QAfterFilterCondition> regionBetween(
    String lower,
    String upper, {
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

  QueryBuilder<Zone, Zone, QAfterFilterCondition> regionStartsWith(
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

  QueryBuilder<Zone, Zone, QAfterFilterCondition> regionEndsWith(
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

  QueryBuilder<Zone, Zone, QAfterFilterCondition> regionContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'region',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> regionMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'region',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> regionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'region',
        value: '',
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> regionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'region',
        value: '',
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> updatedAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> updatedAtGreaterThan(
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

  QueryBuilder<Zone, Zone, QAfterFilterCondition> updatedAtLessThan(
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

  QueryBuilder<Zone, Zone, QAfterFilterCondition> updatedAtBetween(
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

  QueryBuilder<Zone, Zone, QAfterFilterCondition> villeEqualTo(
    String value, {
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

  QueryBuilder<Zone, Zone, QAfterFilterCondition> villeGreaterThan(
    String value, {
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

  QueryBuilder<Zone, Zone, QAfterFilterCondition> villeLessThan(
    String value, {
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

  QueryBuilder<Zone, Zone, QAfterFilterCondition> villeBetween(
    String lower,
    String upper, {
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

  QueryBuilder<Zone, Zone, QAfterFilterCondition> villeStartsWith(
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

  QueryBuilder<Zone, Zone, QAfterFilterCondition> villeEndsWith(
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

  QueryBuilder<Zone, Zone, QAfterFilterCondition> villeContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ville',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> villeMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ville',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> villeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ville',
        value: '',
      ));
    });
  }

  QueryBuilder<Zone, Zone, QAfterFilterCondition> villeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ville',
        value: '',
      ));
    });
  }
}

extension ZoneQueryObject on QueryBuilder<Zone, Zone, QFilterCondition> {}

extension ZoneQueryLinks on QueryBuilder<Zone, Zone, QFilterCondition> {}

extension ZoneQuerySortBy on QueryBuilder<Zone, Zone, QSortBy> {
  QueryBuilder<Zone, Zone, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Zone, Zone, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Zone, Zone, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<Zone, Zone, QAfterSortBy> sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<Zone, Zone, QAfterSortBy> sortByIdZone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idZone', Sort.asc);
    });
  }

  QueryBuilder<Zone, Zone, QAfterSortBy> sortByIdZoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idZone', Sort.desc);
    });
  }

  QueryBuilder<Zone, Zone, QAfterSortBy> sortByLibele() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libele', Sort.asc);
    });
  }

  QueryBuilder<Zone, Zone, QAfterSortBy> sortByLibeleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libele', Sort.desc);
    });
  }

  QueryBuilder<Zone, Zone, QAfterSortBy> sortByLieuArrivee() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lieuArrivee', Sort.asc);
    });
  }

  QueryBuilder<Zone, Zone, QAfterSortBy> sortByLieuArriveeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lieuArrivee', Sort.desc);
    });
  }

  QueryBuilder<Zone, Zone, QAfterSortBy> sortByLieuDepart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lieuDepart', Sort.asc);
    });
  }

  QueryBuilder<Zone, Zone, QAfterSortBy> sortByLieuDepartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lieuDepart', Sort.desc);
    });
  }

  QueryBuilder<Zone, Zone, QAfterSortBy> sortByPays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pays', Sort.asc);
    });
  }

  QueryBuilder<Zone, Zone, QAfterSortBy> sortByPaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pays', Sort.desc);
    });
  }

  QueryBuilder<Zone, Zone, QAfterSortBy> sortByQuartier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quartier', Sort.asc);
    });
  }

  QueryBuilder<Zone, Zone, QAfterSortBy> sortByQuartierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quartier', Sort.desc);
    });
  }

  QueryBuilder<Zone, Zone, QAfterSortBy> sortByRegion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'region', Sort.asc);
    });
  }

  QueryBuilder<Zone, Zone, QAfterSortBy> sortByRegionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'region', Sort.desc);
    });
  }

  QueryBuilder<Zone, Zone, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Zone, Zone, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<Zone, Zone, QAfterSortBy> sortByVille() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ville', Sort.asc);
    });
  }

  QueryBuilder<Zone, Zone, QAfterSortBy> sortByVilleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ville', Sort.desc);
    });
  }
}

extension ZoneQuerySortThenBy on QueryBuilder<Zone, Zone, QSortThenBy> {
  QueryBuilder<Zone, Zone, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Zone, Zone, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Zone, Zone, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<Zone, Zone, QAfterSortBy> thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<Zone, Zone, QAfterSortBy> thenByIdZone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idZone', Sort.asc);
    });
  }

  QueryBuilder<Zone, Zone, QAfterSortBy> thenByIdZoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idZone', Sort.desc);
    });
  }

  QueryBuilder<Zone, Zone, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<Zone, Zone, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<Zone, Zone, QAfterSortBy> thenByLibele() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libele', Sort.asc);
    });
  }

  QueryBuilder<Zone, Zone, QAfterSortBy> thenByLibeleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libele', Sort.desc);
    });
  }

  QueryBuilder<Zone, Zone, QAfterSortBy> thenByLieuArrivee() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lieuArrivee', Sort.asc);
    });
  }

  QueryBuilder<Zone, Zone, QAfterSortBy> thenByLieuArriveeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lieuArrivee', Sort.desc);
    });
  }

  QueryBuilder<Zone, Zone, QAfterSortBy> thenByLieuDepart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lieuDepart', Sort.asc);
    });
  }

  QueryBuilder<Zone, Zone, QAfterSortBy> thenByLieuDepartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lieuDepart', Sort.desc);
    });
  }

  QueryBuilder<Zone, Zone, QAfterSortBy> thenByPays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pays', Sort.asc);
    });
  }

  QueryBuilder<Zone, Zone, QAfterSortBy> thenByPaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pays', Sort.desc);
    });
  }

  QueryBuilder<Zone, Zone, QAfterSortBy> thenByQuartier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quartier', Sort.asc);
    });
  }

  QueryBuilder<Zone, Zone, QAfterSortBy> thenByQuartierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quartier', Sort.desc);
    });
  }

  QueryBuilder<Zone, Zone, QAfterSortBy> thenByRegion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'region', Sort.asc);
    });
  }

  QueryBuilder<Zone, Zone, QAfterSortBy> thenByRegionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'region', Sort.desc);
    });
  }

  QueryBuilder<Zone, Zone, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Zone, Zone, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<Zone, Zone, QAfterSortBy> thenByVille() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ville', Sort.asc);
    });
  }

  QueryBuilder<Zone, Zone, QAfterSortBy> thenByVilleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ville', Sort.desc);
    });
  }
}

extension ZoneQueryWhereDistinct on QueryBuilder<Zone, Zone, QDistinct> {
  QueryBuilder<Zone, Zone, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<Zone, Zone, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Zone, Zone, QDistinct> distinctByIdZone(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idZone', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Zone, Zone, QDistinct> distinctByLibele(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libele', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Zone, Zone, QDistinct> distinctByLieuArrivee(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lieuArrivee', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Zone, Zone, QDistinct> distinctByLieuDepart(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lieuDepart', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Zone, Zone, QDistinct> distinctByPays(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pays', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Zone, Zone, QDistinct> distinctByQuartier(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'quartier', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Zone, Zone, QDistinct> distinctByRegion(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'region', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Zone, Zone, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<Zone, Zone, QDistinct> distinctByVille(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ville', caseSensitive: caseSensitive);
    });
  }
}

extension ZoneQueryProperty on QueryBuilder<Zone, Zone, QQueryProperty> {
  QueryBuilder<Zone, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<Zone, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<Zone, String, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<Zone, String, QQueryOperations> idZoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idZone');
    });
  }

  QueryBuilder<Zone, String, QQueryOperations> libeleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libele');
    });
  }

  QueryBuilder<Zone, String, QQueryOperations> lieuArriveeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lieuArrivee');
    });
  }

  QueryBuilder<Zone, String, QQueryOperations> lieuDepartProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lieuDepart');
    });
  }

  QueryBuilder<Zone, String, QQueryOperations> paysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pays');
    });
  }

  QueryBuilder<Zone, String, QQueryOperations> quartierProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'quartier');
    });
  }

  QueryBuilder<Zone, String, QQueryOperations> regionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'region');
    });
  }

  QueryBuilder<Zone, DateTime?, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<Zone, String, QQueryOperations> villeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ville');
    });
  }
}
