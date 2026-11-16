// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'limit_type.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const LimitType _$TRANSACTION = const LimitType._('TRANSACTION');
const LimitType _$DAILY = const LimitType._('DAILY');
const LimitType _$MONTHLY = const LimitType._('MONTHLY');
const LimitType _$FAMILY_MEMBER = const LimitType._('FAMILY_MEMBER');

LimitType _$valueOf(String name) {
  switch (name) {
    case 'TRANSACTION':
      return _$TRANSACTION;
    case 'DAILY':
      return _$DAILY;
    case 'MONTHLY':
      return _$MONTHLY;
    case 'FAMILY_MEMBER':
      return _$FAMILY_MEMBER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<LimitType> _$values = BuiltSet<LimitType>(const <LimitType>[
  _$TRANSACTION,
  _$DAILY,
  _$MONTHLY,
  _$FAMILY_MEMBER,
]);

class _$LimitTypeMeta {
  const _$LimitTypeMeta();
  LimitType get TRANSACTION => _$TRANSACTION;
  LimitType get DAILY => _$DAILY;
  LimitType get MONTHLY => _$MONTHLY;
  LimitType get FAMILY_MEMBER => _$FAMILY_MEMBER;
  LimitType valueOf(String name) => _$valueOf(name);
  BuiltSet<LimitType> get values => _$values;
}

mixin _$LimitTypeMixin {
  // ignore: non_constant_identifier_names
  _$LimitTypeMeta get LimitType => const _$LimitTypeMeta();
}

Serializer<LimitType> _$limitTypeSerializer = _$LimitTypeSerializer();

class _$LimitTypeSerializer implements PrimitiveSerializer<LimitType> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'TRANSACTION': 'TRANSACTION',
    'DAILY': 'DAILY',
    'MONTHLY': 'MONTHLY',
    'FAMILY_MEMBER': 'FAMILY_MEMBER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'TRANSACTION': 'TRANSACTION',
    'DAILY': 'DAILY',
    'MONTHLY': 'MONTHLY',
    'FAMILY_MEMBER': 'FAMILY_MEMBER',
  };

  @override
  final Iterable<Type> types = const <Type>[LimitType];
  @override
  final String wireName = 'LimitType';

  @override
  Object serialize(
    Serializers serializers,
    LimitType object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  LimitType deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => LimitType.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
