// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_order.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreditOrder extends CreditOrder {
  @override
  final DateTime quoteExpiresAt;
  @override
  final bool quoteExpired;
  @override
  final String id;
  @override
  final String reference;
  @override
  final OrderStatus status;
  @override
  final BuiltList<CreditOrderLine> lines;
  @override
  final String companyId;
  @override
  final String companyName;
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
  @override
  final DateTime createdAt;
  @override
  final String paymentReference;
  @override
  final int? declaredAmountMillimes;

  factory _$CreditOrder([void Function(CreditOrderBuilder)? updates]) =>
      (CreditOrderBuilder()..update(updates))._build();

  _$CreditOrder._({
    required this.quoteExpiresAt,
    required this.quoteExpired,
    required this.id,
    required this.reference,
    required this.status,
    required this.lines,
    required this.companyId,
    required this.companyName,
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
    required this.createdAt,
    required this.paymentReference,
    this.declaredAmountMillimes,
  }) : super._();
  @override
  CreditOrder rebuild(void Function(CreditOrderBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreditOrderBuilder toBuilder() => CreditOrderBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreditOrder &&
        quoteExpiresAt == other.quoteExpiresAt &&
        quoteExpired == other.quoteExpired &&
        id == other.id &&
        reference == other.reference &&
        status == other.status &&
        lines == other.lines &&
        companyId == other.companyId &&
        companyName == other.companyName &&
        amountMillimes == other.amountMillimes &&
        feeRateBps == other.feeRateBps &&
        feesMillimes == other.feesMillimes &&
        vatRateBps == other.vatRateBps &&
        vatMillimes == other.vatMillimes &&
        stampDutyMillimes == other.stampDutyMillimes &&
        withholdingRateBps == other.withholdingRateBps &&
        withholdingMillimes == other.withholdingMillimes &&
        transferFeeMillimes == other.transferFeeMillimes &&
        totalMillimes == other.totalMillimes &&
        createdAt == other.createdAt &&
        paymentReference == other.paymentReference &&
        declaredAmountMillimes == other.declaredAmountMillimes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, quoteExpiresAt.hashCode);
    _$hash = $jc(_$hash, quoteExpired.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, reference.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jc(_$hash, companyId.hashCode);
    _$hash = $jc(_$hash, companyName.hashCode);
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
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, paymentReference.hashCode);
    _$hash = $jc(_$hash, declaredAmountMillimes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreditOrder')
          ..add('quoteExpiresAt', quoteExpiresAt)
          ..add('quoteExpired', quoteExpired)
          ..add('id', id)
          ..add('reference', reference)
          ..add('status', status)
          ..add('lines', lines)
          ..add('companyId', companyId)
          ..add('companyName', companyName)
          ..add('amountMillimes', amountMillimes)
          ..add('feeRateBps', feeRateBps)
          ..add('feesMillimes', feesMillimes)
          ..add('vatRateBps', vatRateBps)
          ..add('vatMillimes', vatMillimes)
          ..add('stampDutyMillimes', stampDutyMillimes)
          ..add('withholdingRateBps', withholdingRateBps)
          ..add('withholdingMillimes', withholdingMillimes)
          ..add('transferFeeMillimes', transferFeeMillimes)
          ..add('totalMillimes', totalMillimes)
          ..add('createdAt', createdAt)
          ..add('paymentReference', paymentReference)
          ..add('declaredAmountMillimes', declaredAmountMillimes))
        .toString();
  }
}

class CreditOrderBuilder implements Builder<CreditOrder, CreditOrderBuilder> {
  _$CreditOrder? _$v;

  DateTime? _quoteExpiresAt;
  DateTime? get quoteExpiresAt => _$this._quoteExpiresAt;
  set quoteExpiresAt(DateTime? quoteExpiresAt) =>
      _$this._quoteExpiresAt = quoteExpiresAt;

  bool? _quoteExpired;
  bool? get quoteExpired => _$this._quoteExpired;
  set quoteExpired(bool? quoteExpired) => _$this._quoteExpired = quoteExpired;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _reference;
  String? get reference => _$this._reference;
  set reference(String? reference) => _$this._reference = reference;

  OrderStatus? _status;
  OrderStatus? get status => _$this._status;
  set status(OrderStatus? status) => _$this._status = status;

  ListBuilder<CreditOrderLine>? _lines;
  ListBuilder<CreditOrderLine> get lines =>
      _$this._lines ??= ListBuilder<CreditOrderLine>();
  set lines(ListBuilder<CreditOrderLine>? lines) => _$this._lines = lines;

