// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_payment_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EmployeePaymentRequest extends EmployeePaymentRequest {
  @override
  final String id;
  @override
  final String reference;
  @override
  final String merchantName;
  @override
  final int amountMillimes;
  @override
  final CreditType creditType;
  @override
  final DateTime createdAt;
  @override
  final DateTime expiresAt;

  factory _$EmployeePaymentRequest([
    void Function(EmployeePaymentRequestBuilder)? updates,
  ]) => (EmployeePaymentRequestBuilder()..update(updates))._build();

  _$EmployeePaymentRequest._({
    required this.id,
    required this.reference,
    required this.merchantName,
    required this.amountMillimes,
    required this.creditType,
    required this.createdAt,
    required this.expiresAt,
  }) : super._();
  @override
  EmployeePaymentRequest rebuild(
    void Function(EmployeePaymentRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  EmployeePaymentRequestBuilder toBuilder() =>
      EmployeePaymentRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmployeePaymentRequest &&
        id == other.id &&
        reference == other.reference &&
        merchantName == other.merchantName &&
        amountMillimes == other.amountMillimes &&
        creditType == other.creditType &&
        createdAt == other.createdAt &&
        expiresAt == other.expiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, reference.hashCode);
    _$hash = $jc(_$hash, merchantName.hashCode);
    _$hash = $jc(_$hash, amountMillimes.hashCode);
    _$hash = $jc(_$hash, creditType.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EmployeePaymentRequest')
          ..add('id', id)
          ..add('reference', reference)
          ..add('merchantName', merchantName)
          ..add('amountMillimes', amountMillimes)
          ..add('creditType', creditType)
          ..add('createdAt', createdAt)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class EmployeePaymentRequestBuilder
    implements Builder<EmployeePaymentRequest, EmployeePaymentRequestBuilder> {
  _$EmployeePaymentRequest? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _reference;
  String? get reference => _$this._reference;
  set reference(String? reference) => _$this._reference = reference;

  String? _merchantName;
  String? get merchantName => _$this._merchantName;
  set merchantName(String? merchantName) => _$this._merchantName = merchantName;

  int? _amountMillimes;
  int? get amountMillimes => _$this._amountMillimes;
  set amountMillimes(int? amountMillimes) =>
      _$this._amountMillimes = amountMillimes;

  CreditType? _creditType;
  CreditType? get creditType => _$this._creditType;
  set creditType(CreditType? creditType) => _$this._creditType = creditType;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  EmployeePaymentRequestBuilder() {
    EmployeePaymentRequest._defaults(this);
  }

  EmployeePaymentRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _reference = $v.reference;
      _merchantName = $v.merchantName;
      _amountMillimes = $v.amountMillimes;
      _creditType = $v.creditType;
      _createdAt = $v.createdAt;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EmployeePaymentRequest other) {
    _$v = other as _$EmployeePaymentRequest;
  }

  @override
  void update(void Function(EmployeePaymentRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmployeePaymentRequest build() => _build();

  _$EmployeePaymentRequest _build() {
    final _$result =
        _$v ??
        _$EmployeePaymentRequest._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'EmployeePaymentRequest',
            'id',
          ),
          reference: BuiltValueNullFieldError.checkNotNull(
            reference,
            r'EmployeePaymentRequest',
            'reference',
          ),
          merchantName: BuiltValueNullFieldError.checkNotNull(
            merchantName,
            r'EmployeePaymentRequest',
            'merchantName',
          ),
          amountMillimes: BuiltValueNullFieldError.checkNotNull(
            amountMillimes,
            r'EmployeePaymentRequest',
            'amountMillimes',
          ),
          creditType: BuiltValueNullFieldError.checkNotNull(
            creditType,
            r'EmployeePaymentRequest',
            'creditType',
          ),
          createdAt: BuiltValueNullFieldError.checkNotNull(
            createdAt,
            r'EmployeePaymentRequest',
            'createdAt',
          ),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
            expiresAt,
            r'EmployeePaymentRequest',
            'expiresAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
