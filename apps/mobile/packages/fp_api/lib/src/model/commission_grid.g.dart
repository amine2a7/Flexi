// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commission_grid.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CommissionGrid extends CommissionGrid {
  @override
  final BuiltList<CommissionTier> tiers;
  @override
  final DateTime effectiveFrom;

  factory _$CommissionGrid([void Function(CommissionGridBuilder)? updates]) =>
      (CommissionGridBuilder()..update(updates))._build();

  _$CommissionGrid._({required this.tiers, required this.effectiveFrom})
    : super._();
  @override
  CommissionGrid rebuild(void Function(CommissionGridBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CommissionGridBuilder toBuilder() => CommissionGridBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CommissionGrid &&
        tiers == other.tiers &&
        effectiveFrom == other.effectiveFrom;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, tiers.hashCode);
    _$hash = $jc(_$hash, effectiveFrom.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CommissionGrid')
          ..add('tiers', tiers)
          ..add('effectiveFrom', effectiveFrom))
        .toString();
  }
}

class CommissionGridBuilder
    implements Builder<CommissionGrid, CommissionGridBuilder> {
  _$CommissionGrid? _$v;

  ListBuilder<CommissionTier>? _tiers;
  ListBuilder<CommissionTier> get tiers =>
      _$this._tiers ??= ListBuilder<CommissionTier>();
  set tiers(ListBuilder<CommissionTier>? tiers) => _$this._tiers = tiers;

  DateTime? _effectiveFrom;
  DateTime? get effectiveFrom => _$this._effectiveFrom;
  set effectiveFrom(DateTime? effectiveFrom) =>
      _$this._effectiveFrom = effectiveFrom;

  CommissionGridBuilder() {
    CommissionGrid._defaults(this);
  }

  CommissionGridBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tiers = $v.tiers.toBuilder();
      _effectiveFrom = $v.effectiveFrom;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CommissionGrid other) {
    _$v = other as _$CommissionGrid;
  }

  @override
  void update(void Function(CommissionGridBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CommissionGrid build() => _build();

  _$CommissionGrid _build() {
    _$CommissionGrid _$result;
    try {
      _$result =
          _$v ??
          _$CommissionGrid._(
            tiers: tiers.build(),
            effectiveFrom: BuiltValueNullFieldError.checkNotNull(
              effectiveFrom,
              r'CommissionGrid',
              'effectiveFrom',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'tiers';
        tiers.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CommissionGrid',
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
