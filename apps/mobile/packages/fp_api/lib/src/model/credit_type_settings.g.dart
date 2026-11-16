// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_type_settings.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreditTypeSettings extends CreditTypeSettings {
  @override
  final CreditType creditType;
  @override
  final bool enabled;
  @override
  final int commissionRateBps;
  @override
  final int validityMonths;
  @override
  final int dailyLimitMillimes;

  factory _$CreditTypeSettings([
    void Function(CreditTypeSettingsBuilder)? updates,
  ]) => (CreditTypeSettingsBuilder()..update(updates))._build();

  _$CreditTypeSettings._({
    required this.creditType,
    required this.enabled,
    required this.commissionRateBps,
    required this.validityMonths,
    required this.dailyLimitMillimes,
  }) : super._();
  @override
  CreditTypeSettings rebuild(
    void Function(CreditTypeSettingsBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CreditTypeSettingsBuilder toBuilder() =>
      CreditTypeSettingsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreditTypeSettings &&
        creditType == other.creditType &&
        enabled == other.enabled &&
        commissionRateBps == other.commissionRateBps &&
        validityMonths == other.validityMonths &&
        dailyLimitMillimes == other.dailyLimitMillimes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, creditType.hashCode);
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jc(_$hash, commissionRateBps.hashCode);
    _$hash = $jc(_$hash, validityMonths.hashCode);
    _$hash = $jc(_$hash, dailyLimitMillimes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreditTypeSettings')
          ..add('creditType', creditType)
          ..add('enabled', enabled)
          ..add('commissionRateBps', commissionRateBps)
          ..add('validityMonths', validityMonths)
          ..add('dailyLimitMillimes', dailyLimitMillimes))
        .toString();
  }
}

class CreditTypeSettingsBuilder
    implements Builder<CreditTypeSettings, CreditTypeSettingsBuilder> {
  _$CreditTypeSettings? _$v;

  CreditType? _creditType;
  CreditType? get creditType => _$this._creditType;
  set creditType(CreditType? creditType) => _$this._creditType = creditType;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(bool? enabled) => _$this._enabled = enabled;

  int? _commissionRateBps;
  int? get commissionRateBps => _$this._commissionRateBps;
  set commissionRateBps(int? commissionRateBps) =>
      _$this._commissionRateBps = commissionRateBps;

  int? _validityMonths;
  int? get validityMonths => _$this._validityMonths;
  set validityMonths(int? validityMonths) =>
      _$this._validityMonths = validityMonths;

  int? _dailyLimitMillimes;
  int? get dailyLimitMillimes => _$this._dailyLimitMillimes;
  set dailyLimitMillimes(int? dailyLimitMillimes) =>
      _$this._dailyLimitMillimes = dailyLimitMillimes;

  CreditTypeSettingsBuilder() {
    CreditTypeSettings._defaults(this);
  }

  CreditTypeSettingsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _creditType = $v.creditType;
      _enabled = $v.enabled;
      _commissionRateBps = $v.commissionRateBps;
      _validityMonths = $v.validityMonths;
      _dailyLimitMillimes = $v.dailyLimitMillimes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreditTypeSettings other) {
    _$v = other as _$CreditTypeSettings;
  }

  @override
  void update(void Function(CreditTypeSettingsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreditTypeSettings build() => _build();

  _$CreditTypeSettings _build() {
    final _$result =
        _$v ??
        _$CreditTypeSettings._(
          creditType: BuiltValueNullFieldError.checkNotNull(
            creditType,
            r'CreditTypeSettings',
            'creditType',
          ),
          enabled: BuiltValueNullFieldError.checkNotNull(
            enabled,
            r'CreditTypeSettings',
            'enabled',
          ),
          commissionRateBps: BuiltValueNullFieldError.checkNotNull(
            commissionRateBps,
            r'CreditTypeSettings',
            'commissionRateBps',
          ),
          validityMonths: BuiltValueNullFieldError.checkNotNull(
            validityMonths,
            r'CreditTypeSettings',
            'validityMonths',
          ),
          dailyLimitMillimes: BuiltValueNullFieldError.checkNotNull(
            dailyLimitMillimes,
            r'CreditTypeSettings',
            'dailyLimitMillimes',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
