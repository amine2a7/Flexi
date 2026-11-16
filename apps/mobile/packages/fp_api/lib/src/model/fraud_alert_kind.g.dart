// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fraud_alert_kind.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const FraudAlertKind _$REPEATED_REFUSALS = const FraudAlertKind._(
  'REPEATED_REFUSALS',
);
const FraudAlertKind _$MERCHANT_BURST = const FraudAlertKind._(
  'MERCHANT_BURST',
);
const FraudAlertKind _$NEAR_DAILY_LIMIT = const FraudAlertKind._(
  'NEAR_DAILY_LIMIT',
);
const FraudAlertKind _$RIB_CHANGE_PAYOUT = const FraudAlertKind._(
  'RIB_CHANGE_PAYOUT',
);
const FraudAlertKind _$NEW_DEVICE_PAYMENT = const FraudAlertKind._(
  'NEW_DEVICE_PAYMENT',
);
const FraudAlertKind _$COMMISSION_GRID_MISSING = const FraudAlertKind._(
  'COMMISSION_GRID_MISSING',
);
const FraudAlertKind _$LEDGER_MISMATCH = const FraudAlertKind._(
  'LEDGER_MISMATCH',
);

FraudAlertKind _$valueOf(String name) {
  switch (name) {
    case 'REPEATED_REFUSALS':
      return _$REPEATED_REFUSALS;
    case 'MERCHANT_BURST':
      return _$MERCHANT_BURST;
    case 'NEAR_DAILY_LIMIT':
      return _$NEAR_DAILY_LIMIT;
    case 'RIB_CHANGE_PAYOUT':
      return _$RIB_CHANGE_PAYOUT;
    case 'NEW_DEVICE_PAYMENT':
      return _$NEW_DEVICE_PAYMENT;
    case 'COMMISSION_GRID_MISSING':
      return _$COMMISSION_GRID_MISSING;
    case 'LEDGER_MISMATCH':
      return _$LEDGER_MISMATCH;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FraudAlertKind> _$values = BuiltSet<FraudAlertKind>(
  const <FraudAlertKind>[
    _$REPEATED_REFUSALS,
    _$MERCHANT_BURST,
    _$NEAR_DAILY_LIMIT,
    _$RIB_CHANGE_PAYOUT,
    _$NEW_DEVICE_PAYMENT,
    _$COMMISSION_GRID_MISSING,
    _$LEDGER_MISMATCH,
  ],
);

class _$FraudAlertKindMeta {
  const _$FraudAlertKindMeta();
  FraudAlertKind get REPEATED_REFUSALS => _$REPEATED_REFUSALS;
  FraudAlertKind get MERCHANT_BURST => _$MERCHANT_BURST;
  FraudAlertKind get NEAR_DAILY_LIMIT => _$NEAR_DAILY_LIMIT;
  FraudAlertKind get RIB_CHANGE_PAYOUT => _$RIB_CHANGE_PAYOUT;
  FraudAlertKind get NEW_DEVICE_PAYMENT => _$NEW_DEVICE_PAYMENT;
  FraudAlertKind get COMMISSION_GRID_MISSING => _$COMMISSION_GRID_MISSING;
  FraudAlertKind get LEDGER_MISMATCH => _$LEDGER_MISMATCH;
  FraudAlertKind valueOf(String name) => _$valueOf(name);
  BuiltSet<FraudAlertKind> get values => _$values;
}

mixin _$FraudAlertKindMixin {
  // ignore: non_constant_identifier_names
  _$FraudAlertKindMeta get FraudAlertKind => const _$FraudAlertKindMeta();
}

Serializer<FraudAlertKind> _$fraudAlertKindSerializer =
    _$FraudAlertKindSerializer();

class _$FraudAlertKindSerializer
    implements PrimitiveSerializer<FraudAlertKind> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'REPEATED_REFUSALS': 'REPEATED_REFUSALS',
    'MERCHANT_BURST': 'MERCHANT_BURST',
    'NEAR_DAILY_LIMIT': 'NEAR_DAILY_LIMIT',
    'RIB_CHANGE_PAYOUT': 'RIB_CHANGE_PAYOUT',
    'NEW_DEVICE_PAYMENT': 'NEW_DEVICE_PAYMENT',
    'COMMISSION_GRID_MISSING': 'COMMISSION_GRID_MISSING',
    'LEDGER_MISMATCH': 'LEDGER_MISMATCH',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'REPEATED_REFUSALS': 'REPEATED_REFUSALS',
    'MERCHANT_BURST': 'MERCHANT_BURST',
    'NEAR_DAILY_LIMIT': 'NEAR_DAILY_LIMIT',
    'RIB_CHANGE_PAYOUT': 'RIB_CHANGE_PAYOUT',
    'NEW_DEVICE_PAYMENT': 'NEW_DEVICE_PAYMENT',
    'COMMISSION_GRID_MISSING': 'COMMISSION_GRID_MISSING',
    'LEDGER_MISMATCH': 'LEDGER_MISMATCH',
  };

  @override
  final Iterable<Type> types = const <Type>[FraudAlertKind];
  @override
  final String wireName = 'FraudAlertKind';

  @override
  Object serialize(
    Serializers serializers,
    FraudAlertKind object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  FraudAlertKind deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => FraudAlertKind.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
