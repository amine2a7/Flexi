// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'approval_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ApprovalStatus _$PENDING = const ApprovalStatus._('PENDING');
const ApprovalStatus _$APPROVED = const ApprovalStatus._('APPROVED');
const ApprovalStatus _$REJECTED = const ApprovalStatus._('REJECTED');

ApprovalStatus _$valueOf(String name) {
  switch (name) {
    case 'PENDING':
      return _$PENDING;
    case 'APPROVED':
      return _$APPROVED;
    case 'REJECTED':
      return _$REJECTED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ApprovalStatus> _$values = BuiltSet<ApprovalStatus>(
  const <ApprovalStatus>[_$PENDING, _$APPROVED, _$REJECTED],
);

class _$ApprovalStatusMeta {
  const _$ApprovalStatusMeta();
  ApprovalStatus get PENDING => _$PENDING;
  ApprovalStatus get APPROVED => _$APPROVED;
  ApprovalStatus get REJECTED => _$REJECTED;
  ApprovalStatus valueOf(String name) => _$valueOf(name);
  BuiltSet<ApprovalStatus> get values => _$values;
}

mixin _$ApprovalStatusMixin {
  // ignore: non_constant_identifier_names
  _$ApprovalStatusMeta get ApprovalStatus => const _$ApprovalStatusMeta();
}

Serializer<ApprovalStatus> _$approvalStatusSerializer =
    _$ApprovalStatusSerializer();

class _$ApprovalStatusSerializer
    implements PrimitiveSerializer<ApprovalStatus> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PENDING': 'PENDING',
    'APPROVED': 'APPROVED',
    'REJECTED': 'REJECTED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PENDING': 'PENDING',
    'APPROVED': 'APPROVED',
    'REJECTED': 'REJECTED',
  };

  @override
  final Iterable<Type> types = const <Type>[ApprovalStatus];
  @override
  final String wireName = 'ApprovalStatus';

  @override
  Object serialize(
    Serializers serializers,
    ApprovalStatus object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  ApprovalStatus deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => ApprovalStatus.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
