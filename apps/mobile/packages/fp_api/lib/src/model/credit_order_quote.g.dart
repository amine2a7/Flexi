// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_order_quote.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreditOrderQuote extends CreditOrderQuote {
  @override
  final String quoteId;
  @override
  final DateTime expiresAt;
  @override
  final BuiltList<CreditOrderLine> lines;
  @override
  final int amountMillimes;
  @override
  final int feeRateBps;
  @override
  final int feesMillimes;
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
  final int totalMillimes;

  factory _$CreditOrderQuote([
    void Function(CreditOrderQuoteBuilder)? updates,
  ]) => (CreditOrderQuoteBuilder()..update(updates))._build();

  _$CreditOrderQuote._({
    required this.quoteId,
    required this.expiresAt,
    required this.lines,
    required this.amountMillimes,
    required this.feeRateBps,
    required this.feesMillimes,
    required this.vatRateBps,
    required this.vatMillimes,
    required this.stampDutyMillimes,
    required this.withholdingRateBps,
    required this.withholdingMillimes,
    required this.transferFeeMillimes,
    required this.totalMillimes,
  }) : super._();
  @override
  CreditOrderQuote rebuild(void Function(CreditOrderQuoteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreditOrderQuoteBuilder toBuilder() =>
      CreditOrderQuoteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreditOrderQuote &&
        quoteId == other.quoteId &&
        expiresAt == other.expiresAt &&
        lines == other.lines &&
        amountMillimes == other.amountMillimes &&
        feeRateBps == other.feeRateBps &&
        feesMillimes == other.feesMillimes &&
        vatRateBps == other.vatRateBps &&
        vatMillimes == other.vatMillimes &&
        stampDutyMillimes == other.stampDutyMillimes &&
        withholdingRateBps == other.withholdingRateBps &&
        withholdingMillimes == other.withholdingMillimes &&
        transferFeeMillimes == other.transferFeeMillimes &&
        totalMillimes == other.totalMillimes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, quoteId.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jc(_$hash, amountMillimes.hashCode);
    _$hash = $jc(_$hash, feeRateBps.hashCode);
    _$hash = $jc(_$hash, feesMillimes.hashCode);
    _$hash = $jc(_$hash, vatRateBps.hashCode);
    _$hash = $jc(_$hash, vatMillimes.hashCode);
    _$hash = $jc(_$hash, stampDutyMillimes.hashCode);
    _$hash = $jc(_$hash, withholdingRateBps.hashCode);
    _$hash = $jc(_$hash, withholdingMillimes.hashCode);
    _$hash = $jc(_$hash, transferFeeMillimes.hashCode);
    _$hash = $jc(_$hash, totalMillimes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreditOrderQuote')
          ..add('quoteId', quoteId)
          ..add('expiresAt', expiresAt)
          ..add('lines', lines)
          ..add('amountMillimes', amountMillimes)
          ..add('feeRateBps', feeRateBps)
          ..add('feesMillimes', feesMillimes)
          ..add('vatRateBps', vatRateBps)
          ..add('vatMillimes', vatMillimes)
          ..add('stampDutyMillimes', stampDutyMillimes)
          ..add('withholdingRateBps', withholdingRateBps)
          ..add('withholdingMillimes', withholdingMillimes)
          ..add('transferFeeMillimes', transferFeeMillimes)
          ..add('totalMillimes', totalMillimes))
        .toString();
  }
}

