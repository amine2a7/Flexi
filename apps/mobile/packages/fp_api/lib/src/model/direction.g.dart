// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'direction.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const Direction _$DEBIT = const Direction._('DEBIT');
const Direction _$CREDIT = const Direction._('CREDIT');

Direction _$valueOf(String name) {
  switch (name) {
    case 'DEBIT':
      return _$DEBIT;
    case 'CREDIT':
      return _$CREDIT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<Direction> _$values = BuiltSet<Direction>(const <Direction>[
  _$DEBIT,
  _$CREDIT,
]);

class _$DirectionMeta {
  const _$DirectionMeta();
  Direction get DEBIT => _$DEBIT;
  Direction get CREDIT => _$CREDIT;
  Direction valueOf(String name) => _$valueOf(name);
  BuiltSet<Direction> get values => _$values;
}

mixin _$DirectionMixin {
  // ignore: non_constant_identifier_names
  _$DirectionMeta get Direction => const _$DirectionMeta();
}

Serializer<Direction> _$directionSerializer = _$DirectionSerializer();

class _$DirectionSerializer implements PrimitiveSerializer<Direction> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DEBIT': 'DEBIT',
    'CREDIT': 'CREDIT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DEBIT': 'DEBIT',
    'CREDIT': 'CREDIT',
  };

  @override
  final Iterable<Type> types = const <Type>[Direction];
  @override
  final String wireName = 'Direction';

  @override
  Object serialize(
    Serializers serializers,
    Direction object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  Direction deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => Direction.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
