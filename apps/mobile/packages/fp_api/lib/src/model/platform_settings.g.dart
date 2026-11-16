// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_settings.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PlatformSettings extends PlatformSettings {
  @override
  final PlatformSettingsWithholding? withholding;
  @override
  final int? transferFeeMillimes;
  @override
  final FundingBankAccount fundingAccount;
  @override
  final int secondValidationThresholdMillimes;
  @override
  final int quoteValidityDays;
  @override
  final int invitationValidityDays;
  @override
  final int otpValidityMinutes;
  @override
  final BuiltList<int> pinLockMinutes;
  @override
  final int paymentCancelHours;
  @override
  final int settlementDelayDays;
  @override
  final BuiltSet<KycDocumentType>? kycRequiredDocuments;
  @override
  final ExpiredCreditsDestination expiredCreditsDestination;
  @override
  final int payoutMinimumMillimes;
  @override
  final int creditValidityMonths;
  @override
  final int maxFamilyMembers;
  @override
  final int orderFeeRateBps;
  @override
  final int vatRateBps;
  @override
  final int stampDutyMillimes;
  @override
  final BuiltList<CreditTypeSettings> creditTypes;

  factory _$PlatformSettings([
    void Function(PlatformSettingsBuilder)? updates,
  ]) => (PlatformSettingsBuilder()..update(updates))._build();

  _$PlatformSettings._({
    this.withholding,
    this.transferFeeMillimes,
    required this.fundingAccount,
    required this.secondValidationThresholdMillimes,
    required this.quoteValidityDays,
    required this.invitationValidityDays,
    required this.otpValidityMinutes,
    required this.pinLockMinutes,
    required this.paymentCancelHours,
    required this.settlementDelayDays,
    this.kycRequiredDocuments,
    required this.expiredCreditsDestination,
    required this.payoutMinimumMillimes,
    required this.creditValidityMonths,
    required this.maxFamilyMembers,
    required this.orderFeeRateBps,
    required this.vatRateBps,
    required this.stampDutyMillimes,
    required this.creditTypes,
  }) : super._();
  @override
  PlatformSettings rebuild(void Function(PlatformSettingsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PlatformSettingsBuilder toBuilder() =>
      PlatformSettingsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PlatformSettings &&
        withholding == other.withholding &&
        transferFeeMillimes == other.transferFeeMillimes &&
        fundingAccount == other.fundingAccount &&
        secondValidationThresholdMillimes ==
            other.secondValidationThresholdMillimes &&
        quoteValidityDays == other.quoteValidityDays &&
        invitationValidityDays == other.invitationValidityDays &&
        otpValidityMinutes == other.otpValidityMinutes &&
        pinLockMinutes == other.pinLockMinutes &&
        paymentCancelHours == other.paymentCancelHours &&
        settlementDelayDays == other.settlementDelayDays &&
        kycRequiredDocuments == other.kycRequiredDocuments &&
        expiredCreditsDestination == other.expiredCreditsDestination &&
        payoutMinimumMillimes == other.payoutMinimumMillimes &&
        creditValidityMonths == other.creditValidityMonths &&
        maxFamilyMembers == other.maxFamilyMembers &&
        orderFeeRateBps == other.orderFeeRateBps &&
        vatRateBps == other.vatRateBps &&
        stampDutyMillimes == other.stampDutyMillimes &&
        creditTypes == other.creditTypes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, withholding.hashCode);
    _$hash = $jc(_$hash, transferFeeMillimes.hashCode);
    _$hash = $jc(_$hash, fundingAccount.hashCode);
    _$hash = $jc(_$hash, secondValidationThresholdMillimes.hashCode);
    _$hash = $jc(_$hash, quoteValidityDays.hashCode);
    _$hash = $jc(_$hash, invitationValidityDays.hashCode);
    _$hash = $jc(_$hash, otpValidityMinutes.hashCode);
    _$hash = $jc(_$hash, pinLockMinutes.hashCode);
    _$hash = $jc(_$hash, paymentCancelHours.hashCode);
    _$hash = $jc(_$hash, settlementDelayDays.hashCode);
    _$hash = $jc(_$hash, kycRequiredDocuments.hashCode);
    _$hash = $jc(_$hash, expiredCreditsDestination.hashCode);
    _$hash = $jc(_$hash, payoutMinimumMillimes.hashCode);
    _$hash = $jc(_$hash, creditValidityMonths.hashCode);
    _$hash = $jc(_$hash, maxFamilyMembers.hashCode);
    _$hash = $jc(_$hash, orderFeeRateBps.hashCode);
    _$hash = $jc(_$hash, vatRateBps.hashCode);
    _$hash = $jc(_$hash, stampDutyMillimes.hashCode);
    _$hash = $jc(_$hash, creditTypes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PlatformSettings')
          ..add('withholding', withholding)
          ..add('transferFeeMillimes', transferFeeMillimes)
          ..add('fundingAccount', fundingAccount)
          ..add(
            'secondValidationThresholdMillimes',
            secondValidationThresholdMillimes,
          )
          ..add('quoteValidityDays', quoteValidityDays)
          ..add('invitationValidityDays', invitationValidityDays)
          ..add('otpValidityMinutes', otpValidityMinutes)
          ..add('pinLockMinutes', pinLockMinutes)
          ..add('paymentCancelHours', paymentCancelHours)
          ..add('settlementDelayDays', settlementDelayDays)
          ..add('kycRequiredDocuments', kycRequiredDocuments)
          ..add('expiredCreditsDestination', expiredCreditsDestination)
          ..add('payoutMinimumMillimes', payoutMinimumMillimes)
          ..add('creditValidityMonths', creditValidityMonths)
          ..add('maxFamilyMembers', maxFamilyMembers)
          ..add('orderFeeRateBps', orderFeeRateBps)
          ..add('vatRateBps', vatRateBps)
          ..add('stampDutyMillimes', stampDutyMillimes)
          ..add('creditTypes', creditTypes))
        .toString();
  }
}

