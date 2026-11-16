// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Invoice extends Invoice {
  @override
  final String id;
  @override
  final String number;
  @override
  final String orderReference;
  @override
  final int totalMillimes;
  @override
  final DateTime issuedAt;
  @override
  final InvoiceStatus status;
  @override
  final String? creditNoteNumber;
  @override
  final DateTime? cancelledAt;

  factory _$Invoice([void Function(InvoiceBuilder)? updates]) =>
      (InvoiceBuilder()..update(updates))._build();

  _$Invoice._({
    required this.id,
    required this.number,
    required this.orderReference,
    required this.totalMillimes,
    required this.issuedAt,
    required this.status,
    this.creditNoteNumber,
    this.cancelledAt,
  }) : super._();
  @override
  Invoice rebuild(void Function(InvoiceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InvoiceBuilder toBuilder() => InvoiceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Invoice &&
        id == other.id &&
        number == other.number &&
        orderReference == other.orderReference &&
        totalMillimes == other.totalMillimes &&
        issuedAt == other.issuedAt &&
        status == other.status &&
        creditNoteNumber == other.creditNoteNumber &&
        cancelledAt == other.cancelledAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, number.hashCode);
    _$hash = $jc(_$hash, orderReference.hashCode);
    _$hash = $jc(_$hash, totalMillimes.hashCode);
    _$hash = $jc(_$hash, issuedAt.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, creditNoteNumber.hashCode);
    _$hash = $jc(_$hash, cancelledAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Invoice')
          ..add('id', id)
          ..add('number', number)
          ..add('orderReference', orderReference)
          ..add('totalMillimes', totalMillimes)
          ..add('issuedAt', issuedAt)
          ..add('status', status)
          ..add('creditNoteNumber', creditNoteNumber)
          ..add('cancelledAt', cancelledAt))
        .toString();
  }
}

class InvoiceBuilder implements Builder<Invoice, InvoiceBuilder> {
  _$Invoice? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  String? _orderReference;
  String? get orderReference => _$this._orderReference;
  set orderReference(String? orderReference) =>
      _$this._orderReference = orderReference;

  int? _totalMillimes;
  int? get totalMillimes => _$this._totalMillimes;
  set totalMillimes(int? totalMillimes) =>
      _$this._totalMillimes = totalMillimes;

  DateTime? _issuedAt;
  DateTime? get issuedAt => _$this._issuedAt;
  set issuedAt(DateTime? issuedAt) => _$this._issuedAt = issuedAt;

  InvoiceStatus? _status;
  InvoiceStatus? get status => _$this._status;
  set status(InvoiceStatus? status) => _$this._status = status;

  String? _creditNoteNumber;
  String? get creditNoteNumber => _$this._creditNoteNumber;
  set creditNoteNumber(String? creditNoteNumber) =>
      _$this._creditNoteNumber = creditNoteNumber;

  DateTime? _cancelledAt;
  DateTime? get cancelledAt => _$this._cancelledAt;
  set cancelledAt(DateTime? cancelledAt) => _$this._cancelledAt = cancelledAt;

  InvoiceBuilder() {
    Invoice._defaults(this);
  }

  InvoiceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _number = $v.number;
      _orderReference = $v.orderReference;
      _totalMillimes = $v.totalMillimes;
      _issuedAt = $v.issuedAt;
      _status = $v.status;
      _creditNoteNumber = $v.creditNoteNumber;
      _cancelledAt = $v.cancelledAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Invoice other) {
    _$v = other as _$Invoice;
  }

  @override
  void update(void Function(InvoiceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Invoice build() => _build();

  _$Invoice _build() {
    final _$result =
        _$v ??
        _$Invoice._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'Invoice', 'id'),
          number: BuiltValueNullFieldError.checkNotNull(
            number,
            r'Invoice',
            'number',
          ),
          orderReference: BuiltValueNullFieldError.checkNotNull(
            orderReference,
            r'Invoice',
            'orderReference',
          ),
          totalMillimes: BuiltValueNullFieldError.checkNotNull(
            totalMillimes,
            r'Invoice',
            'totalMillimes',
          ),
          issuedAt: BuiltValueNullFieldError.checkNotNull(
            issuedAt,
            r'Invoice',
            'issuedAt',
          ),
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'Invoice',
            'status',
          ),
          creditNoteNumber: creditNoteNumber,
          cancelledAt: cancelledAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
