// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expired_credits_destination.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ExpiredCreditsDestination _$PLATFORM_REVENUE =
    const ExpiredCreditsDestination._('PLATFORM_REVENUE');
const ExpiredCreditsDestination _$COMPANY_RETURN =
    const ExpiredCreditsDestination._('COMPANY_RETURN');

ExpiredCreditsDestination _$valueOf(String name) {
  switch (name) {
    case 'PLATFORM_REVENUE':
      return _$PLATFORM_REVENUE;
    case 'COMPANY_RETURN':
      return _$COMPANY_RETURN;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ExpiredCreditsDestination> _$values =
    BuiltSet<ExpiredCreditsDestination>(const <ExpiredCreditsDestination>[
      _$PLATFORM_REVENUE,
      _$COMPANY_RETURN,
    ]);

class _$ExpiredCreditsDestinationMeta {
  const _$ExpiredCreditsDestinationMeta();
  ExpiredCreditsDestination get PLATFORM_REVENUE => _$PLATFORM_REVENUE;
  ExpiredCreditsDestination get COMPANY_RETURN => _$COMPANY_RETURN;
  ExpiredCreditsDestination valueOf(String name) => _$valueOf(name);
  BuiltSet<ExpiredCreditsDestination> get values => _$values;
}

mixin _$ExpiredCreditsDestinationMixin {
  // ignore: non_constant_identifier_names
  _$ExpiredCreditsDestinationMeta get ExpiredCreditsDestination =>
      const _$ExpiredCreditsDestinationMeta();
}

Serializer<ExpiredCreditsDestination> _$expiredCreditsDestinationSerializer =
    _$ExpiredCreditsDestinationSerializer();

class _$ExpiredCreditsDestinationSerializer
    implements PrimitiveSerializer<ExpiredCreditsDestination> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PLATFORM_REVENUE': 'PLATFORM_REVENUE',
    'COMPANY_RETURN': 'COMPANY_RETURN',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PLATFORM_REVENUE': 'PLATFORM_REVENUE',
    'COMPANY_RETURN': 'COMPANY_RETURN',
  };

  @override
  final Iterable<Type> types = const <Type>[ExpiredCreditsDestination];
  @override
  final String wireName = 'ExpiredCreditsDestination';

  @override
  Object serialize(
    Serializers serializers,
    ExpiredCreditsDestination object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  ExpiredCreditsDestination deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => ExpiredCreditsDestination.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
