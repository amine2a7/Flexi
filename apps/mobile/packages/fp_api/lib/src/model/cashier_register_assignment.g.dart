// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cashier_register_assignment.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CashierRegisterAssignment extends CashierRegisterAssignment {
  @override
  final String? registerId;

  factory _$CashierRegisterAssignment([
    void Function(CashierRegisterAssignmentBuilder)? updates,
  ]) => (CashierRegisterAssignmentBuilder()..update(updates))._build();

  _$CashierRegisterAssignment._({this.registerId}) : super._();
  @override
  CashierRegisterAssignment rebuild(
    void Function(CashierRegisterAssignmentBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CashierRegisterAssignmentBuilder toBuilder() =>
      CashierRegisterAssignmentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CashierRegisterAssignment && registerId == other.registerId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, registerId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'CashierRegisterAssignment',
    )..add('registerId', registerId)).toString();
  }
}

class CashierRegisterAssignmentBuilder
    implements
        Builder<CashierRegisterAssignment, CashierRegisterAssignmentBuilder> {
  _$CashierRegisterAssignment? _$v;

  String? _registerId;
  String? get registerId => _$this._registerId;
  set registerId(String? registerId) => _$this._registerId = registerId;

  CashierRegisterAssignmentBuilder() {
    CashierRegisterAssignment._defaults(this);
  }

  CashierRegisterAssignmentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _registerId = $v.registerId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CashierRegisterAssignment other) {
    _$v = other as _$CashierRegisterAssignment;
  }

  @override
  void update(void Function(CashierRegisterAssignmentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CashierRegisterAssignment build() => _build();

  _$CashierRegisterAssignment _build() {
    final _$result =
        _$v ?? _$CashierRegisterAssignment._(registerId: registerId);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
