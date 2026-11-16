// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_requester_type.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ContactRequesterType _$COMPANY = const ContactRequesterType._('COMPANY');
const ContactRequesterType _$MERCHANT = const ContactRequesterType._(
  'MERCHANT',
);
const ContactRequesterType _$OTHER = const ContactRequesterType._('OTHER');

ContactRequesterType _$valueOf(String name) {
  switch (name) {
    case 'COMPANY':
      return _$COMPANY;
    case 'MERCHANT':
      return _$MERCHANT;
    case 'OTHER':
      return _$OTHER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ContactRequesterType> _$values = BuiltSet<ContactRequesterType>(
  const <ContactRequesterType>[_$COMPANY, _$MERCHANT, _$OTHER],
);

class _$ContactRequesterTypeMeta {
  const _$ContactRequesterTypeMeta();
  ContactRequesterType get COMPANY => _$COMPANY;
  ContactRequesterType get MERCHANT => _$MERCHANT;
  ContactRequesterType get OTHER => _$OTHER;
  ContactRequesterType valueOf(String name) => _$valueOf(name);
  BuiltSet<ContactRequesterType> get values => _$values;
}

mixin _$ContactRequesterTypeMixin {
  // ignore: non_constant_identifier_names
  _$ContactRequesterTypeMeta get ContactRequesterType =>
      const _$ContactRequesterTypeMeta();
}

Serializer<ContactRequesterType> _$contactRequesterTypeSerializer =
    _$ContactRequesterTypeSerializer();

class _$ContactRequesterTypeSerializer
    implements PrimitiveSerializer<ContactRequesterType> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'COMPANY': 'COMPANY',
    'MERCHANT': 'MERCHANT',
    'OTHER': 'OTHER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'COMPANY': 'COMPANY',
    'MERCHANT': 'MERCHANT',
    'OTHER': 'OTHER',
  };

  @override
  final Iterable<Type> types = const <Type>[ContactRequesterType];
  @override
  final String wireName = 'ContactRequesterType';

  @override
  Object serialize(
    Serializers serializers,
    ContactRequesterType object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  ContactRequesterType deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => ContactRequesterType.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
