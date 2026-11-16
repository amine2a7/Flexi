// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_reclaim.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FamilyReclaim extends FamilyReclaim {
  @override
  final CreditType? creditType;

  factory _$FamilyReclaim([void Function(FamilyReclaimBuilder)? updates]) =>
      (FamilyReclaimBuilder()..update(updates))._build();

  _$FamilyReclaim._({this.creditType}) : super._();
  @override
  FamilyReclaim rebuild(void Function(FamilyReclaimBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FamilyReclaimBuilder toBuilder() => FamilyReclaimBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FamilyReclaim && creditType == other.creditType;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, creditType.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'FamilyReclaim',
    )..add('creditType', creditType)).toString();
  }
}

class FamilyReclaimBuilder
    implements Builder<FamilyReclaim, FamilyReclaimBuilder> {
  _$FamilyReclaim? _$v;

  CreditType? _creditType;
  CreditType? get creditType => _$this._creditType;
  set creditType(CreditType? creditType) => _$this._creditType = creditType;

  FamilyReclaimBuilder() {
    FamilyReclaim._defaults(this);
  }

  FamilyReclaimBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _creditType = $v.creditType;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FamilyReclaim other) {
    _$v = other as _$FamilyReclaim;
  }

  @override
  void update(void Function(FamilyReclaimBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FamilyReclaim build() => _build();

  _$FamilyReclaim _build() {
    final _$result = _$v ?? _$FamilyReclaim._(creditType: creditType);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
