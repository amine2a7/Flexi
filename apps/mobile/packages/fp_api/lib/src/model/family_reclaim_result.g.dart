// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_reclaim_result.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FamilyReclaimResult extends FamilyReclaimResult {
  @override
  final String memberId;
  @override
  final int reclaimedMillimes;

  factory _$FamilyReclaimResult([
    void Function(FamilyReclaimResultBuilder)? updates,
  ]) => (FamilyReclaimResultBuilder()..update(updates))._build();

  _$FamilyReclaimResult._({
    required this.memberId,
    required this.reclaimedMillimes,
  }) : super._();
  @override
  FamilyReclaimResult rebuild(
    void Function(FamilyReclaimResultBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  FamilyReclaimResultBuilder toBuilder() =>
      FamilyReclaimResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FamilyReclaimResult &&
        memberId == other.memberId &&
        reclaimedMillimes == other.reclaimedMillimes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, memberId.hashCode);
    _$hash = $jc(_$hash, reclaimedMillimes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FamilyReclaimResult')
          ..add('memberId', memberId)
          ..add('reclaimedMillimes', reclaimedMillimes))
        .toString();
  }
}

class FamilyReclaimResultBuilder
    implements Builder<FamilyReclaimResult, FamilyReclaimResultBuilder> {
  _$FamilyReclaimResult? _$v;

  String? _memberId;
  String? get memberId => _$this._memberId;
  set memberId(String? memberId) => _$this._memberId = memberId;

  int? _reclaimedMillimes;
  int? get reclaimedMillimes => _$this._reclaimedMillimes;
  set reclaimedMillimes(int? reclaimedMillimes) =>
      _$this._reclaimedMillimes = reclaimedMillimes;

  FamilyReclaimResultBuilder() {
    FamilyReclaimResult._defaults(this);
  }

  FamilyReclaimResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _memberId = $v.memberId;
      _reclaimedMillimes = $v.reclaimedMillimes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FamilyReclaimResult other) {
    _$v = other as _$FamilyReclaimResult;
  }

  @override
  void update(void Function(FamilyReclaimResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FamilyReclaimResult build() => _build();

  _$FamilyReclaimResult _build() {
    final _$result =
        _$v ??
        _$FamilyReclaimResult._(
          memberId: BuiltValueNullFieldError.checkNotNull(
            memberId,
            r'FamilyReclaimResult',
            'memberId',
          ),
          reclaimedMillimes: BuiltValueNullFieldError.checkNotNull(
            reclaimedMillimes,
            r'FamilyReclaimResult',
            'reclaimedMillimes',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
