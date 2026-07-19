// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../agent_commercial.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAgentCommercialCollection on Isar {
  IsarCollection<AgentCommercial> get agentCommercials => this.collection();
}

const AgentCommercialSchema = CollectionSchema(
  name: r'AgentCommercial',
  id: 293138451282123844,
  properties: {
    r'actif': PropertySchema(
      id: 0,
      name: r'actif',
      type: IsarType.bool,
    ),
    r'dateEmbauche': PropertySchema(
      id: 1,
      name: r'dateEmbauche',
      type: IsarType.dateTime,
    ),
    r'email': PropertySchema(
      id: 2,
      name: r'email',
      type: IsarType.string,
    ),
    r'fullName': PropertySchema(
      id: 3,
      name: r'fullName',
      type: IsarType.string,
    ),
    r'idAgent': PropertySchema(
      id: 4,
      name: r'idAgent',
      type: IsarType.string,
    ),
    r'idUtilisateur': PropertySchema(
      id: 5,
      name: r'idUtilisateur',
      type: IsarType.string,
    ),
    r'initials': PropertySchema(
      id: 6,
      name: r'initials',
      type: IsarType.string,
    ),
    r'isAdmin': PropertySchema(
      id: 7,
      name: r'isAdmin',
      type: IsarType.bool,
    ),
    r'isAgent': PropertySchema(
      id: 8,
      name: r'isAgent',
      type: IsarType.bool,
    ),
    r'isUser': PropertySchema(
      id: 9,
      name: r'isUser',
      type: IsarType.bool,
    ),
    r'matriculeAgent': PropertySchema(
      id: 10,
      name: r'matriculeAgent',
      type: IsarType.string,
    ),
    r'motDePasse': PropertySchema(
      id: 11,
      name: r'motDePasse',
      type: IsarType.string,
    ),
    r'nom': PropertySchema(
      id: 12,
      name: r'nom',
      type: IsarType.string,
    ),
    r'prenom': PropertySchema(
      id: 13,
      name: r'prenom',
      type: IsarType.string,
    ),
    r'role': PropertySchema(
      id: 14,
      name: r'role',
      type: IsarType.string,
    ),
    r'statut': PropertySchema(
      id: 15,
      name: r'statut',
      type: IsarType.string,
    ),
    r'telephone': PropertySchema(
      id: 16,
      name: r'telephone',
      type: IsarType.string,
    )
  },
  estimateSize: _agentCommercialEstimateSize,
  serialize: _agentCommercialSerialize,
  deserialize: _agentCommercialDeserialize,
  deserializeProp: _agentCommercialDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'idAgent': IndexSchema(
      id: -6587070005485103807,
      name: r'idAgent',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'idAgent',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'idUtilisateur': IndexSchema(
      id: -2294634762369527556,
      name: r'idUtilisateur',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'idUtilisateur',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'matriculeAgent': IndexSchema(
      id: 500781277297875947,
      name: r'matriculeAgent',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'matriculeAgent',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'dateEmbauche': IndexSchema(
      id: -8639793053137063976,
      name: r'dateEmbauche',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'dateEmbauche',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {
    r'user': LinkSchema(
      id: -7571735705712952966,
      name: r'user',
      target: r'User',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _agentCommercialGetId,
  getLinks: _agentCommercialGetLinks,
  attach: _agentCommercialAttach,
  version: '3.3.2',
);

int _agentCommercialEstimateSize(
  AgentCommercial object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.email;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.fullName.length * 3;
  bytesCount += 3 + object.idAgent.length * 3;
  bytesCount += 3 + object.idUtilisateur.length * 3;
  bytesCount += 3 + object.initials.length * 3;
  bytesCount += 3 + object.matriculeAgent.length * 3;
  bytesCount += 3 + object.motDePasse.length * 3;
  bytesCount += 3 + object.nom.length * 3;
  bytesCount += 3 + object.prenom.length * 3;
  bytesCount += 3 + object.role.length * 3;
  bytesCount += 3 + object.statut.length * 3;
  bytesCount += 3 + object.telephone.length * 3;
  return bytesCount;
}

void _agentCommercialSerialize(
  AgentCommercial object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.actif);
  writer.writeDateTime(offsets[1], object.dateEmbauche);
  writer.writeString(offsets[2], object.email);
  writer.writeString(offsets[3], object.fullName);
  writer.writeString(offsets[4], object.idAgent);
  writer.writeString(offsets[5], object.idUtilisateur);
  writer.writeString(offsets[6], object.initials);
  writer.writeBool(offsets[7], object.isAdmin);
  writer.writeBool(offsets[8], object.isAgent);
  writer.writeBool(offsets[9], object.isUser);
  writer.writeString(offsets[10], object.matriculeAgent);
  writer.writeString(offsets[11], object.motDePasse);
  writer.writeString(offsets[12], object.nom);
  writer.writeString(offsets[13], object.prenom);
  writer.writeString(offsets[14], object.role);
  writer.writeString(offsets[15], object.statut);
  writer.writeString(offsets[16], object.telephone);
}

AgentCommercial _agentCommercialDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AgentCommercial(
    dateEmbauche: reader.readDateTime(offsets[1]),
    idAgent: reader.readString(offsets[4]),
    idUtilisateur: reader.readString(offsets[5]),
    matriculeAgent: reader.readString(offsets[10]),
    statut: reader.readStringOrNull(offsets[15]) ?? 'Actif',
  );
  object.isarId = id;
  return object;
}

P _agentCommercialDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readStringOrNull(offset) ?? 'Actif') as P;
    case 16:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _agentCommercialGetId(AgentCommercial object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _agentCommercialGetLinks(AgentCommercial object) {
  return [object.user];
}

void _agentCommercialAttach(
    IsarCollection<dynamic> col, Id id, AgentCommercial object) {
  object.isarId = id;
  object.user.attach(col, col.isar.collection<User>(), r'user', id);
}

extension AgentCommercialByIndex on IsarCollection<AgentCommercial> {
  Future<AgentCommercial?> getByIdAgent(String idAgent) {
    return getByIndex(r'idAgent', [idAgent]);
  }

  AgentCommercial? getByIdAgentSync(String idAgent) {
    return getByIndexSync(r'idAgent', [idAgent]);
  }

  Future<bool> deleteByIdAgent(String idAgent) {
    return deleteByIndex(r'idAgent', [idAgent]);
  }

  bool deleteByIdAgentSync(String idAgent) {
    return deleteByIndexSync(r'idAgent', [idAgent]);
  }

  Future<List<AgentCommercial?>> getAllByIdAgent(List<String> idAgentValues) {
    final values = idAgentValues.map((e) => [e]).toList();
    return getAllByIndex(r'idAgent', values);
  }

  List<AgentCommercial?> getAllByIdAgentSync(List<String> idAgentValues) {
    final values = idAgentValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'idAgent', values);
  }

  Future<int> deleteAllByIdAgent(List<String> idAgentValues) {
    final values = idAgentValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'idAgent', values);
  }

  int deleteAllByIdAgentSync(List<String> idAgentValues) {
    final values = idAgentValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'idAgent', values);
  }

  Future<Id> putByIdAgent(AgentCommercial object) {
    return putByIndex(r'idAgent', object);
  }

  Id putByIdAgentSync(AgentCommercial object, {bool saveLinks = true}) {
    return putByIndexSync(r'idAgent', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByIdAgent(List<AgentCommercial> objects) {
    return putAllByIndex(r'idAgent', objects);
  }

  List<Id> putAllByIdAgentSync(List<AgentCommercial> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'idAgent', objects, saveLinks: saveLinks);
  }
}

extension AgentCommercialQueryWhereSort
    on QueryBuilder<AgentCommercial, AgentCommercial, QWhere> {
  QueryBuilder<AgentCommercial, AgentCommercial, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterWhere>
      anyDateEmbauche() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'dateEmbauche'),
      );
    });
  }
}

