// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_type.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CreditType _$RESTAURATION = const CreditType._('RESTAURATION');
const CreditType _$HABILLEMENT = const CreditType._('HABILLEMENT');
const CreditType _$CARBURANT = const CreditType._('CARBURANT');
const CreditType _$CADEAUX = const CreditType._('CADEAUX');

CreditType _$valueOf(String name) {
  switch (name) {
    case 'RESTAURATION':
      return _$RESTAURATION;
    case 'HABILLEMENT':
      return _$HABILLEMENT;
    case 'CARBURANT':
      return _$CARBURANT;
    case 'CADEAUX':
      return _$CADEAUX;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CreditType> _$values = BuiltSet<CreditType>(const <CreditType>[
  _$RESTAURATION,
  _$HABILLEMENT,
  _$CARBURANT,
  _$CADEAUX,
]);

class _$CreditTypeMeta {
  const _$CreditTypeMeta();
  CreditType get RESTAURATION => _$RESTAURATION;
  CreditType get HABILLEMENT => _$HABILLEMENT;
  CreditType get CARBURANT => _$CARBURANT;
  CreditType get CADEAUX => _$CADEAUX;
  CreditType valueOf(String name) => _$valueOf(name);
  BuiltSet<CreditType> get values => _$values;
}

mixin _$CreditTypeMixin {
  // ignore: non_constant_identifier_names
  _$CreditTypeMeta get CreditType => const _$CreditTypeMeta();
}

Serializer<CreditType> _$creditTypeSerializer = _$CreditTypeSerializer();

class _$CreditTypeSerializer implements PrimitiveSerializer<CreditType> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'RESTAURATION': 'RESTAURATION',
    'HABILLEMENT': 'HABILLEMENT',
    'CARBURANT': 'CARBURANT',
    'CADEAUX': 'CADEAUX',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'RESTAURATION': 'RESTAURATION',
    'HABILLEMENT': 'HABILLEMENT',
    'CARBURANT': 'CARBURANT',
    'CADEAUX': 'CADEAUX',
  };

  @override
  final Iterable<Type> types = const <Type>[CreditType];
  @override
  final String wireName = 'CreditType';

  @override
  Object serialize(
    Serializers serializers,
    CreditType object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CreditType deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CreditType.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
