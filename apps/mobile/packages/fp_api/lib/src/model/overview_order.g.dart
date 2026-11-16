// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overview_order.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OverviewOrder extends OverviewOrder {
  @override
  final String id;
  @override
  final String reference;
  @override
  final OrderStatus status;
  @override
  final int amountMillimes;
  @override
  final int totalMillimes;
  @override
  final DateTime createdAt;

  factory _$OverviewOrder([void Function(OverviewOrderBuilder)? updates]) =>
      (OverviewOrderBuilder()..update(updates))._build();

  _$OverviewOrder._({
    required this.id,
    required this.reference,
    required this.status,
    required this.amountMillimes,
    required this.totalMillimes,
    required this.createdAt,
  }) : super._();
  @override
  OverviewOrder rebuild(void Function(OverviewOrderBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OverviewOrderBuilder toBuilder() => OverviewOrderBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OverviewOrder &&
        id == other.id &&
        reference == other.reference &&
        status == other.status &&
        amountMillimes == other.amountMillimes &&
        totalMillimes == other.totalMillimes &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, reference.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, amountMillimes.hashCode);
    _$hash = $jc(_$hash, totalMillimes.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OverviewOrder')
          ..add('id', id)
          ..add('reference', reference)
          ..add('status', status)
          ..add('amountMillimes', amountMillimes)
          ..add('totalMillimes', totalMillimes)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class OverviewOrderBuilder
    implements Builder<OverviewOrder, OverviewOrderBuilder> {
  _$OverviewOrder? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _reference;
  String? get reference => _$this._reference;
  set reference(String? reference) => _$this._reference = reference;

  OrderStatus? _status;
  OrderStatus? get status => _$this._status;
  set status(OrderStatus? status) => _$this._status = status;

  int? _amountMillimes;
  int? get amountMillimes => _$this._amountMillimes;
  set amountMillimes(int? amountMillimes) =>
      _$this._amountMillimes = amountMillimes;

  int? _totalMillimes;
  int? get totalMillimes => _$this._totalMillimes;
  set totalMillimes(int? totalMillimes) =>
      _$this._totalMillimes = totalMillimes;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  OverviewOrderBuilder() {
    OverviewOrder._defaults(this);
  }

  OverviewOrderBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _reference = $v.reference;
      _status = $v.status;
      _amountMillimes = $v.amountMillimes;
      _totalMillimes = $v.totalMillimes;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OverviewOrder other) {
    _$v = other as _$OverviewOrder;
  }

  @override
  void update(void Function(OverviewOrderBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OverviewOrder build() => _build();

  _$OverviewOrder _build() {
    final _$result =
        _$v ??
        _$OverviewOrder._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'OverviewOrder', 'id'),
          reference: BuiltValueNullFieldError.checkNotNull(
            reference,
            r'OverviewOrder',
            'reference',
          ),
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'OverviewOrder',
            'status',
          ),
          amountMillimes: BuiltValueNullFieldError.checkNotNull(
            amountMillimes,
            r'OverviewOrder',
            'amountMillimes',
          ),
          totalMillimes: BuiltValueNullFieldError.checkNotNull(
            totalMillimes,
            r'OverviewOrder',
            'totalMillimes',
          ),
          createdAt: BuiltValueNullFieldError.checkNotNull(
            createdAt,
            r'OverviewOrder',
            'createdAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
