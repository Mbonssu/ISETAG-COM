// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../campaign.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCampagneCollection on Isar {
  IsarCollection<Campagne> get campagnes => this.collection();
}

const CampagneSchema = CollectionSchema(
  name: r'Campagne',
  id: -2628503973782610287,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'dateDebut': PropertySchema(
      id: 1,
      name: r'dateDebut',
      type: IsarType.dateTime,
    ),
    r'dateFin': PropertySchema(
      id: 2,
      name: r'dateFin',
      type: IsarType.dateTime,
    ),
    r'description': PropertySchema(
      id: 3,
      name: r'description',
      type: IsarType.string,
    ),
    r'idCampagne': PropertySchema(
      id: 4,
      name: r'idCampagne',
      type: IsarType.string,
    ),
    r'libele': PropertySchema(
      id: 5,
      name: r'libele',
      type: IsarType.string,
    ),
    r'objectif': PropertySchema(
      id: 6,
      name: r'objectif',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 7,
      name: r'type',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 8,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _campagneEstimateSize,
  serialize: _campagneSerialize,
  deserialize: _campagneDeserialize,
  deserializeProp: _campagneDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'idCampagne': IndexSchema(
      id: 6310864812943436991,
      name: r'idCampagne',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'idCampagne',
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
  getId: _campagneGetId,
  getLinks: _campagneGetLinks,
  attach: _campagneAttach,
  version: '3.3.2',
);

int _campagneEstimateSize(
  Campagne object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.description.length * 3;
  bytesCount += 3 + object.idCampagne.length * 3;
  bytesCount += 3 + object.libele.length * 3;
  bytesCount += 3 + object.objectif.length * 3;
  bytesCount += 3 + object.type.length * 3;
  return bytesCount;
}

void _campagneSerialize(
  Campagne object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeDateTime(offsets[1], object.dateDebut);
  writer.writeDateTime(offsets[2], object.dateFin);
  writer.writeString(offsets[3], object.description);
  writer.writeString(offsets[4], object.idCampagne);
  writer.writeString(offsets[5], object.libele);
  writer.writeString(offsets[6], object.objectif);
  writer.writeString(offsets[7], object.type);
  writer.writeDateTime(offsets[8], object.updatedAt);
}

Campagne _campagneDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Campagne(
    createdAt: reader.readDateTime(offsets[0]),
    dateDebut: reader.readDateTime(offsets[1]),
    dateFin: reader.readDateTime(offsets[2]),
    description: reader.readString(offsets[3]),
    idCampagne: reader.readString(offsets[4]),
    libele: reader.readString(offsets[5]),
    objectif: reader.readString(offsets[6]),
    type: reader.readString(offsets[7]),
    updatedAt: reader.readDateTimeOrNull(offsets[8]),
  );
  object.isarId = id;
  return object;
}

P _campagneDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
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
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _campagneGetId(Campagne object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _campagneGetLinks(Campagne object) {
  return [];
}

void _campagneAttach(IsarCollection<dynamic> col, Id id, Campagne object) {
  object.isarId = id;
}

extension CampagneByIndex on IsarCollection<Campagne> {
  Future<Campagne?> getByIdCampagne(String idCampagne) {
    return getByIndex(r'idCampagne', [idCampagne]);
  }

  Campagne? getByIdCampagneSync(String idCampagne) {
    return getByIndexSync(r'idCampagne', [idCampagne]);
  }

  Future<bool> deleteByIdCampagne(String idCampagne) {
    return deleteByIndex(r'idCampagne', [idCampagne]);
  }

  bool deleteByIdCampagneSync(String idCampagne) {
    return deleteByIndexSync(r'idCampagne', [idCampagne]);
  }

  Future<List<Campagne?>> getAllByIdCampagne(List<String> idCampagneValues) {
    final values = idCampagneValues.map((e) => [e]).toList();
    return getAllByIndex(r'idCampagne', values);
  }

  List<Campagne?> getAllByIdCampagneSync(List<String> idCampagneValues) {
    final values = idCampagneValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'idCampagne', values);
  }

  Future<int> deleteAllByIdCampagne(List<String> idCampagneValues) {
    final values = idCampagneValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'idCampagne', values);
  }

  int deleteAllByIdCampagneSync(List<String> idCampagneValues) {
    final values = idCampagneValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'idCampagne', values);
  }

  Future<Id> putByIdCampagne(Campagne object) {
    return putByIndex(r'idCampagne', object);
  }

  Id putByIdCampagneSync(Campagne object, {bool saveLinks = true}) {
    return putByIndexSync(r'idCampagne', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByIdCampagne(List<Campagne> objects) {
    return putAllByIndex(r'idCampagne', objects);
  }

  List<Id> putAllByIdCampagneSync(List<Campagne> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'idCampagne', objects, saveLinks: saveLinks);
  }
}

