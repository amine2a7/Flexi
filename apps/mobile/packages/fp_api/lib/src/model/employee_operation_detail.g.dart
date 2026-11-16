// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_operation_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EmployeeOperationDetail extends EmployeeOperationDetail {
  @override
  final String id;
  @override
  final String reference;
  @override
  final EmployeeOperationType type;
  @override
  final Direction direction;
  @override
  final int amountMillimes;
  @override
  final CreditType creditType;
  @override
  final String counterpartyName;
  @override
  final String? counterpartyCity;
  @override
  final EmployeeOperationStatus status;
  @override
  final DateTime occurredAt;
  @override
  final int balanceAfterMillimes;

  factory _$EmployeeOperationDetail([
    void Function(EmployeeOperationDetailBuilder)? updates,
  ]) => (EmployeeOperationDetailBuilder()..update(updates))._build();

  _$EmployeeOperationDetail._({
    required this.id,
    required this.reference,
    required this.type,
    required this.direction,
    required this.amountMillimes,
    required this.creditType,
    required this.counterpartyName,
    this.counterpartyCity,
    required this.status,
    required this.occurredAt,
    required this.balanceAfterMillimes,
  }) : super._();
  @override
  EmployeeOperationDetail rebuild(
    void Function(EmployeeOperationDetailBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  EmployeeOperationDetailBuilder toBuilder() =>
      EmployeeOperationDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmployeeOperationDetail &&
        id == other.id &&
        reference == other.reference &&
        type == other.type &&
        direction == other.direction &&
        amountMillimes == other.amountMillimes &&
        creditType == other.creditType &&
        counterpartyName == other.counterpartyName &&
        counterpartyCity == other.counterpartyCity &&
        status == other.status &&
        occurredAt == other.occurredAt &&
        balanceAfterMillimes == other.balanceAfterMillimes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, reference.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, direction.hashCode);
    _$hash = $jc(_$hash, amountMillimes.hashCode);
    _$hash = $jc(_$hash, creditType.hashCode);
    _$hash = $jc(_$hash, counterpartyName.hashCode);
    _$hash = $jc(_$hash, counterpartyCity.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, occurredAt.hashCode);
    _$hash = $jc(_$hash, balanceAfterMillimes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EmployeeOperationDetail')
          ..add('id', id)
          ..add('reference', reference)
          ..add('type', type)
          ..add('direction', direction)
          ..add('amountMillimes', amountMillimes)
          ..add('creditType', creditType)
          ..add('counterpartyName', counterpartyName)
          ..add('counterpartyCity', counterpartyCity)
          ..add('status', status)
          ..add('occurredAt', occurredAt)
          ..add('balanceAfterMillimes', balanceAfterMillimes))
        .toString();
  }
}

class EmployeeOperationDetailBuilder
    implements
        Builder<EmployeeOperationDetail, EmployeeOperationDetailBuilder> {
  _$EmployeeOperationDetail? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _reference;
  String? get reference => _$this._reference;
  set reference(String? reference) => _$this._reference = reference;

  EmployeeOperationType? _type;
  EmployeeOperationType? get type => _$this._type;
  set type(EmployeeOperationType? type) => _$this._type = type;

  Direction? _direction;
  Direction? get direction => _$this._direction;
  set direction(Direction? direction) => _$this._direction = direction;

  int? _amountMillimes;
  int? get amountMillimes => _$this._amountMillimes;
  set amountMillimes(int? amountMillimes) =>
      _$this._amountMillimes = amountMillimes;

  CreditType? _creditType;
  CreditType? get creditType => _$this._creditType;
  set creditType(CreditType? creditType) => _$this._creditType = creditType;

  String? _counterpartyName;
  String? get counterpartyName => _$this._counterpartyName;
  set counterpartyName(String? counterpartyName) =>
      _$this._counterpartyName = counterpartyName;

  String? _counterpartyCity;
  String? get counterpartyCity => _$this._counterpartyCity;
  set counterpartyCity(String? counterpartyCity) =>
      _$this._counterpartyCity = counterpartyCity;

  EmployeeOperationStatus? _status;
  EmployeeOperationStatus? get status => _$this._status;
  set status(EmployeeOperationStatus? status) => _$this._status = status;

  DateTime? _occurredAt;
  DateTime? get occurredAt => _$this._occurredAt;
  set occurredAt(DateTime? occurredAt) => _$this._occurredAt = occurredAt;

  int? _balanceAfterMillimes;
  int? get balanceAfterMillimes => _$this._balanceAfterMillimes;
  set balanceAfterMillimes(int? balanceAfterMillimes) =>
      _$this._balanceAfterMillimes = balanceAfterMillimes;

  EmployeeOperationDetailBuilder() {
    EmployeeOperationDetail._defaults(this);
  }

  EmployeeOperationDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _reference = $v.reference;
      _type = $v.type;
      _direction = $v.direction;
      _amountMillimes = $v.amountMillimes;
      _creditType = $v.creditType;
      _counterpartyName = $v.counterpartyName;
      _counterpartyCity = $v.counterpartyCity;
      _status = $v.status;
      _occurredAt = $v.occurredAt;
      _balanceAfterMillimes = $v.balanceAfterMillimes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EmployeeOperationDetail other) {
    _$v = other as _$EmployeeOperationDetail;
  }

  @override
  void update(void Function(EmployeeOperationDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmployeeOperationDetail build() => _build();

  _$EmployeeOperationDetail _build() {
    final _$result =
        _$v ??
        _$EmployeeOperationDetail._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'EmployeeOperationDetail',
            'id',
          ),
          reference: BuiltValueNullFieldError.checkNotNull(
            reference,
            r'EmployeeOperationDetail',
            'reference',
          ),
          type: BuiltValueNullFieldError.checkNotNull(
            type,
            r'EmployeeOperationDetail',
            'type',
          ),
          direction: BuiltValueNullFieldError.checkNotNull(
            direction,
            r'EmployeeOperationDetail',
            'direction',
          ),
          amountMillimes: BuiltValueNullFieldError.checkNotNull(
            amountMillimes,
            r'EmployeeOperationDetail',
            'amountMillimes',
          ),
          creditType: BuiltValueNullFieldError.checkNotNull(
            creditType,
            r'EmployeeOperationDetail',
            'creditType',
          ),
          counterpartyName: BuiltValueNullFieldError.checkNotNull(
            counterpartyName,
            r'EmployeeOperationDetail',
            'counterpartyName',
          ),
          counterpartyCity: counterpartyCity,
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'EmployeeOperationDetail',
            'status',
          ),
          occurredAt: BuiltValueNullFieldError.checkNotNull(
            occurredAt,
            r'EmployeeOperationDetail',
            'occurredAt',
          ),
          balanceAfterMillimes: BuiltValueNullFieldError.checkNotNull(
            balanceAfterMillimes,
            r'EmployeeOperationDetail',
            'balanceAfterMillimes',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
