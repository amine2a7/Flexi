// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_transaction.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminTransaction extends AdminTransaction {
  @override
  final String id;
  @override
  final String reference;
  @override
  final String merchantName;
  @override
  final String companyName;
  @override
  final CreditType creditType;
  @override
  final int amountMillimes;
  @override
  final PaymentStatus status;
  @override
  final DateTime createdAt;

  factory _$AdminTransaction([
    void Function(AdminTransactionBuilder)? updates,
  ]) => (AdminTransactionBuilder()..update(updates))._build();

  _$AdminTransaction._({
    required this.id,
    required this.reference,
    required this.merchantName,
    required this.companyName,
    required this.creditType,
    required this.amountMillimes,
    required this.status,
    required this.createdAt,
  }) : super._();
  @override
  AdminTransaction rebuild(void Function(AdminTransactionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminTransactionBuilder toBuilder() =>
      AdminTransactionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTransaction &&
        id == other.id &&
        reference == other.reference &&
        merchantName == other.merchantName &&
        companyName == other.companyName &&
        creditType == other.creditType &&
        amountMillimes == other.amountMillimes &&
        status == other.status &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, reference.hashCode);
    _$hash = $jc(_$hash, merchantName.hashCode);
    _$hash = $jc(_$hash, companyName.hashCode);
    _$hash = $jc(_$hash, creditType.hashCode);
    _$hash = $jc(_$hash, amountMillimes.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminTransaction')
          ..add('id', id)
          ..add('reference', reference)
          ..add('merchantName', merchantName)
          ..add('companyName', companyName)
          ..add('creditType', creditType)
          ..add('amountMillimes', amountMillimes)
          ..add('status', status)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class AdminTransactionBuilder
    implements Builder<AdminTransaction, AdminTransactionBuilder> {
  _$AdminTransaction? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _reference;
  String? get reference => _$this._reference;
  set reference(String? reference) => _$this._reference = reference;

  String? _merchantName;
  String? get merchantName => _$this._merchantName;
  set merchantName(String? merchantName) => _$this._merchantName = merchantName;

  String? _companyName;
  String? get companyName => _$this._companyName;
  set companyName(String? companyName) => _$this._companyName = companyName;

  CreditType? _creditType;
  CreditType? get creditType => _$this._creditType;
  set creditType(CreditType? creditType) => _$this._creditType = creditType;

  int? _amountMillimes;
  int? get amountMillimes => _$this._amountMillimes;
  set amountMillimes(int? amountMillimes) =>
      _$this._amountMillimes = amountMillimes;

  PaymentStatus? _status;
  PaymentStatus? get status => _$this._status;
  set status(PaymentStatus? status) => _$this._status = status;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  AdminTransactionBuilder() {
    AdminTransaction._defaults(this);
  }

  AdminTransactionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _reference = $v.reference;
      _merchantName = $v.merchantName;
      _companyName = $v.companyName;
      _creditType = $v.creditType;
      _amountMillimes = $v.amountMillimes;
      _status = $v.status;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminTransaction other) {
    _$v = other as _$AdminTransaction;
  }

  @override
  void update(void Function(AdminTransactionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminTransaction build() => _build();

  _$AdminTransaction _build() {
    final _$result =
        _$v ??
        _$AdminTransaction._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminTransaction',
            'id',
          ),
          reference: BuiltValueNullFieldError.checkNotNull(
            reference,
            r'AdminTransaction',
            'reference',
          ),
          merchantName: BuiltValueNullFieldError.checkNotNull(
            merchantName,
            r'AdminTransaction',
            'merchantName',
          ),
          companyName: BuiltValueNullFieldError.checkNotNull(
            companyName,
            r'AdminTransaction',
            'companyName',
          ),
          creditType: BuiltValueNullFieldError.checkNotNull(
            creditType,
            r'AdminTransaction',
            'creditType',
          ),
          amountMillimes: BuiltValueNullFieldError.checkNotNull(
            amountMillimes,
            r'AdminTransaction',
            'amountMillimes',
          ),
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'AdminTransaction',
            'status',
          ),
          createdAt: BuiltValueNullFieldError.checkNotNull(
            createdAt,
            r'AdminTransaction',
            'createdAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
