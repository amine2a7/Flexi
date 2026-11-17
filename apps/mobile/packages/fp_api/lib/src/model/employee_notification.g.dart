// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_notification.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EmployeeNotification extends EmployeeNotification {
  @override
  final String id;
  @override
  final EmployeeNotificationKind kind;
  @override
  final DateTime occurredAt;
  @override
  final bool unread;
  @override
  final int? amountMillimes;
  @override
  final CreditType? creditType;
  @override
  final String? counterpartyName;

  factory _$EmployeeNotification([
    void Function(EmployeeNotificationBuilder)? updates,
  ]) => (EmployeeNotificationBuilder()..update(updates))._build();

  _$EmployeeNotification._({
    required this.id,
    required this.kind,
    required this.occurredAt,
    required this.unread,
    this.amountMillimes,
    this.creditType,
    this.counterpartyName,
  }) : super._();
  @override
  EmployeeNotification rebuild(
    void Function(EmployeeNotificationBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  EmployeeNotificationBuilder toBuilder() =>
      EmployeeNotificationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmployeeNotification &&
        id == other.id &&
        kind == other.kind &&
        occurredAt == other.occurredAt &&
        unread == other.unread &&
        amountMillimes == other.amountMillimes &&
        creditType == other.creditType &&
        counterpartyName == other.counterpartyName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, occurredAt.hashCode);
    _$hash = $jc(_$hash, unread.hashCode);
    _$hash = $jc(_$hash, amountMillimes.hashCode);
    _$hash = $jc(_$hash, creditType.hashCode);
    _$hash = $jc(_$hash, counterpartyName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EmployeeNotification')
          ..add('id', id)
          ..add('kind', kind)
          ..add('occurredAt', occurredAt)
          ..add('unread', unread)
          ..add('amountMillimes', amountMillimes)
          ..add('creditType', creditType)
          ..add('counterpartyName', counterpartyName))
        .toString();
  }
}

class EmployeeNotificationBuilder
    implements Builder<EmployeeNotification, EmployeeNotificationBuilder> {
  _$EmployeeNotification? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  EmployeeNotificationKind? _kind;
  EmployeeNotificationKind? get kind => _$this._kind;
  set kind(EmployeeNotificationKind? kind) => _$this._kind = kind;

  DateTime? _occurredAt;
  DateTime? get occurredAt => _$this._occurredAt;
  set occurredAt(DateTime? occurredAt) => _$this._occurredAt = occurredAt;

  bool? _unread;
  bool? get unread => _$this._unread;
  set unread(bool? unread) => _$this._unread = unread;

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

  EmployeeNotificationBuilder() {
    EmployeeNotification._defaults(this);
  }

  EmployeeNotificationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _kind = $v.kind;
      _occurredAt = $v.occurredAt;
      _unread = $v.unread;
      _amountMillimes = $v.amountMillimes;
      _creditType = $v.creditType;
      _counterpartyName = $v.counterpartyName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EmployeeNotification other) {
    _$v = other as _$EmployeeNotification;
  }

  @override
  void update(void Function(EmployeeNotificationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmployeeNotification build() => _build();

  _$EmployeeNotification _build() {
    final _$result =
        _$v ??
        _$EmployeeNotification._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'EmployeeNotification',
            'id',
          ),
          kind: BuiltValueNullFieldError.checkNotNull(
            kind,
            r'EmployeeNotification',
            'kind',
          ),
          occurredAt: BuiltValueNullFieldError.checkNotNull(
            occurredAt,
            r'EmployeeNotification',
            'occurredAt',
          ),
          unread: BuiltValueNullFieldError.checkNotNull(
            unread,
            r'EmployeeNotification',
            'unread',
          ),
          amountMillimes: amountMillimes,
          creditType: creditType,
          counterpartyName: counterpartyName,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
