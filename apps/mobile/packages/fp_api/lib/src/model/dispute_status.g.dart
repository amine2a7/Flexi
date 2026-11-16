// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DisputeStatus _$OPEN = const DisputeStatus._('OPEN');
const DisputeStatus _$ACCEPTANCE_PENDING = const DisputeStatus._(
  'ACCEPTANCE_PENDING',
);
const DisputeStatus _$ACCEPTED = const DisputeStatus._('ACCEPTED');
const DisputeStatus _$REJECTED = const DisputeStatus._('REJECTED');

DisputeStatus _$valueOf(String name) {
  switch (name) {
    case 'OPEN':
      return _$OPEN;
    case 'ACCEPTANCE_PENDING':
      return _$ACCEPTANCE_PENDING;
    case 'ACCEPTED':
      return _$ACCEPTED;
    case 'REJECTED':
      return _$REJECTED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DisputeStatus> _$values = BuiltSet<DisputeStatus>(
  const <DisputeStatus>[_$OPEN, _$ACCEPTANCE_PENDING, _$ACCEPTED, _$REJECTED],
);

class _$DisputeStatusMeta {
  const _$DisputeStatusMeta();
  DisputeStatus get OPEN => _$OPEN;
  DisputeStatus get ACCEPTANCE_PENDING => _$ACCEPTANCE_PENDING;
  DisputeStatus get ACCEPTED => _$ACCEPTED;
  DisputeStatus get REJECTED => _$REJECTED;
  DisputeStatus valueOf(String name) => _$valueOf(name);
  BuiltSet<DisputeStatus> get values => _$values;
}

mixin _$DisputeStatusMixin {
  // ignore: non_constant_identifier_names
  _$DisputeStatusMeta get DisputeStatus => const _$DisputeStatusMeta();
}

Serializer<DisputeStatus> _$disputeStatusSerializer =
    _$DisputeStatusSerializer();

class _$DisputeStatusSerializer implements PrimitiveSerializer<DisputeStatus> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'OPEN': 'OPEN',
    'ACCEPTANCE_PENDING': 'ACCEPTANCE_PENDING',
    'ACCEPTED': 'ACCEPTED',
    'REJECTED': 'REJECTED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'OPEN': 'OPEN',
    'ACCEPTANCE_PENDING': 'ACCEPTANCE_PENDING',
    'ACCEPTED': 'ACCEPTED',
    'REJECTED': 'REJECTED',
  };

  @override
  final Iterable<Type> types = const <Type>[DisputeStatus];
  @override
  final String wireName = 'DisputeStatus';

  @override
  Object serialize(
    Serializers serializers,
    DisputeStatus object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  DisputeStatus deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => DisputeStatus.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