class CreditOrderQuoteBuilder
    implements Builder<CreditOrderQuote, CreditOrderQuoteBuilder> {
  _$CreditOrderQuote? _$v;

  String? _quoteId;
  String? get quoteId => _$this._quoteId;
  set quoteId(String? quoteId) => _$this._quoteId = quoteId;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  ListBuilder<CreditOrderLine>? _lines;
  ListBuilder<CreditOrderLine> get lines =>
      _$this._lines ??= ListBuilder<CreditOrderLine>();
  set lines(ListBuilder<CreditOrderLine>? lines) => _$this._lines = lines;

  int? _amountMillimes;
  int? get amountMillimes => _$this._amountMillimes;
  set amountMillimes(int? amountMillimes) =>
      _$this._amountMillimes = amountMillimes;

  int? _feeRateBps;
  int? get feeRateBps => _$this._feeRateBps;
  set feeRateBps(int? feeRateBps) => _$this._feeRateBps = feeRateBps;

  int? _feesMillimes;
  int? get feesMillimes => _$this._feesMillimes;
  set feesMillimes(int? feesMillimes) => _$this._feesMillimes = feesMillimes;

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

  int? _totalMillimes;
  int? get totalMillimes => _$this._totalMillimes;
  set totalMillimes(int? totalMillimes) =>
      _$this._totalMillimes = totalMillimes;

  CreditOrderQuoteBuilder() {
    CreditOrderQuote._defaults(this);
  }

  CreditOrderQuoteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _quoteId = $v.quoteId;
      _expiresAt = $v.expiresAt;
      _lines = $v.lines.toBuilder();
      _amountMillimes = $v.amountMillimes;
      _feeRateBps = $v.feeRateBps;
      _feesMillimes = $v.feesMillimes;
      _vatRateBps = $v.vatRateBps;
      _vatMillimes = $v.vatMillimes;
      _stampDutyMillimes = $v.stampDutyMillimes;
      _withholdingRateBps = $v.withholdingRateBps;
      _withholdingMillimes = $v.withholdingMillimes;
      _transferFeeMillimes = $v.transferFeeMillimes;
      _totalMillimes = $v.totalMillimes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreditOrderQuote other) {
    _$v = other as _$CreditOrderQuote;
  }

  @override
  void update(void Function(CreditOrderQuoteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreditOrderQuote build() => _build();

  _$CreditOrderQuote _build() {
    _$CreditOrderQuote _$result;
    try {
      _$result =
          _$v ??
          _$CreditOrderQuote._(
            quoteId: BuiltValueNullFieldError.checkNotNull(
              quoteId,
              r'CreditOrderQuote',
              'quoteId',
            ),
            expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt,
              r'CreditOrderQuote',
              'expiresAt',
            ),
            lines: lines.build(),
            amountMillimes: BuiltValueNullFieldError.checkNotNull(
              amountMillimes,
              r'CreditOrderQuote',
              'amountMillimes',
            ),
            feeRateBps: BuiltValueNullFieldError.checkNotNull(
              feeRateBps,
              r'CreditOrderQuote',
              'feeRateBps',
            ),
            feesMillimes: BuiltValueNullFieldError.checkNotNull(
              feesMillimes,
              r'CreditOrderQuote',
              'feesMillimes',
            ),
            vatRateBps: BuiltValueNullFieldError.checkNotNull(
              vatRateBps,
              r'CreditOrderQuote',
              'vatRateBps',
            ),
            vatMillimes: BuiltValueNullFieldError.checkNotNull(
              vatMillimes,
              r'CreditOrderQuote',
              'vatMillimes',
            ),
            stampDutyMillimes: BuiltValueNullFieldError.checkNotNull(
              stampDutyMillimes,
              r'CreditOrderQuote',
              'stampDutyMillimes',
            ),
            withholdingRateBps: BuiltValueNullFieldError.checkNotNull(
              withholdingRateBps,
              r'CreditOrderQuote',
              'withholdingRateBps',
            ),
            withholdingMillimes: BuiltValueNullFieldError.checkNotNull(
              withholdingMillimes,
              r'CreditOrderQuote',
              'withholdingMillimes',
            ),
            transferFeeMillimes: BuiltValueNullFieldError.checkNotNull(
              transferFeeMillimes,
              r'CreditOrderQuote',
              'transferFeeMillimes',
            ),
            totalMillimes: BuiltValueNullFieldError.checkNotNull(
              totalMillimes,
              r'CreditOrderQuote',
              'totalMillimes',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lines';
        lines.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CreditOrderQuote',
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