extension CampagneQueryWhereSort on QueryBuilder<Campagne, Campagne, QWhere> {
  QueryBuilder<Campagne, Campagne, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterWhere> anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }
}

extension CampagneQueryWhere on QueryBuilder<Campagne, Campagne, QWhereClause> {
  QueryBuilder<Campagne, Campagne, QAfterWhereClause> isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterWhereClause> isarIdNotEqualTo(
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

  QueryBuilder<Campagne, Campagne, QAfterWhereClause> isarIdGreaterThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterWhereClause> isarIdLessThan(Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterWhereClause> isarIdBetween(
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

  QueryBuilder<Campagne, Campagne, QAfterWhereClause> idCampagneEqualTo(
      String idCampagne) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'idCampagne',
        value: [idCampagne],
      ));
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterWhereClause> idCampagneNotEqualTo(
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

  QueryBuilder<Campagne, Campagne, QAfterWhereClause> libeleEqualTo(
      String libele) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'libele',
        value: [libele],
      ));
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterWhereClause> libeleNotEqualTo(
      String libele) {
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

  QueryBuilder<Campagne, Campagne, QAfterWhereClause> createdAtEqualTo(
      DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [createdAt],
      ));
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterWhereClause> createdAtNotEqualTo(
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

  QueryBuilder<Campagne, Campagne, QAfterWhereClause> createdAtGreaterThan(
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

  QueryBuilder<Campagne, Campagne, QAfterWhereClause> createdAtLessThan(
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

  QueryBuilder<Campagne, Campagne, QAfterWhereClause> createdAtBetween(
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

extension CampagneQueryFilter
    on QueryBuilder<Campagne, Campagne, QFilterCondition> {
  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> createdAtGreaterThan(
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

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> createdAtLessThan(
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

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> createdAtBetween(
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

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> dateDebutEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateDebut',
        value: value,
      ));
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> dateDebutGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateDebut',
        value: value,
      ));
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> dateDebutLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateDebut',
        value: value,
      ));
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> dateDebutBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateDebut',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> dateFinEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateFin',
        value: value,
      ));
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> dateFinGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateFin',
        value: value,
      ));
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> dateFinLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateFin',
        value: value,
      ));
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> dateFinBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateFin',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> descriptionEqualTo(
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

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition>
      descriptionGreaterThan(
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

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> descriptionLessThan(
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

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> descriptionBetween(
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

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> descriptionStartsWith(
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

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> descriptionEndsWith(
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

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> descriptionContains(
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

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> descriptionMatches(
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

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> idCampagneEqualTo(
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

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> idCampagneGreaterThan(
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

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> idCampagneLessThan(
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

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> idCampagneBetween(
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

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> idCampagneStartsWith(
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

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> idCampagneEndsWith(
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

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> idCampagneContains(
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

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> idCampagneMatches(
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

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> idCampagneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idCampagne',
        value: '',
      ));
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition>
      idCampagneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idCampagne',
        value: '',
      ));
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> isarIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> isarIdGreaterThan(
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

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> isarIdLessThan(
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

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> isarIdBetween(
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

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> libeleEqualTo(
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

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> libeleGreaterThan(
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

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> libeleLessThan(
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

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> libeleBetween(
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

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> libeleStartsWith(
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

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> libeleEndsWith(
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

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> libeleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'libele',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> libeleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'libele',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> libeleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'libele',
        value: '',
      ));
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> libeleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'libele',
        value: '',
      ));
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> objectifEqualTo(
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

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> objectifGreaterThan(
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

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> objectifLessThan(
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

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> objectifBetween(
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

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> objectifStartsWith(
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

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> objectifEndsWith(
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

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> objectifContains(
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

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> objectifMatches(
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

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> objectifIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'objectif',
        value: '',
      ));
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> objectifIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'objectif',
        value: '',
      ));
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> typeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> typeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> typeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> typeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> typeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> typeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> updatedAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> updatedAtGreaterThan(
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

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> updatedAtLessThan(
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

  QueryBuilder<Campagne, Campagne, QAfterFilterCondition> updatedAtBetween(
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

extension CampagneQueryObject
    on QueryBuilder<Campagne, Campagne, QFilterCondition> {}

extension CampagneQueryLinks
    on QueryBuilder<Campagne, Campagne, QFilterCondition> {}

extension CampagneQuerySortBy on QueryBuilder<Campagne, Campagne, QSortBy> {
  QueryBuilder<Campagne, Campagne, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterSortBy> sortByDateDebut() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateDebut', Sort.asc);
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterSortBy> sortByDateDebutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateDebut', Sort.desc);
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterSortBy> sortByDateFin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateFin', Sort.asc);
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterSortBy> sortByDateFinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateFin', Sort.desc);
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterSortBy> sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterSortBy> sortByIdCampagne() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idCampagne', Sort.asc);
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterSortBy> sortByIdCampagneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idCampagne', Sort.desc);
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterSortBy> sortByLibele() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libele', Sort.asc);
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterSortBy> sortByLibeleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libele', Sort.desc);
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterSortBy> sortByObjectif() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'objectif', Sort.asc);
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterSortBy> sortByObjectifDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'objectif', Sort.desc);
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension CampagneQuerySortThenBy
    on QueryBuilder<Campagne, Campagne, QSortThenBy> {
  QueryBuilder<Campagne, Campagne, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterSortBy> thenByDateDebut() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateDebut', Sort.asc);
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterSortBy> thenByDateDebutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateDebut', Sort.desc);
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterSortBy> thenByDateFin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateFin', Sort.asc);
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterSortBy> thenByDateFinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateFin', Sort.desc);
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterSortBy> thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterSortBy> thenByIdCampagne() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idCampagne', Sort.asc);
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterSortBy> thenByIdCampagneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idCampagne', Sort.desc);
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterSortBy> thenByLibele() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libele', Sort.asc);
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterSortBy> thenByLibeleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libele', Sort.desc);
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterSortBy> thenByObjectif() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'objectif', Sort.asc);
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterSortBy> thenByObjectifDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'objectif', Sort.desc);
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Campagne, Campagne, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension CampagneQueryWhereDistinct
    on QueryBuilder<Campagne, Campagne, QDistinct> {
  QueryBuilder<Campagne, Campagne, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<Campagne, Campagne, QDistinct> distinctByDateDebut() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateDebut');
    });
  }

  QueryBuilder<Campagne, Campagne, QDistinct> distinctByDateFin() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateFin');
    });
  }

  QueryBuilder<Campagne, Campagne, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Campagne, Campagne, QDistinct> distinctByIdCampagne(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idCampagne', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Campagne, Campagne, QDistinct> distinctByLibele(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libele', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Campagne, Campagne, QDistinct> distinctByObjectif(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'objectif', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Campagne, Campagne, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Campagne, Campagne, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension CampagneQueryProperty
    on QueryBuilder<Campagne, Campagne, QQueryProperty> {
  QueryBuilder<Campagne, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<Campagne, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<Campagne, DateTime, QQueryOperations> dateDebutProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateDebut');
    });
  }

  QueryBuilder<Campagne, DateTime, QQueryOperations> dateFinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateFin');
    });
  }

  QueryBuilder<Campagne, String, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<Campagne, String, QQueryOperations> idCampagneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idCampagne');
    });
  }

  QueryBuilder<Campagne, String, QQueryOperations> libeleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libele');
    });
  }

  QueryBuilder<Campagne, String, QQueryOperations> objectifProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'objectif');
    });
  }

  QueryBuilder<Campagne, String, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<Campagne, DateTime?, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
