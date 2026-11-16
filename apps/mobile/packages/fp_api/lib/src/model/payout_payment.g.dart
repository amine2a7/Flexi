// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payout_payment.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PayoutPayment extends PayoutPayment {
  @override
  final String bankReference;
  @override
  final Date paidOn;
  @override
  final int amountMillimes;
  @override
  final String? note;

  factory _$PayoutPayment([void Function(PayoutPaymentBuilder)? updates]) =>
      (PayoutPaymentBuilder()..update(updates))._build();

  _$PayoutPayment._({
    required this.bankReference,
    required this.paidOn,
    required this.amountMillimes,
    this.note,
  }) : super._();
  @override
  PayoutPayment rebuild(void Function(PayoutPaymentBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PayoutPaymentBuilder toBuilder() => PayoutPaymentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PayoutPayment &&
        bankReference == other.bankReference &&
        paidOn == other.paidOn &&
        amountMillimes == other.amountMillimes &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, bankReference.hashCode);
    _$hash = $jc(_$hash, paidOn.hashCode);
    _$hash = $jc(_$hash, amountMillimes.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PayoutPayment')
          ..add('bankReference', bankReference)
          ..add('paidOn', paidOn)
          ..add('amountMillimes', amountMillimes)
          ..add('note', note))
        .toString();
  }
}

class PayoutPaymentBuilder
    implements Builder<PayoutPayment, PayoutPaymentBuilder> {
  _$PayoutPayment? _$v;

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

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  PayoutPaymentBuilder() {
    PayoutPayment._defaults(this);
  }

  PayoutPaymentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _bankReference = $v.bankReference;
      _paidOn = $v.paidOn;
      _amountMillimes = $v.amountMillimes;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PayoutPayment other) {
    _$v = other as _$PayoutPayment;
  }

  @override
  void update(void Function(PayoutPaymentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PayoutPayment build() => _build();

  _$PayoutPayment _build() {
    final _$result =
        _$v ??
        _$PayoutPayment._(
          bankReference: BuiltValueNullFieldError.checkNotNull(
            bankReference,
            r'PayoutPayment',
            'bankReference',
          ),
          paidOn: BuiltValueNullFieldError.checkNotNull(
            paidOn,
            r'PayoutPayment',
            'paidOn',
          ),
          amountMillimes: BuiltValueNullFieldError.checkNotNull(
            amountMillimes,
            r'PayoutPayment',
            'amountMillimes',
          ),
          note: note,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
