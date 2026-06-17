// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../pros.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetProspectCollection on Isar {
  IsarCollection<Prospect> get prospects => this.collection();
}

const ProspectSchema = CollectionSchema(
  name: r'Prospect',
  id: 4947695656166374147,
  properties: {
    r'adresse': PropertySchema(
      id: 0,
      name: r'adresse',
      type: IsarType.string,
    ),
    r'commentaireGen': PropertySchema(
      id: 1,
      name: r'commentaireGen',
      type: IsarType.string,
    ),
    r'concerne': PropertySchema(
      id: 2,
      name: r'concerne',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 3,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'date_relance': PropertySchema(
      id: 4,
      name: r'date_relance',
      type: IsarType.dateTime,
    ),
    r'email': PropertySchema(
      id: 5,
      name: r'email',
      type: IsarType.string,
    ),
    r'idClass': PropertySchema(
      id: 6,
      name: r'idClass',
      type: IsarType.string,
    ),
    r'idProspect': PropertySchema(
      id: 7,
      name: r'idProspect',
      type: IsarType.string,
    ),
    r'idfiche': PropertySchema(
      id: 8,
      name: r'idfiche',
      type: IsarType.string,
    ),
    r'niveauEtude': PropertySchema(
      id: 9,
      name: r'niveauEtude',
      type: IsarType.string,
    ),
    r'nomComplet': PropertySchema(
      id: 10,
      name: r'nomComplet',
      type: IsarType.string,
    ),
    r'prospectStatus': PropertySchema(
      id: 11,
      name: r'prospectStatus',
      type: IsarType.byte,
      enumMap: _ProspectprospectStatusEnumValueMap,
    ),
    r'sexe': PropertySchema(
      id: 12,
      name: r'sexe',
      type: IsarType.string,
    ),
    r'syncState': PropertySchema(
      id: 13,
      name: r'syncState',
      type: IsarType.byte,
      enumMap: _ProspectsyncStateEnumValueMap,
    ),
    r'telephone': PropertySchema(
      id: 14,
      name: r'telephone',
      type: IsarType.string,
    ),
    r'typeProspect': PropertySchema(
      id: 15,
      name: r'typeProspect',
      type: IsarType.string,
    )
  },
  estimateSize: _prospectEstimateSize,
  serialize: _prospectSerialize,
  deserialize: _prospectDeserialize,
  deserializeProp: _prospectDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'idProspect': IndexSchema(
      id: -6185438842360057898,
      name: r'idProspect',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'idProspect',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'idClass': IndexSchema(
      id: 1087848779809501832,
      name: r'idClass',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'idClass',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'idfiche': IndexSchema(
      id: -4820543878540360906,
      name: r'idfiche',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'idfiche',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {
    r'fiche': LinkSchema(
      id: 6473745142241984652,
      name: r'fiche',
      target: r'Fiche',
      single: true,
    ),
    r'classe': LinkSchema(
      id: -6303243502520830532,
      name: r'classe',
      target: r'Classe',
      single: true,
    ),
    r'interets': LinkSchema(
      id: 3869511664831596049,
      name: r'interets',
      target: r'InteretFiliere',
      single: false,
      linkName: r'prospect',
    )
  },
  embeddedSchemas: {},
  getId: _prospectGetId,
  getLinks: _prospectGetLinks,
  attach: _prospectAttach,
  version: '3.1.0+1',
);

int _prospectEstimateSize(
  Prospect object,
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
  {
    final value = object.commentaireGen;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.concerne;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.email;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.idClass.length * 3;
  bytesCount += 3 + object.idProspect.length * 3;
  bytesCount += 3 + object.idfiche.length * 3;
  bytesCount += 3 + object.niveauEtude.length * 3;
  bytesCount += 3 + object.nomComplet.length * 3;
  bytesCount += 3 + object.sexe.length * 3;
  bytesCount += 3 + object.telephone.length * 3;
  bytesCount += 3 + object.typeProspect.length * 3;
  return bytesCount;
}

void _prospectSerialize(
  Prospect object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.adresse);
  writer.writeString(offsets[1], object.commentaireGen);
  writer.writeString(offsets[2], object.concerne);
  writer.writeDateTime(offsets[3], object.createdAt);
  writer.writeDateTime(offsets[4], object.date_relance);
  writer.writeString(offsets[5], object.email);
  writer.writeString(offsets[6], object.idClass);
  writer.writeString(offsets[7], object.idProspect);
  writer.writeString(offsets[8], object.idfiche);
  writer.writeString(offsets[9], object.niveauEtude);
  writer.writeString(offsets[10], object.nomComplet);
  writer.writeByte(offsets[11], object.prospectStatus.index);
  writer.writeString(offsets[12], object.sexe);
  writer.writeByte(offsets[13], object.syncState.index);
  writer.writeString(offsets[14], object.telephone);
  writer.writeString(offsets[15], object.typeProspect);
}

Prospect _prospectDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Prospect(
    adresse: reader.readStringOrNull(offsets[0]),
    commentaireGen: reader.readStringOrNull(offsets[1]),
    concerne: reader.readStringOrNull(offsets[2]),
    createdAt: reader.readDateTime(offsets[3]),
    date_relance: reader.readDateTimeOrNull(offsets[4]),
    email: reader.readStringOrNull(offsets[5]),
    idClass: reader.readString(offsets[6]),
    idProspect: reader.readString(offsets[7]),
    idfiche: reader.readString(offsets[8]),
    niveauEtude: reader.readString(offsets[9]),
    nomComplet: reader.readString(offsets[10]),
    prospectStatus: _ProspectprospectStatusValueEnumMap[
            reader.readByteOrNull(offsets[11])] ??
        ProspectStatus.relancer,
    sexe: reader.readString(offsets[12]),
    syncState:
        _ProspectsyncStateValueEnumMap[reader.readByteOrNull(offsets[13])] ??
            SyncState.pending,
    telephone: reader.readString(offsets[14]),
    typeProspect: reader.readString(offsets[15]),
  );
  object.isarId = id;
  return object;
}

P _prospectDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (_ProspectprospectStatusValueEnumMap[
              reader.readByteOrNull(offset)] ??
          ProspectStatus.relancer) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (_ProspectsyncStateValueEnumMap[reader.readByteOrNull(offset)] ??
          SyncState.pending) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _ProspectprospectStatusEnumValueMap = {
  'relancer': 0,
  'nouveau': 1,
  'contacte': 2,
};
const _ProspectprospectStatusValueEnumMap = {
  0: ProspectStatus.relancer,
  1: ProspectStatus.nouveau,
  2: ProspectStatus.contacte,
};
const _ProspectsyncStateEnumValueMap = {
  'pending': 0,
  'syncing': 1,
  'synced': 2,
  'failed': 3,
};
const _ProspectsyncStateValueEnumMap = {
  0: SyncState.pending,
  1: SyncState.syncing,
  2: SyncState.synced,
  3: SyncState.failed,
};

Id _prospectGetId(Prospect object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _prospectGetLinks(Prospect object) {
  return [object.fiche, object.classe, object.interets];
}

void _prospectAttach(IsarCollection<dynamic> col, Id id, Prospect object) {
  object.isarId = id;
  object.fiche.attach(col, col.isar.collection<Fiche>(), r'fiche', id);
  object.classe.attach(col, col.isar.collection<Classe>(), r'classe', id);
  object.interets
      .attach(col, col.isar.collection<InteretFiliere>(), r'interets', id);
}

extension ProspectByIndex on IsarCollection<Prospect> {
  Future<Prospect?> getByIdProspect(String idProspect) {
    return getByIndex(r'idProspect', [idProspect]);
  }

  Prospect? getByIdProspectSync(String idProspect) {
    return getByIndexSync(r'idProspect', [idProspect]);
  }

  Future<bool> deleteByIdProspect(String idProspect) {
    return deleteByIndex(r'idProspect', [idProspect]);
  }

  bool deleteByIdProspectSync(String idProspect) {
    return deleteByIndexSync(r'idProspect', [idProspect]);
  }

  Future<List<Prospect?>> getAllByIdProspect(List<String> idProspectValues) {
    final values = idProspectValues.map((e) => [e]).toList();
    return getAllByIndex(r'idProspect', values);
  }

  List<Prospect?> getAllByIdProspectSync(List<String> idProspectValues) {
    final values = idProspectValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'idProspect', values);
  }

  Future<int> deleteAllByIdProspect(List<String> idProspectValues) {
    final values = idProspectValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'idProspect', values);
  }

  int deleteAllByIdProspectSync(List<String> idProspectValues) {
    final values = idProspectValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'idProspect', values);
  }

  Future<Id> putByIdProspect(Prospect object) {
    return putByIndex(r'idProspect', object);
  }

  Id putByIdProspectSync(Prospect object, {bool saveLinks = true}) {
    return putByIndexSync(r'idProspect', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByIdProspect(List<Prospect> objects) {
    return putAllByIndex(r'idProspect', objects);
  }

  List<Id> putAllByIdProspectSync(List<Prospect> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'idProspect', objects, saveLinks: saveLinks);
  }
}

extension ProspectQueryWhereSort on QueryBuilder<Prospect, Prospect, QWhere> {
  QueryBuilder<Prospect, Prospect, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ProspectQueryWhere on QueryBuilder<Prospect, Prospect, QWhereClause> {
  QueryBuilder<Prospect, Prospect, QAfterWhereClause> isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterWhereClause> isarIdNotEqualTo(
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

  QueryBuilder<Prospect, Prospect, QAfterWhereClause> isarIdGreaterThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterWhereClause> isarIdLessThan(Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterWhereClause> isarIdBetween(
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

  QueryBuilder<Prospect, Prospect, QAfterWhereClause> idProspectEqualTo(
      String idProspect) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'idProspect',
        value: [idProspect],
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterWhereClause> idProspectNotEqualTo(
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

  QueryBuilder<Prospect, Prospect, QAfterWhereClause> idClassEqualTo(
      String idClass) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'idClass',
        value: [idClass],
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterWhereClause> idClassNotEqualTo(
      String idClass) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idClass',
              lower: [],
              upper: [idClass],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idClass',
              lower: [idClass],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idClass',
              lower: [idClass],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idClass',
              lower: [],
              upper: [idClass],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterWhereClause> idficheEqualTo(
      String idfiche) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'idfiche',
        value: [idfiche],
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterWhereClause> idficheNotEqualTo(
      String idfiche) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idfiche',
              lower: [],
              upper: [idfiche],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idfiche',
              lower: [idfiche],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idfiche',
              lower: [idfiche],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idfiche',
              lower: [],
              upper: [idfiche],
              includeUpper: false,
            ));
      }
    });
  }
}

extension ProspectQueryFilter
    on QueryBuilder<Prospect, Prospect, QFilterCondition> {
  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> adresseIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'adresse',
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> adresseIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'adresse',
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> adresseEqualTo(
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

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> adresseGreaterThan(
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

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> adresseLessThan(
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

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> adresseBetween(
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

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> adresseStartsWith(
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

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> adresseEndsWith(
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

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> adresseContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'adresse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> adresseMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'adresse',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> adresseIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'adresse',
        value: '',
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> adresseIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'adresse',
        value: '',
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition>
      commentaireGenIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'commentaireGen',
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition>
      commentaireGenIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'commentaireGen',
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> commentaireGenEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'commentaireGen',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition>
      commentaireGenGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'commentaireGen',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition>
      commentaireGenLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'commentaireGen',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> commentaireGenBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'commentaireGen',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition>
      commentaireGenStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'commentaireGen',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition>
      commentaireGenEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'commentaireGen',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition>
      commentaireGenContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'commentaireGen',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> commentaireGenMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'commentaireGen',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition>
      commentaireGenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'commentaireGen',
        value: '',
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition>
      commentaireGenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'commentaireGen',
        value: '',
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> concerneIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'concerne',
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> concerneIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'concerne',
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> concerneEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'concerne',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> concerneGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'concerne',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> concerneLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'concerne',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> concerneBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'concerne',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> concerneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'concerne',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> concerneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'concerne',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> concerneContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'concerne',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> concerneMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'concerne',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> concerneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'concerne',
        value: '',
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> concerneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'concerne',
        value: '',
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> createdAtGreaterThan(
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

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> createdAtLessThan(
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

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> createdAtBetween(
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

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> date_relanceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'date_relance',
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition>
      date_relanceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'date_relance',
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> date_relanceEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date_relance',
        value: value,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition>
      date_relanceGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date_relance',
        value: value,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> date_relanceLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date_relance',
        value: value,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> date_relanceBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date_relance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> emailIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'email',
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> emailIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'email',
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> emailEqualTo(
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

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> emailGreaterThan(
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

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> emailLessThan(
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

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> emailBetween(
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

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> emailStartsWith(
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

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> emailEndsWith(
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

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> emailContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> emailMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'email',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> emailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'email',
        value: '',
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> emailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'email',
        value: '',
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> idClassEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idClass',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> idClassGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idClass',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> idClassLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idClass',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> idClassBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idClass',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> idClassStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'idClass',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> idClassEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'idClass',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> idClassContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idClass',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> idClassMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idClass',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> idClassIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idClass',
        value: '',
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> idClassIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idClass',
        value: '',
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> idProspectEqualTo(
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

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> idProspectGreaterThan(
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

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> idProspectLessThan(
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

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> idProspectBetween(
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

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> idProspectStartsWith(
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

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> idProspectEndsWith(
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

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> idProspectContains(
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

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> idProspectMatches(
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

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> idProspectIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idProspect',
        value: '',
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition>
      idProspectIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idProspect',
        value: '',
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> idficheEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idfiche',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> idficheGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idfiche',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> idficheLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idfiche',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> idficheBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idfiche',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> idficheStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'idfiche',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> idficheEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'idfiche',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> idficheContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idfiche',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> idficheMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idfiche',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> idficheIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idfiche',
        value: '',
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> idficheIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idfiche',
        value: '',
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> isarIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> isarIdGreaterThan(
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

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> isarIdLessThan(
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

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> isarIdBetween(
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

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> niveauEtudeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'niveauEtude',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition>
      niveauEtudeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'niveauEtude',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> niveauEtudeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'niveauEtude',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> niveauEtudeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'niveauEtude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> niveauEtudeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'niveauEtude',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> niveauEtudeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'niveauEtude',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> niveauEtudeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'niveauEtude',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> niveauEtudeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'niveauEtude',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> niveauEtudeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'niveauEtude',
        value: '',
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition>
      niveauEtudeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'niveauEtude',
        value: '',
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> nomCompletEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nomComplet',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> nomCompletGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nomComplet',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> nomCompletLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nomComplet',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> nomCompletBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nomComplet',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> nomCompletStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nomComplet',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> nomCompletEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nomComplet',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> nomCompletContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nomComplet',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> nomCompletMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nomComplet',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> nomCompletIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nomComplet',
        value: '',
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition>
      nomCompletIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nomComplet',
        value: '',
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> prospectStatusEqualTo(
      ProspectStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'prospectStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition>
      prospectStatusGreaterThan(
    ProspectStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'prospectStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition>
      prospectStatusLessThan(
    ProspectStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'prospectStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> prospectStatusBetween(
    ProspectStatus lower,
    ProspectStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'prospectStatus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> sexeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sexe',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> sexeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sexe',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> sexeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sexe',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> sexeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sexe',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> sexeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sexe',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> sexeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sexe',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> sexeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sexe',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> sexeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sexe',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> sexeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sexe',
        value: '',
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> sexeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sexe',
        value: '',
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> syncStateEqualTo(
      SyncState value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncState',
        value: value,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> syncStateGreaterThan(
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

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> syncStateLessThan(
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

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> syncStateBetween(
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

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> telephoneEqualTo(
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

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> telephoneGreaterThan(
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

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> telephoneLessThan(
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

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> telephoneBetween(
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

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> telephoneStartsWith(
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

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> telephoneEndsWith(
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

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> telephoneContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'telephone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> telephoneMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'telephone',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> telephoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'telephone',
        value: '',
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition>
      telephoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'telephone',
        value: '',
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> typeProspectEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'typeProspect',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition>
      typeProspectGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'typeProspect',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> typeProspectLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'typeProspect',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> typeProspectBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'typeProspect',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition>
      typeProspectStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'typeProspect',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> typeProspectEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'typeProspect',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> typeProspectContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'typeProspect',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> typeProspectMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'typeProspect',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition>
      typeProspectIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'typeProspect',
        value: '',
      ));
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition>
      typeProspectIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'typeProspect',
        value: '',
      ));
    });
  }
}

extension ProspectQueryObject
    on QueryBuilder<Prospect, Prospect, QFilterCondition> {}

extension ProspectQueryLinks
    on QueryBuilder<Prospect, Prospect, QFilterCondition> {
  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> fiche(
      FilterQuery<Fiche> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'fiche');
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> ficheIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'fiche', 0, true, 0, true);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> classe(
      FilterQuery<Classe> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'classe');
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> classeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'classe', 0, true, 0, true);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> interets(
      FilterQuery<InteretFiliere> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'interets');
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> interetsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'interets', length, true, length, true);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> interetsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'interets', 0, true, 0, true);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> interetsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'interets', 0, false, 999999, true);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition>
      interetsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'interets', 0, true, length, include);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition>
      interetsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'interets', length, include, 999999, true);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterFilterCondition> interetsLengthBetween(
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

extension ProspectQuerySortBy on QueryBuilder<Prospect, Prospect, QSortBy> {
  QueryBuilder<Prospect, Prospect, QAfterSortBy> sortByAdresse() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'adresse', Sort.asc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> sortByAdresseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'adresse', Sort.desc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> sortByCommentaireGen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commentaireGen', Sort.asc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> sortByCommentaireGenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commentaireGen', Sort.desc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> sortByConcerne() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'concerne', Sort.asc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> sortByConcerneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'concerne', Sort.desc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> sortByDate_relance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date_relance', Sort.asc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> sortByDate_relanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date_relance', Sort.desc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> sortByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> sortByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> sortByIdClass() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idClass', Sort.asc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> sortByIdClassDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idClass', Sort.desc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> sortByIdProspect() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idProspect', Sort.asc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> sortByIdProspectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idProspect', Sort.desc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> sortByIdfiche() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idfiche', Sort.asc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> sortByIdficheDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idfiche', Sort.desc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> sortByNiveauEtude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'niveauEtude', Sort.asc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> sortByNiveauEtudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'niveauEtude', Sort.desc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> sortByNomComplet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nomComplet', Sort.asc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> sortByNomCompletDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nomComplet', Sort.desc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> sortByProspectStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prospectStatus', Sort.asc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> sortByProspectStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prospectStatus', Sort.desc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> sortBySexe() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sexe', Sort.asc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> sortBySexeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sexe', Sort.desc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> sortBySyncState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.asc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> sortBySyncStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.desc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> sortByTelephone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'telephone', Sort.asc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> sortByTelephoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'telephone', Sort.desc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> sortByTypeProspect() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeProspect', Sort.asc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> sortByTypeProspectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeProspect', Sort.desc);
    });
  }
}

extension ProspectQuerySortThenBy
    on QueryBuilder<Prospect, Prospect, QSortThenBy> {
  QueryBuilder<Prospect, Prospect, QAfterSortBy> thenByAdresse() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'adresse', Sort.asc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> thenByAdresseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'adresse', Sort.desc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> thenByCommentaireGen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commentaireGen', Sort.asc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> thenByCommentaireGenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commentaireGen', Sort.desc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> thenByConcerne() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'concerne', Sort.asc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> thenByConcerneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'concerne', Sort.desc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> thenByDate_relance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date_relance', Sort.asc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> thenByDate_relanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date_relance', Sort.desc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> thenByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> thenByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> thenByIdClass() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idClass', Sort.asc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> thenByIdClassDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idClass', Sort.desc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> thenByIdProspect() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idProspect', Sort.asc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> thenByIdProspectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idProspect', Sort.desc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> thenByIdfiche() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idfiche', Sort.asc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> thenByIdficheDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idfiche', Sort.desc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> thenByNiveauEtude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'niveauEtude', Sort.asc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> thenByNiveauEtudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'niveauEtude', Sort.desc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> thenByNomComplet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nomComplet', Sort.asc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> thenByNomCompletDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nomComplet', Sort.desc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> thenByProspectStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prospectStatus', Sort.asc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> thenByProspectStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prospectStatus', Sort.desc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> thenBySexe() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sexe', Sort.asc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> thenBySexeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sexe', Sort.desc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> thenBySyncState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.asc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> thenBySyncStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.desc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> thenByTelephone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'telephone', Sort.asc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> thenByTelephoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'telephone', Sort.desc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> thenByTypeProspect() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeProspect', Sort.asc);
    });
  }

  QueryBuilder<Prospect, Prospect, QAfterSortBy> thenByTypeProspectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeProspect', Sort.desc);
    });
  }
}

extension ProspectQueryWhereDistinct
    on QueryBuilder<Prospect, Prospect, QDistinct> {
  QueryBuilder<Prospect, Prospect, QDistinct> distinctByAdresse(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'adresse', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Prospect, Prospect, QDistinct> distinctByCommentaireGen(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'commentaireGen',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Prospect, Prospect, QDistinct> distinctByConcerne(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'concerne', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Prospect, Prospect, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<Prospect, Prospect, QDistinct> distinctByDate_relance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date_relance');
    });
  }

  QueryBuilder<Prospect, Prospect, QDistinct> distinctByEmail(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'email', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Prospect, Prospect, QDistinct> distinctByIdClass(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idClass', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Prospect, Prospect, QDistinct> distinctByIdProspect(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idProspect', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Prospect, Prospect, QDistinct> distinctByIdfiche(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idfiche', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Prospect, Prospect, QDistinct> distinctByNiveauEtude(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'niveauEtude', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Prospect, Prospect, QDistinct> distinctByNomComplet(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nomComplet', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Prospect, Prospect, QDistinct> distinctByProspectStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'prospectStatus');
    });
  }

  QueryBuilder<Prospect, Prospect, QDistinct> distinctBySexe(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sexe', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Prospect, Prospect, QDistinct> distinctBySyncState() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncState');
    });
  }

  QueryBuilder<Prospect, Prospect, QDistinct> distinctByTelephone(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'telephone', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Prospect, Prospect, QDistinct> distinctByTypeProspect(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'typeProspect', caseSensitive: caseSensitive);
    });
  }
}

extension ProspectQueryProperty
    on QueryBuilder<Prospect, Prospect, QQueryProperty> {
  QueryBuilder<Prospect, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<Prospect, String?, QQueryOperations> adresseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'adresse');
    });
  }

  QueryBuilder<Prospect, String?, QQueryOperations> commentaireGenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'commentaireGen');
    });
  }

  QueryBuilder<Prospect, String?, QQueryOperations> concerneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'concerne');
    });
  }

  QueryBuilder<Prospect, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<Prospect, DateTime?, QQueryOperations> date_relanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date_relance');
    });
  }

  QueryBuilder<Prospect, String?, QQueryOperations> emailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'email');
    });
  }

  QueryBuilder<Prospect, String, QQueryOperations> idClassProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idClass');
    });
  }

  QueryBuilder<Prospect, String, QQueryOperations> idProspectProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idProspect');
    });
  }

  QueryBuilder<Prospect, String, QQueryOperations> idficheProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idfiche');
    });
  }

  QueryBuilder<Prospect, String, QQueryOperations> niveauEtudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'niveauEtude');
    });
  }

  QueryBuilder<Prospect, String, QQueryOperations> nomCompletProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nomComplet');
    });
  }

  QueryBuilder<Prospect, ProspectStatus, QQueryOperations>
      prospectStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'prospectStatus');
    });
  }

  QueryBuilder<Prospect, String, QQueryOperations> sexeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sexe');
    });
  }

  QueryBuilder<Prospect, SyncState, QQueryOperations> syncStateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncState');
    });
  }

  QueryBuilder<Prospect, String, QQueryOperations> telephoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'telephone');
    });
  }

  QueryBuilder<Prospect, String, QQueryOperations> typeProspectProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'typeProspect');
    });
  }
}