extension AgentCommercialQueryWhere
    on QueryBuilder<AgentCommercial, AgentCommercial, QWhereClause> {
  QueryBuilder<AgentCommercial, AgentCommercial, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterWhereClause>
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

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterWhereClause>
      isarIdBetween(
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

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterWhereClause>
      idAgentEqualTo(String idAgent) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'idAgent',
        value: [idAgent],
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterWhereClause>
      idAgentNotEqualTo(String idAgent) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idAgent',
              lower: [],
              upper: [idAgent],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idAgent',
              lower: [idAgent],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idAgent',
              lower: [idAgent],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idAgent',
              lower: [],
              upper: [idAgent],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterWhereClause>
      idUtilisateurEqualTo(String idUtilisateur) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'idUtilisateur',
        value: [idUtilisateur],
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterWhereClause>
      idUtilisateurNotEqualTo(String idUtilisateur) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idUtilisateur',
              lower: [],
              upper: [idUtilisateur],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idUtilisateur',
              lower: [idUtilisateur],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idUtilisateur',
              lower: [idUtilisateur],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idUtilisateur',
              lower: [],
              upper: [idUtilisateur],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterWhereClause>
      matriculeAgentEqualTo(String matriculeAgent) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'matriculeAgent',
        value: [matriculeAgent],
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterWhereClause>
      matriculeAgentNotEqualTo(String matriculeAgent) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'matriculeAgent',
              lower: [],
              upper: [matriculeAgent],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'matriculeAgent',
              lower: [matriculeAgent],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'matriculeAgent',
              lower: [matriculeAgent],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'matriculeAgent',
              lower: [],
              upper: [matriculeAgent],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterWhereClause>
      dateEmbaucheEqualTo(DateTime dateEmbauche) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'dateEmbauche',
        value: [dateEmbauche],
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterWhereClause>
      dateEmbaucheNotEqualTo(DateTime dateEmbauche) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateEmbauche',
              lower: [],
              upper: [dateEmbauche],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateEmbauche',
              lower: [dateEmbauche],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateEmbauche',
              lower: [dateEmbauche],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateEmbauche',
              lower: [],
              upper: [dateEmbauche],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterWhereClause>
      dateEmbaucheGreaterThan(
    DateTime dateEmbauche, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dateEmbauche',
        lower: [dateEmbauche],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterWhereClause>
      dateEmbaucheLessThan(
    DateTime dateEmbauche, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dateEmbauche',
        lower: [],
        upper: [dateEmbauche],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterWhereClause>
      dateEmbaucheBetween(
    DateTime lowerDateEmbauche,
    DateTime upperDateEmbauche, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dateEmbauche',
        lower: [lowerDateEmbauche],
        includeLower: includeLower,
        upper: [upperDateEmbauche],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AgentCommercialQueryFilter
    on QueryBuilder<AgentCommercial, AgentCommercial, QFilterCondition> {
  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      actifEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actif',
        value: value,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      dateEmbaucheEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateEmbauche',
        value: value,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      dateEmbaucheGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateEmbauche',
        value: value,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      dateEmbaucheLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateEmbauche',
        value: value,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      dateEmbaucheBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateEmbauche',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      emailIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'email',
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      emailIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'email',
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      emailEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      emailGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      emailLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      emailBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'email',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      emailStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      emailEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      emailContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      emailMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'email',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      emailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'email',
        value: '',
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      emailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'email',
        value: '',
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      fullNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fullName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      fullNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fullName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      fullNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fullName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      fullNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fullName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      fullNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fullName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      fullNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fullName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      fullNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fullName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      fullNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fullName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      fullNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fullName',
        value: '',
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      fullNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fullName',
        value: '',
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      idAgentEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idAgent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      idAgentGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idAgent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      idAgentLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idAgent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      idAgentBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idAgent',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      idAgentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'idAgent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      idAgentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'idAgent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      idAgentContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idAgent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      idAgentMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idAgent',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      idAgentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idAgent',
        value: '',
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      idAgentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idAgent',
        value: '',
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      idUtilisateurEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idUtilisateur',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      idUtilisateurGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idUtilisateur',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      idUtilisateurLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idUtilisateur',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      idUtilisateurBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idUtilisateur',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      idUtilisateurStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'idUtilisateur',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      idUtilisateurEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'idUtilisateur',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      idUtilisateurContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idUtilisateur',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      idUtilisateurMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idUtilisateur',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      idUtilisateurIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idUtilisateur',
        value: '',
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      idUtilisateurIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idUtilisateur',
        value: '',
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      initialsEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'initials',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      initialsGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'initials',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      initialsLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'initials',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      initialsBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'initials',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      initialsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'initials',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      initialsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'initials',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      initialsContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'initials',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      initialsMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'initials',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      initialsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'initials',
        value: '',
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      initialsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'initials',
        value: '',
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      isAdminEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isAdmin',
        value: value,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      isAgentEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isAgent',
        value: value,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      isUserEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isUser',
        value: value,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
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

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
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

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
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

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      matriculeAgentEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'matriculeAgent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      matriculeAgentGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'matriculeAgent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      matriculeAgentLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'matriculeAgent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      matriculeAgentBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'matriculeAgent',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      matriculeAgentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'matriculeAgent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      matriculeAgentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'matriculeAgent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      matriculeAgentContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'matriculeAgent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      matriculeAgentMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'matriculeAgent',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      matriculeAgentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'matriculeAgent',
        value: '',
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      matriculeAgentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'matriculeAgent',
        value: '',
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      motDePasseEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'motDePasse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      motDePasseGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'motDePasse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      motDePasseLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'motDePasse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      motDePasseBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'motDePasse',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      motDePasseStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'motDePasse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      motDePasseEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'motDePasse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      motDePasseContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'motDePasse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      motDePasseMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'motDePasse',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      motDePasseIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'motDePasse',
        value: '',
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      motDePasseIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'motDePasse',
        value: '',
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      nomEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      nomGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      nomLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      nomBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nom',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      nomStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      nomEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      nomContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      nomMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nom',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      nomIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nom',
        value: '',
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      nomIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nom',
        value: '',
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      prenomEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'prenom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      prenomGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'prenom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      prenomLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'prenom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      prenomBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'prenom',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      prenomStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'prenom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      prenomEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'prenom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      prenomContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'prenom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      prenomMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'prenom',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      prenomIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'prenom',
        value: '',
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      prenomIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'prenom',
        value: '',
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      roleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'role',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      roleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'role',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      roleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'role',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      roleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'role',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      roleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'role',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      roleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'role',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      roleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'role',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      roleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'role',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      roleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'role',
        value: '',
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      roleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'role',
        value: '',
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      statutEqualTo(
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

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      statutGreaterThan(
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

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      statutLessThan(
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

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      statutBetween(
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

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      statutStartsWith(
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

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      statutEndsWith(
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

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      statutContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'statut',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      statutMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'statut',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      statutIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'statut',
        value: '',
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      statutIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'statut',
        value: '',
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      telephoneEqualTo(
    String value, {
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

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      telephoneGreaterThan(
    String value, {
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

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      telephoneLessThan(
    String value, {
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

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      telephoneBetween(
    String lower,
    String upper, {
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

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
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

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
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

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      telephoneContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'telephone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      telephoneMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'telephone',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      telephoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'telephone',
        value: '',
      ));
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      telephoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'telephone',
        value: '',
      ));
    });
  }
}

extension AgentCommercialQueryObject
    on QueryBuilder<AgentCommercial, AgentCommercial, QFilterCondition> {}

extension AgentCommercialQueryLinks
    on QueryBuilder<AgentCommercial, AgentCommercial, QFilterCondition> {
  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition> user(
      FilterQuery<User> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'user');
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterFilterCondition>
      userIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'user', 0, true, 0, true);
    });
  }
}

extension AgentCommercialQuerySortBy
    on QueryBuilder<AgentCommercial, AgentCommercial, QSortBy> {
  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy> sortByActif() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actif', Sort.asc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      sortByActifDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actif', Sort.desc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      sortByDateEmbauche() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateEmbauche', Sort.asc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      sortByDateEmbaucheDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateEmbauche', Sort.desc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy> sortByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      sortByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      sortByFullName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullName', Sort.asc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      sortByFullNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullName', Sort.desc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy> sortByIdAgent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idAgent', Sort.asc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      sortByIdAgentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idAgent', Sort.desc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      sortByIdUtilisateur() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idUtilisateur', Sort.asc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      sortByIdUtilisateurDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idUtilisateur', Sort.desc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      sortByInitials() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'initials', Sort.asc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      sortByInitialsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'initials', Sort.desc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy> sortByIsAdmin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAdmin', Sort.asc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      sortByIsAdminDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAdmin', Sort.desc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy> sortByIsAgent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAgent', Sort.asc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      sortByIsAgentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAgent', Sort.desc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy> sortByIsUser() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isUser', Sort.asc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      sortByIsUserDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isUser', Sort.desc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      sortByMatriculeAgent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matriculeAgent', Sort.asc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      sortByMatriculeAgentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matriculeAgent', Sort.desc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      sortByMotDePasse() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'motDePasse', Sort.asc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      sortByMotDePasseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'motDePasse', Sort.desc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy> sortByNom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nom', Sort.asc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy> sortByNomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nom', Sort.desc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy> sortByPrenom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prenom', Sort.asc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      sortByPrenomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prenom', Sort.desc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy> sortByRole() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'role', Sort.asc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      sortByRoleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'role', Sort.desc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy> sortByStatut() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statut', Sort.asc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      sortByStatutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statut', Sort.desc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      sortByTelephone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'telephone', Sort.asc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      sortByTelephoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'telephone', Sort.desc);
    });
  }
}

extension AgentCommercialQuerySortThenBy
    on QueryBuilder<AgentCommercial, AgentCommercial, QSortThenBy> {
  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy> thenByActif() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actif', Sort.asc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      thenByActifDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actif', Sort.desc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      thenByDateEmbauche() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateEmbauche', Sort.asc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      thenByDateEmbaucheDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateEmbauche', Sort.desc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy> thenByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      thenByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      thenByFullName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullName', Sort.asc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      thenByFullNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullName', Sort.desc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy> thenByIdAgent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idAgent', Sort.asc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      thenByIdAgentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idAgent', Sort.desc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      thenByIdUtilisateur() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idUtilisateur', Sort.asc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      thenByIdUtilisateurDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idUtilisateur', Sort.desc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      thenByInitials() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'initials', Sort.asc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      thenByInitialsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'initials', Sort.desc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy> thenByIsAdmin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAdmin', Sort.asc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      thenByIsAdminDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAdmin', Sort.desc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy> thenByIsAgent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAgent', Sort.asc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      thenByIsAgentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAgent', Sort.desc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy> thenByIsUser() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isUser', Sort.asc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      thenByIsUserDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isUser', Sort.desc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      thenByMatriculeAgent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matriculeAgent', Sort.asc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      thenByMatriculeAgentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matriculeAgent', Sort.desc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      thenByMotDePasse() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'motDePasse', Sort.asc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      thenByMotDePasseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'motDePasse', Sort.desc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy> thenByNom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nom', Sort.asc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy> thenByNomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nom', Sort.desc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy> thenByPrenom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prenom', Sort.asc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      thenByPrenomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prenom', Sort.desc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy> thenByRole() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'role', Sort.asc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      thenByRoleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'role', Sort.desc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy> thenByStatut() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statut', Sort.asc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      thenByStatutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statut', Sort.desc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      thenByTelephone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'telephone', Sort.asc);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QAfterSortBy>
      thenByTelephoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'telephone', Sort.desc);
    });
  }
}

