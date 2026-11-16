// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recovery_codes.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RecoveryCodes extends RecoveryCodes {
  @override
  final BuiltSet<String> recoveryCodes;

  factory _$RecoveryCodes([void Function(RecoveryCodesBuilder)? updates]) =>
      (RecoveryCodesBuilder()..update(updates))._build();

  _$RecoveryCodes._({required this.recoveryCodes}) : super._();
  @override
  RecoveryCodes rebuild(void Function(RecoveryCodesBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RecoveryCodesBuilder toBuilder() => RecoveryCodesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RecoveryCodes && recoveryCodes == other.recoveryCodes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, recoveryCodes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'RecoveryCodes',
    )..add('recoveryCodes', recoveryCodes)).toString();
  }
}

class RecoveryCodesBuilder
    implements Builder<RecoveryCodes, RecoveryCodesBuilder> {
  _$RecoveryCodes? _$v;

  SetBuilder<String>? _recoveryCodes;
  SetBuilder<String> get recoveryCodes =>
      _$this._recoveryCodes ??= SetBuilder<String>();
  set recoveryCodes(SetBuilder<String>? recoveryCodes) =>
      _$this._recoveryCodes = recoveryCodes;

  RecoveryCodesBuilder() {
    RecoveryCodes._defaults(this);
  }

  RecoveryCodesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _recoveryCodes = $v.recoveryCodes.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RecoveryCodes other) {
    _$v = other as _$RecoveryCodes;
  }

  @override
  void update(void Function(RecoveryCodesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RecoveryCodes build() => _build();

  _$RecoveryCodes _build() {
    _$RecoveryCodes _$result;
    try {
      _$result = _$v ?? _$RecoveryCodes._(recoveryCodes: recoveryCodes.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'recoveryCodes';
        recoveryCodes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'RecoveryCodes',
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
