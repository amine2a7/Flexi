// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overview_invoice.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OverviewInvoice extends OverviewInvoice {
  @override
  final String id;
  @override
  final String number;
  @override
  final InvoiceStatus status;
  @override
  final int totalMillimes;
  @override
  final DateTime issuedAt;

  factory _$OverviewInvoice([void Function(OverviewInvoiceBuilder)? updates]) =>
      (OverviewInvoiceBuilder()..update(updates))._build();

  _$OverviewInvoice._({
    required this.id,
    required this.number,
    required this.status,
    required this.totalMillimes,
    required this.issuedAt,
  }) : super._();
  @override
  OverviewInvoice rebuild(void Function(OverviewInvoiceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OverviewInvoiceBuilder toBuilder() => OverviewInvoiceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OverviewInvoice &&
        id == other.id &&
        number == other.number &&
        status == other.status &&
        totalMillimes == other.totalMillimes &&
        issuedAt == other.issuedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, number.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, totalMillimes.hashCode);
    _$hash = $jc(_$hash, issuedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OverviewInvoice')
          ..add('id', id)
          ..add('number', number)
          ..add('status', status)
          ..add('totalMillimes', totalMillimes)
          ..add('issuedAt', issuedAt))
        .toString();
  }
}

class OverviewInvoiceBuilder
    implements Builder<OverviewInvoice, OverviewInvoiceBuilder> {
  _$OverviewInvoice? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  InvoiceStatus? _status;
  InvoiceStatus? get status => _$this._status;
  set status(InvoiceStatus? status) => _$this._status = status;

  int? _totalMillimes;
  int? get totalMillimes => _$this._totalMillimes;
  set totalMillimes(int? totalMillimes) =>
      _$this._totalMillimes = totalMillimes;

  DateTime? _issuedAt;
  DateTime? get issuedAt => _$this._issuedAt;
  set issuedAt(DateTime? issuedAt) => _$this._issuedAt = issuedAt;

  OverviewInvoiceBuilder() {
    OverviewInvoice._defaults(this);
  }

  OverviewInvoiceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _number = $v.number;
      _status = $v.status;
      _totalMillimes = $v.totalMillimes;
      _issuedAt = $v.issuedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OverviewInvoice other) {
    _$v = other as _$OverviewInvoice;
  }

  @override
  void update(void Function(OverviewInvoiceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OverviewInvoice build() => _build();

  _$OverviewInvoice _build() {
    final _$result =
        _$v ??
        _$OverviewInvoice._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'OverviewInvoice',
            'id',
          ),
          number: BuiltValueNullFieldError.checkNotNull(
            number,
            r'OverviewInvoice',
            'number',
          ),
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'OverviewInvoice',
            'status',
          ),
          totalMillimes: BuiltValueNullFieldError.checkNotNull(
            totalMillimes,
            r'OverviewInvoice',
            'totalMillimes',
          ),
          issuedAt: BuiltValueNullFieldError.checkNotNull(
            issuedAt,
            r'OverviewInvoice',
            'issuedAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
