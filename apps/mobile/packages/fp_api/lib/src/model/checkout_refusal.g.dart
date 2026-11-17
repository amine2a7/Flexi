// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_refusal.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CheckoutRefusalCodeEnum _$checkoutRefusalCodeEnum_INSUFFICIENT_FUNDS =
    const CheckoutRefusalCodeEnum._('INSUFFICIENT_FUNDS');
const CheckoutRefusalCodeEnum _$checkoutRefusalCodeEnum_LIMIT_EXCEEDED =
    const CheckoutRefusalCodeEnum._('LIMIT_EXCEEDED');
const CheckoutRefusalCodeEnum _$checkoutRefusalCodeEnum_CHECKOUT_REFUSED =
    const CheckoutRefusalCodeEnum._('CHECKOUT_REFUSED');
const CheckoutRefusalCodeEnum _$checkoutRefusalCodeEnum_PAYMENT_DECLINED =
    const CheckoutRefusalCodeEnum._('PAYMENT_DECLINED');

CheckoutRefusalCodeEnum _$checkoutRefusalCodeEnumValueOf(String name) {
  switch (name) {
    case 'INSUFFICIENT_FUNDS':
      return _$checkoutRefusalCodeEnum_INSUFFICIENT_FUNDS;
    case 'LIMIT_EXCEEDED':
      return _$checkoutRefusalCodeEnum_LIMIT_EXCEEDED;
    case 'CHECKOUT_REFUSED':
      return _$checkoutRefusalCodeEnum_CHECKOUT_REFUSED;
    case 'PAYMENT_DECLINED':
      return _$checkoutRefusalCodeEnum_PAYMENT_DECLINED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CheckoutRefusalCodeEnum> _$checkoutRefusalCodeEnumValues =
    BuiltSet<CheckoutRefusalCodeEnum>(const <CheckoutRefusalCodeEnum>[
      _$checkoutRefusalCodeEnum_INSUFFICIENT_FUNDS,
      _$checkoutRefusalCodeEnum_LIMIT_EXCEEDED,
      _$checkoutRefusalCodeEnum_CHECKOUT_REFUSED,
      _$checkoutRefusalCodeEnum_PAYMENT_DECLINED,
    ]);

Serializer<CheckoutRefusalCodeEnum> _$checkoutRefusalCodeEnumSerializer =
    _$CheckoutRefusalCodeEnumSerializer();

class _$CheckoutRefusalCodeEnumSerializer
    implements PrimitiveSerializer<CheckoutRefusalCodeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'INSUFFICIENT_FUNDS': 'INSUFFICIENT_FUNDS',
    'LIMIT_EXCEEDED': 'LIMIT_EXCEEDED',
    'CHECKOUT_REFUSED': 'CHECKOUT_REFUSED',
    'PAYMENT_DECLINED': 'PAYMENT_DECLINED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'INSUFFICIENT_FUNDS': 'INSUFFICIENT_FUNDS',
    'LIMIT_EXCEEDED': 'LIMIT_EXCEEDED',
    'CHECKOUT_REFUSED': 'CHECKOUT_REFUSED',
    'PAYMENT_DECLINED': 'PAYMENT_DECLINED',
  };

  @override
  final Iterable<Type> types = const <Type>[CheckoutRefusalCodeEnum];
  @override
  final String wireName = 'CheckoutRefusalCodeEnum';

  @override
  Object serialize(
    Serializers serializers,
    CheckoutRefusalCodeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CheckoutRefusalCodeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CheckoutRefusalCodeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CheckoutRefusal extends CheckoutRefusal {
  @override
  final CheckoutRefusalCodeEnum code;
  @override
  final CheckoutRefusalReason? reason;
  @override
  final String customerFirstName;
  @override
  final DateTime occurredAt;

  factory _$CheckoutRefusal([void Function(CheckoutRefusalBuilder)? updates]) =>
      (CheckoutRefusalBuilder()..update(updates))._build();

  _$CheckoutRefusal._({
    required this.code,
    this.reason,
    required this.customerFirstName,
    required this.occurredAt,
  }) : super._();
  @override
  CheckoutRefusal rebuild(void Function(CheckoutRefusalBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CheckoutRefusalBuilder toBuilder() => CheckoutRefusalBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CheckoutRefusal &&
        code == other.code &&
        reason == other.reason &&
        customerFirstName == other.customerFirstName &&
        occurredAt == other.occurredAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, customerFirstName.hashCode);
    _$hash = $jc(_$hash, occurredAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CheckoutRefusal')
          ..add('code', code)
          ..add('reason', reason)
          ..add('customerFirstName', customerFirstName)
          ..add('occurredAt', occurredAt))
        .toString();
  }
}

class CheckoutRefusalBuilder
    implements Builder<CheckoutRefusal, CheckoutRefusalBuilder> {
  _$CheckoutRefusal? _$v;

  CheckoutRefusalCodeEnum? _code;
  CheckoutRefusalCodeEnum? get code => _$this._code;
  set code(CheckoutRefusalCodeEnum? code) => _$this._code = code;

  CheckoutRefusalReason? _reason;
  CheckoutRefusalReason? get reason => _$this._reason;
  set reason(CheckoutRefusalReason? reason) => _$this._reason = reason;

  String? _customerFirstName;
  String? get customerFirstName => _$this._customerFirstName;
  set customerFirstName(String? customerFirstName) =>
      _$this._customerFirstName = customerFirstName;

  DateTime? _occurredAt;
  DateTime? get occurredAt => _$this._occurredAt;
  set occurredAt(DateTime? occurredAt) => _$this._occurredAt = occurredAt;

  CheckoutRefusalBuilder() {
    CheckoutRefusal._defaults(this);
  }

  CheckoutRefusalBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _reason = $v.reason;
      _customerFirstName = $v.customerFirstName;
      _occurredAt = $v.occurredAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CheckoutRefusal other) {
    _$v = other as _$CheckoutRefusal;
  }

  @override
  void update(void Function(CheckoutRefusalBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CheckoutRefusal build() => _build();

  _$CheckoutRefusal _build() {
    final _$result =
        _$v ??
        _$CheckoutRefusal._(
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'CheckoutRefusal',
            'code',
          ),
          reason: reason,
          customerFirstName: BuiltValueNullFieldError.checkNotNull(
            customerFirstName,
            r'CheckoutRefusal',
            'customerFirstName',
          ),
          occurredAt: BuiltValueNullFieldError.checkNotNull(
            occurredAt,
            r'CheckoutRefusal',
            'occurredAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
