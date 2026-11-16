// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_terms.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PlatformTerms extends PlatformTerms {
  @override
  final int settlementDelayDays;
  @override
  final int invitationValidityDays;
  @override
  final int quoteValidityDays;
  @override
  final int paymentCancelHours;
  @override
  final int payoutMinimumMillimes;
  @override
  final int secondValidationThresholdMillimes;

  factory _$PlatformTerms([void Function(PlatformTermsBuilder)? updates]) =>
      (PlatformTermsBuilder()..update(updates))._build();

  _$PlatformTerms._({
    required this.settlementDelayDays,
    required this.invitationValidityDays,
    required this.quoteValidityDays,
    required this.paymentCancelHours,
    required this.payoutMinimumMillimes,
    required this.secondValidationThresholdMillimes,
  }) : super._();
  @override
  PlatformTerms rebuild(void Function(PlatformTermsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PlatformTermsBuilder toBuilder() => PlatformTermsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PlatformTerms &&
        settlementDelayDays == other.settlementDelayDays &&
        invitationValidityDays == other.invitationValidityDays &&
        quoteValidityDays == other.quoteValidityDays &&
        paymentCancelHours == other.paymentCancelHours &&
        payoutMinimumMillimes == other.payoutMinimumMillimes &&
        secondValidationThresholdMillimes ==
            other.secondValidationThresholdMillimes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, settlementDelayDays.hashCode);
    _$hash = $jc(_$hash, invitationValidityDays.hashCode);
    _$hash = $jc(_$hash, quoteValidityDays.hashCode);
    _$hash = $jc(_$hash, paymentCancelHours.hashCode);
    _$hash = $jc(_$hash, payoutMinimumMillimes.hashCode);
    _$hash = $jc(_$hash, secondValidationThresholdMillimes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PlatformTerms')
          ..add('settlementDelayDays', settlementDelayDays)
          ..add('invitationValidityDays', invitationValidityDays)
          ..add('quoteValidityDays', quoteValidityDays)
          ..add('paymentCancelHours', paymentCancelHours)
          ..add('payoutMinimumMillimes', payoutMinimumMillimes)
          ..add(
            'secondValidationThresholdMillimes',
            secondValidationThresholdMillimes,
          ))
        .toString();
  }
}

class PlatformTermsBuilder
    implements Builder<PlatformTerms, PlatformTermsBuilder> {
  _$PlatformTerms? _$v;

  int? _settlementDelayDays;
  int? get settlementDelayDays => _$this._settlementDelayDays;
  set settlementDelayDays(int? settlementDelayDays) =>
      _$this._settlementDelayDays = settlementDelayDays;

  int? _invitationValidityDays;
  int? get invitationValidityDays => _$this._invitationValidityDays;
  set invitationValidityDays(int? invitationValidityDays) =>
      _$this._invitationValidityDays = invitationValidityDays;

  int? _quoteValidityDays;
  int? get quoteValidityDays => _$this._quoteValidityDays;
  set quoteValidityDays(int? quoteValidityDays) =>
      _$this._quoteValidityDays = quoteValidityDays;

  int? _paymentCancelHours;
  int? get paymentCancelHours => _$this._paymentCancelHours;
  set paymentCancelHours(int? paymentCancelHours) =>
      _$this._paymentCancelHours = paymentCancelHours;

  int? _payoutMinimumMillimes;
  int? get payoutMinimumMillimes => _$this._payoutMinimumMillimes;
  set payoutMinimumMillimes(int? payoutMinimumMillimes) =>
      _$this._payoutMinimumMillimes = payoutMinimumMillimes;

  int? _secondValidationThresholdMillimes;
  int? get secondValidationThresholdMillimes =>
      _$this._secondValidationThresholdMillimes;
  set secondValidationThresholdMillimes(
    int? secondValidationThresholdMillimes,
  ) => _$this._secondValidationThresholdMillimes =
      secondValidationThresholdMillimes;

  PlatformTermsBuilder() {
    PlatformTerms._defaults(this);
  }

  PlatformTermsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _settlementDelayDays = $v.settlementDelayDays;
      _invitationValidityDays = $v.invitationValidityDays;
      _quoteValidityDays = $v.quoteValidityDays;
      _paymentCancelHours = $v.paymentCancelHours;
      _payoutMinimumMillimes = $v.payoutMinimumMillimes;
      _secondValidationThresholdMillimes = $v.secondValidationThresholdMillimes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PlatformTerms other) {
    _$v = other as _$PlatformTerms;
  }

  @override
  void update(void Function(PlatformTermsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PlatformTerms build() => _build();

  _$PlatformTerms _build() {
    final _$result =
        _$v ??
        _$PlatformTerms._(
          settlementDelayDays: BuiltValueNullFieldError.checkNotNull(
            settlementDelayDays,
            r'PlatformTerms',
            'settlementDelayDays',
          ),
          invitationValidityDays: BuiltValueNullFieldError.checkNotNull(
            invitationValidityDays,
            r'PlatformTerms',
            'invitationValidityDays',
          ),
          quoteValidityDays: BuiltValueNullFieldError.checkNotNull(
            quoteValidityDays,
            r'PlatformTerms',
            'quoteValidityDays',
          ),
          paymentCancelHours: BuiltValueNullFieldError.checkNotNull(
            paymentCancelHours,
            r'PlatformTerms',
            'paymentCancelHours',
          ),
          payoutMinimumMillimes: BuiltValueNullFieldError.checkNotNull(
            payoutMinimumMillimes,
            r'PlatformTerms',
            'payoutMinimumMillimes',
          ),
          secondValidationThresholdMillimes:
              BuiltValueNullFieldError.checkNotNull(
                secondValidationThresholdMillimes,
                r'PlatformTerms',
                'secondValidationThresholdMillimes',
              ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
