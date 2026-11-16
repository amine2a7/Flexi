// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_operation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EmployeeOperation extends EmployeeOperation {
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
  final EmployeeOperationStatus status;
  @override
  final DateTime occurredAt;

  factory _$EmployeeOperation([
    void Function(EmployeeOperationBuilder)? updates,
  ]) => (EmployeeOperationBuilder()..update(updates))._build();

  _$EmployeeOperation._({
    required this.id,
    required this.reference,
    required this.type,
    required this.direction,
    required this.amountMillimes,
    required this.creditType,
    required this.counterpartyName,
    required this.status,
    required this.occurredAt,
  }) : super._();
  @override
  EmployeeOperation rebuild(void Function(EmployeeOperationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EmployeeOperationBuilder toBuilder() =>
      EmployeeOperationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmployeeOperation &&
        id == other.id &&
        reference == other.reference &&
        type == other.type &&
        direction == other.direction &&
        amountMillimes == other.amountMillimes &&
        creditType == other.creditType &&
        counterpartyName == other.counterpartyName &&
        status == other.status &&
        occurredAt == other.occurredAt;
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
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, occurredAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EmployeeOperation')
          ..add('id', id)
          ..add('reference', reference)
          ..add('type', type)
          ..add('direction', direction)
          ..add('amountMillimes', amountMillimes)
          ..add('creditType', creditType)
          ..add('counterpartyName', counterpartyName)
          ..add('status', status)
          ..add('occurredAt', occurredAt))
        .toString();
  }
}

class EmployeeOperationBuilder
    implements Builder<EmployeeOperation, EmployeeOperationBuilder> {
  _$EmployeeOperation? _$v;

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

  EmployeeOperationStatus? _status;
  EmployeeOperationStatus? get status => _$this._status;
  set status(EmployeeOperationStatus? status) => _$this._status = status;

  DateTime? _occurredAt;
  DateTime? get occurredAt => _$this._occurredAt;
  set occurredAt(DateTime? occurredAt) => _$this._occurredAt = occurredAt;

  EmployeeOperationBuilder() {
    EmployeeOperation._defaults(this);
  }

  EmployeeOperationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _reference = $v.reference;
      _type = $v.type;
      _direction = $v.direction;
      _amountMillimes = $v.amountMillimes;
      _creditType = $v.creditType;
      _counterpartyName = $v.counterpartyName;
      _status = $v.status;
      _occurredAt = $v.occurredAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EmployeeOperation other) {
    _$v = other as _$EmployeeOperation;
  }

  @override
  void update(void Function(EmployeeOperationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmployeeOperation build() => _build();

  _$EmployeeOperation _build() {
    final _$result =
        _$v ??
        _$EmployeeOperation._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'EmployeeOperation',
            'id',
          ),
          reference: BuiltValueNullFieldError.checkNotNull(
            reference,
            r'EmployeeOperation',
            'reference',
          ),
          type: BuiltValueNullFieldError.checkNotNull(
            type,
            r'EmployeeOperation',
            'type',
          ),
          direction: BuiltValueNullFieldError.checkNotNull(
            direction,
            r'EmployeeOperation',
            'direction',
          ),
          amountMillimes: BuiltValueNullFieldError.checkNotNull(
            amountMillimes,
            r'EmployeeOperation',
            'amountMillimes',
          ),
          creditType: BuiltValueNullFieldError.checkNotNull(
            creditType,
            r'EmployeeOperation',
            'creditType',
          ),
          counterpartyName: BuiltValueNullFieldError.checkNotNull(
            counterpartyName,
            r'EmployeeOperation',
            'counterpartyName',
          ),
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'EmployeeOperation',
            'status',
          ),
          occurredAt: BuiltValueNullFieldError.checkNotNull(
            occurredAt,
            r'EmployeeOperation',
            'occurredAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