extension AgentCommercialQueryWhereDistinct
    on QueryBuilder<AgentCommercial, AgentCommercial, QDistinct> {
  QueryBuilder<AgentCommercial, AgentCommercial, QDistinct> distinctByActif() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'actif');
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QDistinct>
      distinctByDateEmbauche() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateEmbauche');
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QDistinct> distinctByEmail(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'email', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QDistinct> distinctByFullName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fullName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QDistinct> distinctByIdAgent(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idAgent', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QDistinct>
      distinctByIdUtilisateur({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idUtilisateur',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QDistinct> distinctByInitials(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'initials', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QDistinct>
      distinctByIsAdmin() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isAdmin');
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QDistinct>
      distinctByIsAgent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isAgent');
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QDistinct> distinctByIsUser() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isUser');
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QDistinct>
      distinctByMatriculeAgent({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'matriculeAgent',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QDistinct>
      distinctByMotDePasse({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'motDePasse', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QDistinct> distinctByNom(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nom', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QDistinct> distinctByPrenom(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'prenom', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QDistinct> distinctByRole(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'role', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QDistinct> distinctByStatut(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'statut', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AgentCommercial, AgentCommercial, QDistinct> distinctByTelephone(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'telephone', caseSensitive: caseSensitive);
    });
  }
}

extension AgentCommercialQueryProperty
    on QueryBuilder<AgentCommercial, AgentCommercial, QQueryProperty> {
  QueryBuilder<AgentCommercial, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<AgentCommercial, bool, QQueryOperations> actifProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'actif');
    });
  }

  QueryBuilder<AgentCommercial, DateTime, QQueryOperations>
      dateEmbaucheProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateEmbauche');
    });
  }

  QueryBuilder<AgentCommercial, String?, QQueryOperations> emailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'email');
    });
  }

  QueryBuilder<AgentCommercial, String, QQueryOperations> fullNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fullName');
    });
  }

  QueryBuilder<AgentCommercial, String, QQueryOperations> idAgentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idAgent');
    });
  }

  QueryBuilder<AgentCommercial, String, QQueryOperations>
      idUtilisateurProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idUtilisateur');
    });
  }

  QueryBuilder<AgentCommercial, String, QQueryOperations> initialsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'initials');
    });
  }

  QueryBuilder<AgentCommercial, bool, QQueryOperations> isAdminProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isAdmin');
    });
  }

  QueryBuilder<AgentCommercial, bool, QQueryOperations> isAgentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isAgent');
    });
  }

  QueryBuilder<AgentCommercial, bool, QQueryOperations> isUserProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isUser');
    });
  }

  QueryBuilder<AgentCommercial, String, QQueryOperations>
      matriculeAgentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'matriculeAgent');
    });
  }

  QueryBuilder<AgentCommercial, String, QQueryOperations> motDePasseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'motDePasse');
    });
  }

  QueryBuilder<AgentCommercial, String, QQueryOperations> nomProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nom');
    });
  }

  QueryBuilder<AgentCommercial, String, QQueryOperations> prenomProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'prenom');
    });
  }

  QueryBuilder<AgentCommercial, String, QQueryOperations> roleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'role');
    });
  }

  QueryBuilder<AgentCommercial, String, QQueryOperations> statutProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'statut');
    });
  }

  QueryBuilder<AgentCommercial, String, QQueryOperations> telephoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'telephone');
    });
  }
}
