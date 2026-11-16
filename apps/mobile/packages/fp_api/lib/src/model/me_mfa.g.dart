// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me_mfa.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MeMfa extends MeMfa {
  @override
  final bool required_;
  @override
  final bool enrolled;
  @override
  final int recoveryCodesRemaining;

  factory _$MeMfa([void Function(MeMfaBuilder)? updates]) =>
      (MeMfaBuilder()..update(updates))._build();

  _$MeMfa._({
    required this.required_,
    required this.enrolled,
    required this.recoveryCodesRemaining,
  }) : super._();
  @override
  MeMfa rebuild(void Function(MeMfaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MeMfaBuilder toBuilder() => MeMfaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MeMfa &&
        required_ == other.required_ &&
        enrolled == other.enrolled &&
        recoveryCodesRemaining == other.recoveryCodesRemaining;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, required_.hashCode);
    _$hash = $jc(_$hash, enrolled.hashCode);
    _$hash = $jc(_$hash, recoveryCodesRemaining.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MeMfa')
          ..add('required_', required_)
          ..add('enrolled', enrolled)
          ..add('recoveryCodesRemaining', recoveryCodesRemaining))
        .toString();
  }
}

class MeMfaBuilder implements Builder<MeMfa, MeMfaBuilder> {
  _$MeMfa? _$v;

  bool? _required_;
  bool? get required_ => _$this._required_;
  set required_(bool? required_) => _$this._required_ = required_;

  bool? _enrolled;
  bool? get enrolled => _$this._enrolled;
  set enrolled(bool? enrolled) => _$this._enrolled = enrolled;

  int? _recoveryCodesRemaining;
  int? get recoveryCodesRemaining => _$this._recoveryCodesRemaining;
  set recoveryCodesRemaining(int? recoveryCodesRemaining) =>
      _$this._recoveryCodesRemaining = recoveryCodesRemaining;

  MeMfaBuilder() {
    MeMfa._defaults(this);
  }

  MeMfaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _required_ = $v.required_;
      _enrolled = $v.enrolled;
      _recoveryCodesRemaining = $v.recoveryCodesRemaining;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MeMfa other) {
    _$v = other as _$MeMfa;
  }

  @override
  void update(void Function(MeMfaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MeMfa build() => _build();

  _$MeMfa _build() {
    final _$result =
        _$v ??
        _$MeMfa._(
          required_: BuiltValueNullFieldError.checkNotNull(
            required_,
            r'MeMfa',
            'required_',
          ),
          enrolled: BuiltValueNullFieldError.checkNotNull(
            enrolled,
            r'MeMfa',
            'enrolled',
          ),
          recoveryCodesRemaining: BuiltValueNullFieldError.checkNotNull(
            recoveryCodesRemaining,
            r'MeMfa',
            'recoveryCodesRemaining',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
