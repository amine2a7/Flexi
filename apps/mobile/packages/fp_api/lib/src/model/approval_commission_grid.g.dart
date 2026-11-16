// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'approval_commission_grid.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApprovalCommissionGrid extends ApprovalCommissionGrid {
  @override
  final BuiltList<CommissionTier>? previous;
  @override
  final BuiltList<CommissionTier> proposed;

  factory _$ApprovalCommissionGrid([
    void Function(ApprovalCommissionGridBuilder)? updates,
  ]) => (ApprovalCommissionGridBuilder()..update(updates))._build();

  _$ApprovalCommissionGrid._({this.previous, required this.proposed})
    : super._();
  @override
  ApprovalCommissionGrid rebuild(
    void Function(ApprovalCommissionGridBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApprovalCommissionGridBuilder toBuilder() =>
      ApprovalCommissionGridBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApprovalCommissionGrid &&
        previous == other.previous &&
        proposed == other.proposed;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, previous.hashCode);
    _$hash = $jc(_$hash, proposed.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApprovalCommissionGrid')
          ..add('previous', previous)
          ..add('proposed', proposed))
        .toString();
  }
}

class ApprovalCommissionGridBuilder
    implements Builder<ApprovalCommissionGrid, ApprovalCommissionGridBuilder> {
  _$ApprovalCommissionGrid? _$v;

  ListBuilder<CommissionTier>? _previous;
  ListBuilder<CommissionTier> get previous =>
      _$this._previous ??= ListBuilder<CommissionTier>();
  set previous(ListBuilder<CommissionTier>? previous) =>
      _$this._previous = previous;

  ListBuilder<CommissionTier>? _proposed;
  ListBuilder<CommissionTier> get proposed =>
      _$this._proposed ??= ListBuilder<CommissionTier>();
  set proposed(ListBuilder<CommissionTier>? proposed) =>
      _$this._proposed = proposed;

  ApprovalCommissionGridBuilder() {
    ApprovalCommissionGrid._defaults(this);
  }

  ApprovalCommissionGridBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _previous = $v.previous?.toBuilder();
      _proposed = $v.proposed.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApprovalCommissionGrid other) {
    _$v = other as _$ApprovalCommissionGrid;
  }

  @override
  void update(void Function(ApprovalCommissionGridBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApprovalCommissionGrid build() => _build();

  _$ApprovalCommissionGrid _build() {
    _$ApprovalCommissionGrid _$result;
    try {
      _$result =
          _$v ??
          _$ApprovalCommissionGrid._(
            previous: _previous?.build(),
            proposed: proposed.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'previous';
        _previous?.build();
        _$failedField = 'proposed';
        proposed.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ApprovalCommissionGrid',
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
