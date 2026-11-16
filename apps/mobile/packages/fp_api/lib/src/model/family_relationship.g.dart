// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_relationship.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const FamilyRelationship _$SPOUSE = const FamilyRelationship._('SPOUSE');
const FamilyRelationship _$CHILD = const FamilyRelationship._('CHILD');
const FamilyRelationship _$PARENT = const FamilyRelationship._('PARENT');

FamilyRelationship _$valueOf(String name) {
  switch (name) {
    case 'SPOUSE':
      return _$SPOUSE;
    case 'CHILD':
      return _$CHILD;
    case 'PARENT':
      return _$PARENT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FamilyRelationship> _$values = BuiltSet<FamilyRelationship>(
  const <FamilyRelationship>[_$SPOUSE, _$CHILD, _$PARENT],
);

class _$FamilyRelationshipMeta {
  const _$FamilyRelationshipMeta();
  FamilyRelationship get SPOUSE => _$SPOUSE;
  FamilyRelationship get CHILD => _$CHILD;
  FamilyRelationship get PARENT => _$PARENT;
  FamilyRelationship valueOf(String name) => _$valueOf(name);
  BuiltSet<FamilyRelationship> get values => _$values;
}

mixin _$FamilyRelationshipMixin {
  // ignore: non_constant_identifier_names
  _$FamilyRelationshipMeta get FamilyRelationship =>
      const _$FamilyRelationshipMeta();
}

Serializer<FamilyRelationship> _$familyRelationshipSerializer =
    _$FamilyRelationshipSerializer();

class _$FamilyRelationshipSerializer
    implements PrimitiveSerializer<FamilyRelationship> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'SPOUSE': 'SPOUSE',
    'CHILD': 'CHILD',
    'PARENT': 'PARENT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'SPOUSE': 'SPOUSE',
    'CHILD': 'CHILD',
    'PARENT': 'PARENT',
  };

  @override
  final Iterable<Type> types = const <Type>[FamilyRelationship];
  @override
  final String wireName = 'FamilyRelationship';

  @override
  Object serialize(
    Serializers serializers,
    FamilyRelationship object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  FamilyRelationship deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => FamilyRelationship.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
