// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payout_quote.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PayoutQuote extends PayoutQuote {
  @override
  final CreditType creditType;
  @override
  final String quoteId;
  @override
  final int grossMillimes;
  @override
  final int commissionRateBps;
  @override
  final int commissionMillimes;
  @override
  final int vatRateBps;
  @override
  final int vatMillimes;
  @override
  final int stampDutyMillimes;
  @override
  final int withholdingRateBps;
  @override
  final int withholdingMillimes;
  @override
  final int transferFeeMillimes;
  @override
  final int netMillimes;
  @override
  final int availableMillimes;
  @override
  final DateTime expiresAt;

  factory _$PayoutQuote([void Function(PayoutQuoteBuilder)? updates]) =>
      (PayoutQuoteBuilder()..update(updates))._build();

  _$PayoutQuote._({
    required this.creditType,
    required this.quoteId,
    required this.grossMillimes,
    required this.commissionRateBps,
    required this.commissionMillimes,
    required this.vatRateBps,
    required this.vatMillimes,
    required this.stampDutyMillimes,
    required this.withholdingRateBps,
    required this.withholdingMillimes,
    required this.transferFeeMillimes,
    required this.netMillimes,
    required this.availableMillimes,
    required this.expiresAt,
  }) : super._();
  @override
  PayoutQuote rebuild(void Function(PayoutQuoteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PayoutQuoteBuilder toBuilder() => PayoutQuoteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PayoutQuote &&
        creditType == other.creditType &&
        quoteId == other.quoteId &&
        grossMillimes == other.grossMillimes &&
        commissionRateBps == other.commissionRateBps &&
        commissionMillimes == other.commissionMillimes &&
        vatRateBps == other.vatRateBps &&
        vatMillimes == other.vatMillimes &&
        stampDutyMillimes == other.stampDutyMillimes &&
        withholdingRateBps == other.withholdingRateBps &&
        withholdingMillimes == other.withholdingMillimes &&
        transferFeeMillimes == other.transferFeeMillimes &&
        netMillimes == other.netMillimes &&
        availableMillimes == other.availableMillimes &&
        expiresAt == other.expiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, creditType.hashCode);
    _$hash = $jc(_$hash, quoteId.hashCode);
    _$hash = $jc(_$hash, grossMillimes.hashCode);
    _$hash = $jc(_$hash, commissionRateBps.hashCode);
    _$hash = $jc(_$hash, commissionMillimes.hashCode);
    _$hash = $jc(_$hash, vatRateBps.hashCode);
    _$hash = $jc(_$hash, vatMillimes.hashCode);
    _$hash = $jc(_$hash, stampDutyMillimes.hashCode);
    _$hash = $jc(_$hash, withholdingRateBps.hashCode);
    _$hash = $jc(_$hash, withholdingMillimes.hashCode);
    _$hash = $jc(_$hash, transferFeeMillimes.hashCode);
    _$hash = $jc(_$hash, netMillimes.hashCode);
    _$hash = $jc(_$hash, availableMillimes.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PayoutQuote')
          ..add('creditType', creditType)
          ..add('quoteId', quoteId)
          ..add('grossMillimes', grossMillimes)
          ..add('commissionRateBps', commissionRateBps)
          ..add('commissionMillimes', commissionMillimes)
          ..add('vatRateBps', vatRateBps)
          ..add('vatMillimes', vatMillimes)
          ..add('stampDutyMillimes', stampDutyMillimes)
          ..add('withholdingRateBps', withholdingRateBps)
          ..add('withholdingMillimes', withholdingMillimes)
          ..add('transferFeeMillimes', transferFeeMillimes)
          ..add('netMillimes', netMillimes)
          ..add('availableMillimes', availableMillimes)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class PayoutQuoteBuilder implements Builder<PayoutQuote, PayoutQuoteBuilder> {
  _$PayoutQuote? _$v;

  CreditType? _creditType;
  CreditType? get creditType => _$this._creditType;
  set creditType(CreditType? creditType) => _$this._creditType = creditType;

  String? _quoteId;
  String? get quoteId => _$this._quoteId;
  set quoteId(String? quoteId) => _$this._quoteId = quoteId;

  int? _grossMillimes;
  int? get grossMillimes => _$this._grossMillimes;
  set grossMillimes(int? grossMillimes) =>
      _$this._grossMillimes = grossMillimes;

  int? _commissionRateBps;
  int? get commissionRateBps => _$this._commissionRateBps;
  set commissionRateBps(int? commissionRateBps) =>
      _$this._commissionRateBps = commissionRateBps;

  int? _commissionMillimes;
  int? get commissionMillimes => _$this._commissionMillimes;
  set commissionMillimes(int? commissionMillimes) =>
      _$this._commissionMillimes = commissionMillimes;

  int? _vatRateBps;
  int? get vatRateBps => _$this._vatRateBps;
  set vatRateBps(int? vatRateBps) => _$this._vatRateBps = vatRateBps;

  int? _vatMillimes;
  int? get vatMillimes => _$this._vatMillimes;
  set vatMillimes(int? vatMillimes) => _$this._vatMillimes = vatMillimes;

  int? _stampDutyMillimes;
  int? get stampDutyMillimes => _$this._stampDutyMillimes;
  set stampDutyMillimes(int? stampDutyMillimes) =>
      _$this._stampDutyMillimes = stampDutyMillimes;

  int? _withholdingRateBps;
  int? get withholdingRateBps => _$this._withholdingRateBps;
  set withholdingRateBps(int? withholdingRateBps) =>
      _$this._withholdingRateBps = withholdingRateBps;

  int? _withholdingMillimes;
  int? get withholdingMillimes => _$this._withholdingMillimes;
  set withholdingMillimes(int? withholdingMillimes) =>
      _$this._withholdingMillimes = withholdingMillimes;

  int? _transferFeeMillimes;
  int? get transferFeeMillimes => _$this._transferFeeMillimes;
  set transferFeeMillimes(int? transferFeeMillimes) =>
      _$this._transferFeeMillimes = transferFeeMillimes;

  int? _netMillimes;
  int? get netMillimes => _$this._netMillimes;
  set netMillimes(int? netMillimes) => _$this._netMillimes = netMillimes;

  int? _availableMillimes;
  int? get availableMillimes => _$this._availableMillimes;
  set availableMillimes(int? availableMillimes) =>
      _$this._availableMillimes = availableMillimes;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  PayoutQuoteBuilder() {
    PayoutQuote._defaults(this);
  }

  PayoutQuoteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _creditType = $v.creditType;
      _quoteId = $v.quoteId;
      _grossMillimes = $v.grossMillimes;
      _commissionRateBps = $v.commissionRateBps;
      _commissionMillimes = $v.commissionMillimes;
      _vatRateBps = $v.vatRateBps;
      _vatMillimes = $v.vatMillimes;
      _stampDutyMillimes = $v.stampDutyMillimes;
      _withholdingRateBps = $v.withholdingRateBps;
      _withholdingMillimes = $v.withholdingMillimes;
      _transferFeeMillimes = $v.transferFeeMillimes;
      _netMillimes = $v.netMillimes;
      _availableMillimes = $v.availableMillimes;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PayoutQuote other) {
    _$v = other as _$PayoutQuote;
  }

  @override
  void update(void Function(PayoutQuoteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PayoutQuote build() => _build();

  _$PayoutQuote _build() {
    final _$result =
        _$v ??
        _$PayoutQuote._(
          creditType: BuiltValueNullFieldError.checkNotNull(
            creditType,
            r'PayoutQuote',
            'creditType',
          ),
          quoteId: BuiltValueNullFieldError.checkNotNull(
            quoteId,
            r'PayoutQuote',
            'quoteId',
          ),
          grossMillimes: BuiltValueNullFieldError.checkNotNull(
            grossMillimes,
            r'PayoutQuote',
            'grossMillimes',
          ),
          commissionRateBps: BuiltValueNullFieldError.checkNotNull(
            commissionRateBps,
            r'PayoutQuote',
            'commissionRateBps',
          ),
          commissionMillimes: BuiltValueNullFieldError.checkNotNull(
            commissionMillimes,
            r'PayoutQuote',
            'commissionMillimes',
          ),
          vatRateBps: BuiltValueNullFieldError.checkNotNull(
            vatRateBps,
            r'PayoutQuote',
            'vatRateBps',
          ),
          vatMillimes: BuiltValueNullFieldError.checkNotNull(
            vatMillimes,
            r'PayoutQuote',
            'vatMillimes',
          ),
          stampDutyMillimes: BuiltValueNullFieldError.checkNotNull(
            stampDutyMillimes,
            r'PayoutQuote',
            'stampDutyMillimes',
          ),
          withholdingRateBps: BuiltValueNullFieldError.checkNotNull(
            withholdingRateBps,
            r'PayoutQuote',
            'withholdingRateBps',
          ),
          withholdingMillimes: BuiltValueNullFieldError.checkNotNull(
            withholdingMillimes,
            r'PayoutQuote',
            'withholdingMillimes',
          ),
          transferFeeMillimes: BuiltValueNullFieldError.checkNotNull(
            transferFeeMillimes,
            r'PayoutQuote',
            'transferFeeMillimes',
          ),
          netMillimes: BuiltValueNullFieldError.checkNotNull(
            netMillimes,
            r'PayoutQuote',
            'netMillimes',
          ),
          availableMillimes: BuiltValueNullFieldError.checkNotNull(
            availableMillimes,
            r'PayoutQuote',
            'availableMillimes',
          ),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
            expiresAt,
            r'PayoutQuote',
            'expiresAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
