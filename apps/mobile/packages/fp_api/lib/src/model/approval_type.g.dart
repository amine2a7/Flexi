// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'approval_type.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ApprovalType _$COMMISSION_RATE_CHANGE = const ApprovalType._(
  'COMMISSION_RATE_CHANGE',
);
const ApprovalType _$SETTINGS_CHANGE = const ApprovalType._('SETTINGS_CHANGE');
const ApprovalType _$DISPUTE_REFUND = const ApprovalType._('DISPUTE_REFUND');
const ApprovalType _$COMMISSION_GRID_CHANGE = const ApprovalType._(
  'COMMISSION_GRID_CHANGE',
);
const ApprovalType _$IBAN_CHANGE = const ApprovalType._('IBAN_CHANGE');
const ApprovalType _$BATCH_RELEASE = const ApprovalType._('BATCH_RELEASE');
const ApprovalType _$LEGAL_FORM_CHANGE = const ApprovalType._(
  'LEGAL_FORM_CHANGE',
);

ApprovalType _$valueOf(String name) {
  switch (name) {
    case 'COMMISSION_RATE_CHANGE':
      return _$COMMISSION_RATE_CHANGE;
    case 'SETTINGS_CHANGE':
      return _$SETTINGS_CHANGE;
    case 'DISPUTE_REFUND':
      return _$DISPUTE_REFUND;
    case 'COMMISSION_GRID_CHANGE':
      return _$COMMISSION_GRID_CHANGE;
    case 'IBAN_CHANGE':
      return _$IBAN_CHANGE;
    case 'BATCH_RELEASE':
      return _$BATCH_RELEASE;
    case 'LEGAL_FORM_CHANGE':
      return _$LEGAL_FORM_CHANGE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ApprovalType> _$values = BuiltSet<ApprovalType>(
  const <ApprovalType>[
    _$COMMISSION_RATE_CHANGE,
    _$SETTINGS_CHANGE,
    _$DISPUTE_REFUND,
    _$COMMISSION_GRID_CHANGE,
    _$IBAN_CHANGE,
    _$BATCH_RELEASE,
    _$LEGAL_FORM_CHANGE,
  ],
);

class _$ApprovalTypeMeta {
  const _$ApprovalTypeMeta();
  ApprovalType get COMMISSION_RATE_CHANGE => _$COMMISSION_RATE_CHANGE;
  ApprovalType get SETTINGS_CHANGE => _$SETTINGS_CHANGE;
  ApprovalType get DISPUTE_REFUND => _$DISPUTE_REFUND;
  ApprovalType get COMMISSION_GRID_CHANGE => _$COMMISSION_GRID_CHANGE;
  ApprovalType get IBAN_CHANGE => _$IBAN_CHANGE;
  ApprovalType get BATCH_RELEASE => _$BATCH_RELEASE;
  ApprovalType get LEGAL_FORM_CHANGE => _$LEGAL_FORM_CHANGE;
  ApprovalType valueOf(String name) => _$valueOf(name);
  BuiltSet<ApprovalType> get values => _$values;
}

mixin _$ApprovalTypeMixin {
  // ignore: non_constant_identifier_names
  _$ApprovalTypeMeta get ApprovalType => const _$ApprovalTypeMeta();
}

Serializer<ApprovalType> _$approvalTypeSerializer = _$ApprovalTypeSerializer();

class _$ApprovalTypeSerializer implements PrimitiveSerializer<ApprovalType> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'COMMISSION_RATE_CHANGE': 'COMMISSION_RATE_CHANGE',
    'SETTINGS_CHANGE': 'SETTINGS_CHANGE',
    'DISPUTE_REFUND': 'DISPUTE_REFUND',
    'COMMISSION_GRID_CHANGE': 'COMMISSION_GRID_CHANGE',
    'IBAN_CHANGE': 'IBAN_CHANGE',
    'BATCH_RELEASE': 'BATCH_RELEASE',
    'LEGAL_FORM_CHANGE': 'LEGAL_FORM_CHANGE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'COMMISSION_RATE_CHANGE': 'COMMISSION_RATE_CHANGE',
    'SETTINGS_CHANGE': 'SETTINGS_CHANGE',
    'DISPUTE_REFUND': 'DISPUTE_REFUND',
    'COMMISSION_GRID_CHANGE': 'COMMISSION_GRID_CHANGE',
    'IBAN_CHANGE': 'IBAN_CHANGE',
    'BATCH_RELEASE': 'BATCH_RELEASE',
    'LEGAL_FORM_CHANGE': 'LEGAL_FORM_CHANGE',
  };

  @override
  final Iterable<Type> types = const <Type>[ApprovalType];
  @override
  final String wireName = 'ApprovalType';

  @override
  Object serialize(
    Serializers serializers,
    ApprovalType object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  ApprovalType deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => ApprovalType.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
