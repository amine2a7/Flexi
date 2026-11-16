// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commission_tier.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CommissionTier extends CommissionTier {
  @override
  final int rateBps;
  @override
  final int? minMillimes;
  @override
  final int? maxMillimes;

  factory _$CommissionTier([void Function(CommissionTierBuilder)? updates]) =>
      (CommissionTierBuilder()..update(updates))._build();

  _$CommissionTier._({
    required this.rateBps,
    this.minMillimes,
    this.maxMillimes,
  }) : super._();
  @override
  CommissionTier rebuild(void Function(CommissionTierBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CommissionTierBuilder toBuilder() => CommissionTierBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CommissionTier &&
        rateBps == other.rateBps &&
        minMillimes == other.minMillimes &&
        maxMillimes == other.maxMillimes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, rateBps.hashCode);
    _$hash = $jc(_$hash, minMillimes.hashCode);
    _$hash = $jc(_$hash, maxMillimes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CommissionTier')
          ..add('rateBps', rateBps)
          ..add('minMillimes', minMillimes)
          ..add('maxMillimes', maxMillimes))
        .toString();
  }
}

class CommissionTierBuilder
    implements Builder<CommissionTier, CommissionTierBuilder> {
  _$CommissionTier? _$v;

  int? _rateBps;
  int? get rateBps => _$this._rateBps;
  set rateBps(int? rateBps) => _$this._rateBps = rateBps;

  int? _minMillimes;
  int? get minMillimes => _$this._minMillimes;
  set minMillimes(int? minMillimes) => _$this._minMillimes = minMillimes;

  int? _maxMillimes;
  int? get maxMillimes => _$this._maxMillimes;
  set maxMillimes(int? maxMillimes) => _$this._maxMillimes = maxMillimes;

  CommissionTierBuilder() {
    CommissionTier._defaults(this);
  }

  CommissionTierBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _rateBps = $v.rateBps;
      _minMillimes = $v.minMillimes;
      _maxMillimes = $v.maxMillimes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CommissionTier other) {
    _$v = other as _$CommissionTier;
  }

  @override
  void update(void Function(CommissionTierBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CommissionTier build() => _build();

  _$CommissionTier _build() {
    final _$result =
        _$v ??
        _$CommissionTier._(
          rateBps: BuiltValueNullFieldError.checkNotNull(
            rateBps,
            r'CommissionTier',
            'rateBps',
          ),
          minMillimes: minMillimes,
          maxMillimes: maxMillimes,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
