// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receivable.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Receivable extends Receivable {
  @override
  final CreditType creditType;
  @override
  final String paymentId;
  @override
  final String reference;
  @override
  final int amountMillimes;
  @override
  final DateTime confirmedAt;
  @override
  final Date settlementDate;

  factory _$Receivable([void Function(ReceivableBuilder)? updates]) =>
      (ReceivableBuilder()..update(updates))._build();

  _$Receivable._({
    required this.creditType,
    required this.paymentId,
    required this.reference,
    required this.amountMillimes,
    required this.confirmedAt,
    required this.settlementDate,
  }) : super._();
  @override
  Receivable rebuild(void Function(ReceivableBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReceivableBuilder toBuilder() => ReceivableBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Receivable &&
        creditType == other.creditType &&
        paymentId == other.paymentId &&
        reference == other.reference &&
        amountMillimes == other.amountMillimes &&
        confirmedAt == other.confirmedAt &&
        settlementDate == other.settlementDate;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, creditType.hashCode);
    _$hash = $jc(_$hash, paymentId.hashCode);
    _$hash = $jc(_$hash, reference.hashCode);
    _$hash = $jc(_$hash, amountMillimes.hashCode);
    _$hash = $jc(_$hash, confirmedAt.hashCode);
    _$hash = $jc(_$hash, settlementDate.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Receivable')
          ..add('creditType', creditType)
          ..add('paymentId', paymentId)
          ..add('reference', reference)
          ..add('amountMillimes', amountMillimes)
          ..add('confirmedAt', confirmedAt)
          ..add('settlementDate', settlementDate))
        .toString();
  }
}

class ReceivableBuilder implements Builder<Receivable, ReceivableBuilder> {
  _$Receivable? _$v;

  CreditType? _creditType;
  CreditType? get creditType => _$this._creditType;
  set creditType(CreditType? creditType) => _$this._creditType = creditType;

  String? _paymentId;
  String? get paymentId => _$this._paymentId;
  set paymentId(String? paymentId) => _$this._paymentId = paymentId;

  String? _reference;
  String? get reference => _$this._reference;
  set reference(String? reference) => _$this._reference = reference;

  int? _amountMillimes;
  int? get amountMillimes => _$this._amountMillimes;
  set amountMillimes(int? amountMillimes) =>
      _$this._amountMillimes = amountMillimes;

  DateTime? _confirmedAt;
  DateTime? get confirmedAt => _$this._confirmedAt;
  set confirmedAt(DateTime? confirmedAt) => _$this._confirmedAt = confirmedAt;

  Date? _settlementDate;
  Date? get settlementDate => _$this._settlementDate;
  set settlementDate(Date? settlementDate) =>
      _$this._settlementDate = settlementDate;

  ReceivableBuilder() {
    Receivable._defaults(this);
  }

  ReceivableBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _creditType = $v.creditType;
      _paymentId = $v.paymentId;
      _reference = $v.reference;
      _amountMillimes = $v.amountMillimes;
      _confirmedAt = $v.confirmedAt;
      _settlementDate = $v.settlementDate;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Receivable other) {
    _$v = other as _$Receivable;
  }

  @override
  void update(void Function(ReceivableBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Receivable build() => _build();

  _$Receivable _build() {
    final _$result =
        _$v ??
        _$Receivable._(
          creditType: BuiltValueNullFieldError.checkNotNull(
            creditType,
            r'Receivable',
            'creditType',
          ),
          paymentId: BuiltValueNullFieldError.checkNotNull(
            paymentId,
            r'Receivable',
            'paymentId',
          ),
          reference: BuiltValueNullFieldError.checkNotNull(
            reference,
            r'Receivable',
            'reference',
          ),
          amountMillimes: BuiltValueNullFieldError.checkNotNull(
            amountMillimes,
            r'Receivable',
            'amountMillimes',
          ),
          confirmedAt: BuiltValueNullFieldError.checkNotNull(
            confirmedAt,
            r'Receivable',
            'confirmedAt',
          ),
          settlementDate: BuiltValueNullFieldError.checkNotNull(
            settlementDate,
            r'Receivable',
            'settlementDate',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
