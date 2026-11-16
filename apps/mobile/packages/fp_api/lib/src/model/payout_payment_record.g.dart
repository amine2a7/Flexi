// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payout_payment_record.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PayoutPaymentRecord extends PayoutPaymentRecord {
  @override
  final String bankReference;
  @override
  final Date paidOn;
  @override
  final int amountMillimes;
  @override
  final String? reason;

  factory _$PayoutPaymentRecord([
    void Function(PayoutPaymentRecordBuilder)? updates,
  ]) => (PayoutPaymentRecordBuilder()..update(updates))._build();

  _$PayoutPaymentRecord._({
    required this.bankReference,
    required this.paidOn,
    required this.amountMillimes,
    this.reason,
  }) : super._();
  @override
  PayoutPaymentRecord rebuild(
    void Function(PayoutPaymentRecordBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  PayoutPaymentRecordBuilder toBuilder() =>
      PayoutPaymentRecordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PayoutPaymentRecord &&
        bankReference == other.bankReference &&
        paidOn == other.paidOn &&
        amountMillimes == other.amountMillimes &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, bankReference.hashCode);
    _$hash = $jc(_$hash, paidOn.hashCode);
    _$hash = $jc(_$hash, amountMillimes.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PayoutPaymentRecord')
          ..add('bankReference', bankReference)
          ..add('paidOn', paidOn)
          ..add('amountMillimes', amountMillimes)
          ..add('reason', reason))
        .toString();
  }
}

class PayoutPaymentRecordBuilder
    implements Builder<PayoutPaymentRecord, PayoutPaymentRecordBuilder> {
  _$PayoutPaymentRecord? _$v;

  String? _bankReference;
  String? get bankReference => _$this._bankReference;
  set bankReference(String? bankReference) =>
      _$this._bankReference = bankReference;

  Date? _paidOn;
  Date? get paidOn => _$this._paidOn;
  set paidOn(Date? paidOn) => _$this._paidOn = paidOn;

  int? _amountMillimes;
  int? get amountMillimes => _$this._amountMillimes;
  set amountMillimes(int? amountMillimes) =>
      _$this._amountMillimes = amountMillimes;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  PayoutPaymentRecordBuilder() {
    PayoutPaymentRecord._defaults(this);
  }

  PayoutPaymentRecordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _bankReference = $v.bankReference;
      _paidOn = $v.paidOn;
      _amountMillimes = $v.amountMillimes;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PayoutPaymentRecord other) {
    _$v = other as _$PayoutPaymentRecord;
  }

  @override
  void update(void Function(PayoutPaymentRecordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PayoutPaymentRecord build() => _build();

  _$PayoutPaymentRecord _build() {
    final _$result =
        _$v ??
        _$PayoutPaymentRecord._(
          bankReference: BuiltValueNullFieldError.checkNotNull(
            bankReference,
            r'PayoutPaymentRecord',
            'bankReference',
          ),
          paidOn: BuiltValueNullFieldError.checkNotNull(
            paidOn,
            r'PayoutPaymentRecord',
            'paidOn',
          ),
          amountMillimes: BuiltValueNullFieldError.checkNotNull(
            amountMillimes,
            r'PayoutPaymentRecord',
            'amountMillimes',
          ),
          reason: reason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
