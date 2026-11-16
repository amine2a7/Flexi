// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_order_event_action.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CreditOrderEventAction _$CREATED = const CreditOrderEventAction._(
  'CREATED',
);
const CreditOrderEventAction _$CONFIRMED = const CreditOrderEventAction._(
  'CONFIRMED',
);
const CreditOrderEventAction _$REFUSED = const CreditOrderEventAction._(
  'REFUSED',
);
const CreditOrderEventAction _$CANCELLED = const CreditOrderEventAction._(
  'CANCELLED',
);
const CreditOrderEventAction _$TRANSFER_DECLARED =
    const CreditOrderEventAction._('TRANSFER_DECLARED');
const CreditOrderEventAction _$PROOF_REJECTED = const CreditOrderEventAction._(
  'PROOF_REJECTED',
);
const CreditOrderEventAction _$FIRST_VALIDATION =
    const CreditOrderEventAction._('FIRST_VALIDATION');
const CreditOrderEventAction _$VALIDATED = const CreditOrderEventAction._(
  'VALIDATED',
);

CreditOrderEventAction _$valueOf(String name) {
  switch (name) {
    case 'CREATED':
      return _$CREATED;
    case 'CONFIRMED':
      return _$CONFIRMED;
    case 'REFUSED':
      return _$REFUSED;
    case 'CANCELLED':
      return _$CANCELLED;
    case 'TRANSFER_DECLARED':
      return _$TRANSFER_DECLARED;
    case 'PROOF_REJECTED':
      return _$PROOF_REJECTED;
    case 'FIRST_VALIDATION':
      return _$FIRST_VALIDATION;
    case 'VALIDATED':
      return _$VALIDATED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CreditOrderEventAction> _$values =
    BuiltSet<CreditOrderEventAction>(const <CreditOrderEventAction>[
      _$CREATED,
      _$CONFIRMED,
      _$REFUSED,
      _$CANCELLED,
      _$TRANSFER_DECLARED,
      _$PROOF_REJECTED,
      _$FIRST_VALIDATION,
      _$VALIDATED,
    ]);

class _$CreditOrderEventActionMeta {
  const _$CreditOrderEventActionMeta();
  CreditOrderEventAction get CREATED => _$CREATED;
  CreditOrderEventAction get CONFIRMED => _$CONFIRMED;
  CreditOrderEventAction get REFUSED => _$REFUSED;
  CreditOrderEventAction get CANCELLED => _$CANCELLED;
  CreditOrderEventAction get TRANSFER_DECLARED => _$TRANSFER_DECLARED;
  CreditOrderEventAction get PROOF_REJECTED => _$PROOF_REJECTED;
  CreditOrderEventAction get FIRST_VALIDATION => _$FIRST_VALIDATION;
  CreditOrderEventAction get VALIDATED => _$VALIDATED;
  CreditOrderEventAction valueOf(String name) => _$valueOf(name);
  BuiltSet<CreditOrderEventAction> get values => _$values;
}

mixin _$CreditOrderEventActionMixin {
  // ignore: non_constant_identifier_names
  _$CreditOrderEventActionMeta get CreditOrderEventAction =>
      const _$CreditOrderEventActionMeta();
}

Serializer<CreditOrderEventAction> _$creditOrderEventActionSerializer =
    _$CreditOrderEventActionSerializer();

class _$CreditOrderEventActionSerializer
    implements PrimitiveSerializer<CreditOrderEventAction> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'CREATED': 'CREATED',
    'CONFIRMED': 'CONFIRMED',
    'REFUSED': 'REFUSED',
    'CANCELLED': 'CANCELLED',
    'TRANSFER_DECLARED': 'TRANSFER_DECLARED',
    'PROOF_REJECTED': 'PROOF_REJECTED',
    'FIRST_VALIDATION': 'FIRST_VALIDATION',
    'VALIDATED': 'VALIDATED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'CREATED': 'CREATED',
    'CONFIRMED': 'CONFIRMED',
    'REFUSED': 'REFUSED',
    'CANCELLED': 'CANCELLED',
    'TRANSFER_DECLARED': 'TRANSFER_DECLARED',
    'PROOF_REJECTED': 'PROOF_REJECTED',
    'FIRST_VALIDATION': 'FIRST_VALIDATION',
    'VALIDATED': 'VALIDATED',
  };

  @override
  final Iterable<Type> types = const <Type>[CreditOrderEventAction];
  @override
  final String wireName = 'CreditOrderEventAction';

  @override
  Object serialize(
    Serializers serializers,
    CreditOrderEventAction object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CreditOrderEventAction deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CreditOrderEventAction.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