  String? _companyId;
  String? get companyId => _$this._companyId;
  set companyId(String? companyId) => _$this._companyId = companyId;

  String? _companyName;
  String? get companyName => _$this._companyName;
  set companyName(String? companyName) => _$this._companyName = companyName;

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

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _paymentReference;
  String? get paymentReference => _$this._paymentReference;
  set paymentReference(String? paymentReference) =>
      _$this._paymentReference = paymentReference;

  int? _declaredAmountMillimes;
  int? get declaredAmountMillimes => _$this._declaredAmountMillimes;
  set declaredAmountMillimes(int? declaredAmountMillimes) =>
      _$this._declaredAmountMillimes = declaredAmountMillimes;

  CreditOrderBuilder() {
    CreditOrder._defaults(this);
  }

  CreditOrderBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _quoteExpiresAt = $v.quoteExpiresAt;
      _quoteExpired = $v.quoteExpired;
      _id = $v.id;
      _reference = $v.reference;
      _status = $v.status;
      _lines = $v.lines.toBuilder();
      _companyId = $v.companyId;
      _companyName = $v.companyName;
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
      _createdAt = $v.createdAt;
      _paymentReference = $v.paymentReference;
      _declaredAmountMillimes = $v.declaredAmountMillimes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreditOrder other) {
    _$v = other as _$CreditOrder;
  }

  @override
  void update(void Function(CreditOrderBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreditOrder build() => _build();

  _$CreditOrder _build() {
    _$CreditOrder _$result;
    try {
      _$result =
          _$v ??
          _$CreditOrder._(
            quoteExpiresAt: BuiltValueNullFieldError.checkNotNull(
              quoteExpiresAt,
              r'CreditOrder',
              'quoteExpiresAt',
            ),
            quoteExpired: BuiltValueNullFieldError.checkNotNull(
              quoteExpired,
              r'CreditOrder',
              'quoteExpired',
            ),
            id: BuiltValueNullFieldError.checkNotNull(id, r'CreditOrder', 'id'),
            reference: BuiltValueNullFieldError.checkNotNull(
              reference,
              r'CreditOrder',
              'reference',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'CreditOrder',
              'status',
            ),
            lines: lines.build(),
            companyId: BuiltValueNullFieldError.checkNotNull(
              companyId,
              r'CreditOrder',
              'companyId',
            ),
            companyName: BuiltValueNullFieldError.checkNotNull(
              companyName,
              r'CreditOrder',
              'companyName',
            ),
            amountMillimes: BuiltValueNullFieldError.checkNotNull(
              amountMillimes,
              r'CreditOrder',
              'amountMillimes',
            ),
            feeRateBps: BuiltValueNullFieldError.checkNotNull(
              feeRateBps,
              r'CreditOrder',
              'feeRateBps',
            ),
            feesMillimes: BuiltValueNullFieldError.checkNotNull(
              feesMillimes,
              r'CreditOrder',
              'feesMillimes',
            ),
            vatRateBps: BuiltValueNullFieldError.checkNotNull(
              vatRateBps,
              r'CreditOrder',
              'vatRateBps',
            ),
            vatMillimes: BuiltValueNullFieldError.checkNotNull(
              vatMillimes,
              r'CreditOrder',
              'vatMillimes',
            ),
            stampDutyMillimes: BuiltValueNullFieldError.checkNotNull(
              stampDutyMillimes,
              r'CreditOrder',
              'stampDutyMillimes',
            ),
            withholdingRateBps: BuiltValueNullFieldError.checkNotNull(
              withholdingRateBps,
              r'CreditOrder',
              'withholdingRateBps',
            ),
            withholdingMillimes: BuiltValueNullFieldError.checkNotNull(
              withholdingMillimes,
              r'CreditOrder',
              'withholdingMillimes',
            ),
            transferFeeMillimes: BuiltValueNullFieldError.checkNotNull(
              transferFeeMillimes,
              r'CreditOrder',
              'transferFeeMillimes',
            ),
            totalMillimes: BuiltValueNullFieldError.checkNotNull(
              totalMillimes,
              r'CreditOrder',
              'totalMillimes',
            ),
            createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'CreditOrder',
              'createdAt',
            ),
            paymentReference: BuiltValueNullFieldError.checkNotNull(
              paymentReference,
              r'CreditOrder',
              'paymentReference',
            ),
            declaredAmountMillimes: declaredAmountMillimes,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lines';
        lines.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CreditOrder',
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
