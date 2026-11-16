// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field_error_params_value.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FieldErrorParamsValue extends FieldErrorParamsValue {
  @override
  final AnyOf anyOf;

  factory _$FieldErrorParamsValue([
    void Function(FieldErrorParamsValueBuilder)? updates,
  ]) => (FieldErrorParamsValueBuilder()..update(updates))._build();

  _$FieldErrorParamsValue._({required this.anyOf}) : super._();
  @override
  FieldErrorParamsValue rebuild(
    void Function(FieldErrorParamsValueBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  FieldErrorParamsValueBuilder toBuilder() =>
      FieldErrorParamsValueBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FieldErrorParamsValue && anyOf == other.anyOf;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, anyOf.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'FieldErrorParamsValue',
    )..add('anyOf', anyOf)).toString();
  }
}

class FieldErrorParamsValueBuilder
    implements Builder<FieldErrorParamsValue, FieldErrorParamsValueBuilder> {
  _$FieldErrorParamsValue? _$v;

  AnyOf? _anyOf;
  AnyOf? get anyOf => _$this._anyOf;
  set anyOf(AnyOf? anyOf) => _$this._anyOf = anyOf;

  FieldErrorParamsValueBuilder() {
    FieldErrorParamsValue._defaults(this);
  }

  FieldErrorParamsValueBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _anyOf = $v.anyOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FieldErrorParamsValue other) {
    _$v = other as _$FieldErrorParamsValue;
  }

  @override
  void update(void Function(FieldErrorParamsValueBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FieldErrorParamsValue build() => _build();

  _$FieldErrorParamsValue _build() {
    final _$result =
        _$v ??
        _$FieldErrorParamsValue._(
          anyOf: BuiltValueNullFieldError.checkNotNull(
            anyOf,
            r'FieldErrorParamsValue',
            'anyOf',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
