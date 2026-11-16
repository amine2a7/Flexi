// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overview_sale.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OverviewSale extends OverviewSale {
  @override
  final String id;
  @override
  final String reference;
  @override
  final CreditType creditType;
  @override
  final int amountMillimes;
  @override
  final PaymentStatus status;
  @override
  final DateTime createdAt;

  factory _$OverviewSale([void Function(OverviewSaleBuilder)? updates]) =>
      (OverviewSaleBuilder()..update(updates))._build();

  _$OverviewSale._({
    required this.id,
    required this.reference,
    required this.creditType,
    required this.amountMillimes,
    required this.status,
    required this.createdAt,
  }) : super._();
  @override
  OverviewSale rebuild(void Function(OverviewSaleBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OverviewSaleBuilder toBuilder() => OverviewSaleBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OverviewSale &&
        id == other.id &&
        reference == other.reference &&
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
    _$hash = $jc(_$hash, creditType.hashCode);
    _$hash = $jc(_$hash, amountMillimes.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OverviewSale')
          ..add('id', id)
          ..add('reference', reference)
          ..add('creditType', creditType)
          ..add('amountMillimes', amountMillimes)
          ..add('status', status)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class OverviewSaleBuilder
    implements Builder<OverviewSale, OverviewSaleBuilder> {
  _$OverviewSale? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _reference;
  String? get reference => _$this._reference;
  set reference(String? reference) => _$this._reference = reference;

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

  OverviewSaleBuilder() {
    OverviewSale._defaults(this);
  }

  OverviewSaleBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _reference = $v.reference;
      _creditType = $v.creditType;
      _amountMillimes = $v.amountMillimes;
      _status = $v.status;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OverviewSale other) {
    _$v = other as _$OverviewSale;
  }

  @override
  void update(void Function(OverviewSaleBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OverviewSale build() => _build();

  _$OverviewSale _build() {
    final _$result =
        _$v ??
        _$OverviewSale._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'OverviewSale', 'id'),
          reference: BuiltValueNullFieldError.checkNotNull(
            reference,
            r'OverviewSale',
            'reference',
          ),
          creditType: BuiltValueNullFieldError.checkNotNull(
            creditType,
            r'OverviewSale',
            'creditType',
          ),
          amountMillimes: BuiltValueNullFieldError.checkNotNull(
            amountMillimes,
            r'OverviewSale',
            'amountMillimes',
          ),
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'OverviewSale',
            'status',
          ),
          createdAt: BuiltValueNullFieldError.checkNotNull(
            createdAt,
            r'OverviewSale',
            'createdAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
