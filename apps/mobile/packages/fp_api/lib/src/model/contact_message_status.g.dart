// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_message_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ContactMessageStatus _$NEW = const ContactMessageStatus._('NEW');
const ContactMessageStatus _$HANDLED = const ContactMessageStatus._('HANDLED');

ContactMessageStatus _$valueOf(String name) {
  switch (name) {
    case 'NEW':
      return _$NEW;
    case 'HANDLED':
      return _$HANDLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ContactMessageStatus> _$values = BuiltSet<ContactMessageStatus>(
  const <ContactMessageStatus>[_$NEW, _$HANDLED],
);

class _$ContactMessageStatusMeta {
  const _$ContactMessageStatusMeta();
  ContactMessageStatus get NEW => _$NEW;
  ContactMessageStatus get HANDLED => _$HANDLED;
  ContactMessageStatus valueOf(String name) => _$valueOf(name);
  BuiltSet<ContactMessageStatus> get values => _$values;
}

mixin _$ContactMessageStatusMixin {
  // ignore: non_constant_identifier_names
  _$ContactMessageStatusMeta get ContactMessageStatus =>
      const _$ContactMessageStatusMeta();
}

Serializer<ContactMessageStatus> _$contactMessageStatusSerializer =
    _$ContactMessageStatusSerializer();

class _$ContactMessageStatusSerializer
    implements PrimitiveSerializer<ContactMessageStatus> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'NEW': 'NEW',
    'HANDLED': 'HANDLED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'NEW': 'NEW',
    'HANDLED': 'HANDLED',
  };

  @override
  final Iterable<Type> types = const <Type>[ContactMessageStatus];
  @override
  final String wireName = 'ContactMessageStatus';

  @override
  Object serialize(
    Serializers serializers,
    ContactMessageStatus object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  ContactMessageStatus deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => ContactMessageStatus.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