class PlatformSettingsBuilder
    implements Builder<PlatformSettings, PlatformSettingsBuilder> {
  _$PlatformSettings? _$v;

  PlatformSettingsWithholdingBuilder? _withholding;
  PlatformSettingsWithholdingBuilder get withholding =>
      _$this._withholding ??= PlatformSettingsWithholdingBuilder();
  set withholding(PlatformSettingsWithholdingBuilder? withholding) =>
      _$this._withholding = withholding;

  int? _transferFeeMillimes;
  int? get transferFeeMillimes => _$this._transferFeeMillimes;
  set transferFeeMillimes(int? transferFeeMillimes) =>
      _$this._transferFeeMillimes = transferFeeMillimes;

  FundingBankAccountBuilder? _fundingAccount;
  FundingBankAccountBuilder get fundingAccount =>
      _$this._fundingAccount ??= FundingBankAccountBuilder();
  set fundingAccount(FundingBankAccountBuilder? fundingAccount) =>
      _$this._fundingAccount = fundingAccount;

  int? _secondValidationThresholdMillimes;
  int? get secondValidationThresholdMillimes =>
      _$this._secondValidationThresholdMillimes;
  set secondValidationThresholdMillimes(
    int? secondValidationThresholdMillimes,
  ) => _$this._secondValidationThresholdMillimes =
      secondValidationThresholdMillimes;

  int? _quoteValidityDays;
  int? get quoteValidityDays => _$this._quoteValidityDays;
  set quoteValidityDays(int? quoteValidityDays) =>
      _$this._quoteValidityDays = quoteValidityDays;

  int? _invitationValidityDays;
  int? get invitationValidityDays => _$this._invitationValidityDays;
  set invitationValidityDays(int? invitationValidityDays) =>
      _$this._invitationValidityDays = invitationValidityDays;

  int? _otpValidityMinutes;
  int? get otpValidityMinutes => _$this._otpValidityMinutes;
  set otpValidityMinutes(int? otpValidityMinutes) =>
      _$this._otpValidityMinutes = otpValidityMinutes;

  ListBuilder<int>? _pinLockMinutes;
  ListBuilder<int> get pinLockMinutes =>
      _$this._pinLockMinutes ??= ListBuilder<int>();
  set pinLockMinutes(ListBuilder<int>? pinLockMinutes) =>
      _$this._pinLockMinutes = pinLockMinutes;

  int? _paymentCancelHours;
  int? get paymentCancelHours => _$this._paymentCancelHours;
  set paymentCancelHours(int? paymentCancelHours) =>
      _$this._paymentCancelHours = paymentCancelHours;

  int? _settlementDelayDays;
  int? get settlementDelayDays => _$this._settlementDelayDays;
  set settlementDelayDays(int? settlementDelayDays) =>
      _$this._settlementDelayDays = settlementDelayDays;

  SetBuilder<KycDocumentType>? _kycRequiredDocuments;
  SetBuilder<KycDocumentType> get kycRequiredDocuments =>
      _$this._kycRequiredDocuments ??= SetBuilder<KycDocumentType>();
  set kycRequiredDocuments(SetBuilder<KycDocumentType>? kycRequiredDocuments) =>
      _$this._kycRequiredDocuments = kycRequiredDocuments;

  ExpiredCreditsDestination? _expiredCreditsDestination;
  ExpiredCreditsDestination? get expiredCreditsDestination =>
      _$this._expiredCreditsDestination;
  set expiredCreditsDestination(
    ExpiredCreditsDestination? expiredCreditsDestination,
  ) => _$this._expiredCreditsDestination = expiredCreditsDestination;

  int? _payoutMinimumMillimes;
  int? get payoutMinimumMillimes => _$this._payoutMinimumMillimes;
  set payoutMinimumMillimes(int? payoutMinimumMillimes) =>
      _$this._payoutMinimumMillimes = payoutMinimumMillimes;

  int? _creditValidityMonths;
  int? get creditValidityMonths => _$this._creditValidityMonths;
  set creditValidityMonths(int? creditValidityMonths) =>
      _$this._creditValidityMonths = creditValidityMonths;

  int? _maxFamilyMembers;
  int? get maxFamilyMembers => _$this._maxFamilyMembers;
  set maxFamilyMembers(int? maxFamilyMembers) =>
      _$this._maxFamilyMembers = maxFamilyMembers;

  int? _orderFeeRateBps;
  int? get orderFeeRateBps => _$this._orderFeeRateBps;
  set orderFeeRateBps(int? orderFeeRateBps) =>
      _$this._orderFeeRateBps = orderFeeRateBps;

  int? _vatRateBps;
  int? get vatRateBps => _$this._vatRateBps;
  set vatRateBps(int? vatRateBps) => _$this._vatRateBps = vatRateBps;

  int? _stampDutyMillimes;
  int? get stampDutyMillimes => _$this._stampDutyMillimes;
  set stampDutyMillimes(int? stampDutyMillimes) =>
      _$this._stampDutyMillimes = stampDutyMillimes;

  ListBuilder<CreditTypeSettings>? _creditTypes;
  ListBuilder<CreditTypeSettings> get creditTypes =>
      _$this._creditTypes ??= ListBuilder<CreditTypeSettings>();
  set creditTypes(ListBuilder<CreditTypeSettings>? creditTypes) =>
      _$this._creditTypes = creditTypes;

  PlatformSettingsBuilder() {
    PlatformSettings._defaults(this);
  }

  PlatformSettingsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _withholding = $v.withholding?.toBuilder();
      _transferFeeMillimes = $v.transferFeeMillimes;
      _fundingAccount = $v.fundingAccount.toBuilder();
      _secondValidationThresholdMillimes = $v.secondValidationThresholdMillimes;
      _quoteValidityDays = $v.quoteValidityDays;
      _invitationValidityDays = $v.invitationValidityDays;
      _otpValidityMinutes = $v.otpValidityMinutes;
      _pinLockMinutes = $v.pinLockMinutes.toBuilder();
      _paymentCancelHours = $v.paymentCancelHours;
      _settlementDelayDays = $v.settlementDelayDays;
      _kycRequiredDocuments = $v.kycRequiredDocuments?.toBuilder();
      _expiredCreditsDestination = $v.expiredCreditsDestination;
      _payoutMinimumMillimes = $v.payoutMinimumMillimes;
      _creditValidityMonths = $v.creditValidityMonths;
      _maxFamilyMembers = $v.maxFamilyMembers;
      _orderFeeRateBps = $v.orderFeeRateBps;
      _vatRateBps = $v.vatRateBps;
      _stampDutyMillimes = $v.stampDutyMillimes;
      _creditTypes = $v.creditTypes.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PlatformSettings other) {
    _$v = other as _$PlatformSettings;
  }

  @override
  void update(void Function(PlatformSettingsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PlatformSettings build() => _build();

  _$PlatformSettings _build() {
    _$PlatformSettings _$result;
    try {
      _$result =
          _$v ??
          _$PlatformSettings._(
            withholding: _withholding?.build(),
            transferFeeMillimes: transferFeeMillimes,
            fundingAccount: fundingAccount.build(),
            secondValidationThresholdMillimes:
                BuiltValueNullFieldError.checkNotNull(
                  secondValidationThresholdMillimes,
                  r'PlatformSettings',
                  'secondValidationThresholdMillimes',
                ),
            quoteValidityDays: BuiltValueNullFieldError.checkNotNull(
              quoteValidityDays,
              r'PlatformSettings',
              'quoteValidityDays',
            ),
            invitationValidityDays: BuiltValueNullFieldError.checkNotNull(
              invitationValidityDays,
              r'PlatformSettings',
              'invitationValidityDays',
            ),
            otpValidityMinutes: BuiltValueNullFieldError.checkNotNull(
              otpValidityMinutes,
              r'PlatformSettings',
              'otpValidityMinutes',
            ),
            pinLockMinutes: pinLockMinutes.build(),
            paymentCancelHours: BuiltValueNullFieldError.checkNotNull(
              paymentCancelHours,
              r'PlatformSettings',
              'paymentCancelHours',
            ),
            settlementDelayDays: BuiltValueNullFieldError.checkNotNull(
              settlementDelayDays,
              r'PlatformSettings',
              'settlementDelayDays',
            ),
            kycRequiredDocuments: _kycRequiredDocuments?.build(),
            expiredCreditsDestination: BuiltValueNullFieldError.checkNotNull(
              expiredCreditsDestination,
              r'PlatformSettings',
              'expiredCreditsDestination',
            ),
            payoutMinimumMillimes: BuiltValueNullFieldError.checkNotNull(
              payoutMinimumMillimes,
              r'PlatformSettings',
              'payoutMinimumMillimes',
            ),
            creditValidityMonths: BuiltValueNullFieldError.checkNotNull(
              creditValidityMonths,
              r'PlatformSettings',
              'creditValidityMonths',
            ),
            maxFamilyMembers: BuiltValueNullFieldError.checkNotNull(
              maxFamilyMembers,
              r'PlatformSettings',
              'maxFamilyMembers',
            ),
            orderFeeRateBps: BuiltValueNullFieldError.checkNotNull(
              orderFeeRateBps,
              r'PlatformSettings',
              'orderFeeRateBps',
            ),
            vatRateBps: BuiltValueNullFieldError.checkNotNull(
              vatRateBps,
              r'PlatformSettings',
              'vatRateBps',
            ),
            stampDutyMillimes: BuiltValueNullFieldError.checkNotNull(
              stampDutyMillimes,
              r'PlatformSettings',
              'stampDutyMillimes',
            ),
            creditTypes: creditTypes.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'withholding';
        _withholding?.build();

        _$failedField = 'fundingAccount';
        fundingAccount.build();

        _$failedField = 'pinLockMinutes';
        pinLockMinutes.build();

        _$failedField = 'kycRequiredDocuments';
        _kycRequiredDocuments?.build();

        _$failedField = 'creditTypes';
        creditTypes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'PlatformSettings',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
