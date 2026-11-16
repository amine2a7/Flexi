// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validation_problem_all_of_details.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ValidationProblemAllOfDetails extends ValidationProblemAllOfDetails {
  @override
  final BuiltList<FieldError> fields;

  factory _$ValidationProblemAllOfDetails([
    void Function(ValidationProblemAllOfDetailsBuilder)? updates,
  ]) => (ValidationProblemAllOfDetailsBuilder()..update(updates))._build();

  _$ValidationProblemAllOfDetails._({required this.fields}) : super._();
  @override
  ValidationProblemAllOfDetails rebuild(
    void Function(ValidationProblemAllOfDetailsBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ValidationProblemAllOfDetailsBuilder toBuilder() =>
      ValidationProblemAllOfDetailsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ValidationProblemAllOfDetails && fields == other.fields;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, fields.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'ValidationProblemAllOfDetails',
    )..add('fields', fields)).toString();
  }
}

class ValidationProblemAllOfDetailsBuilder
    implements
        Builder<
          ValidationProblemAllOfDetails,
          ValidationProblemAllOfDetailsBuilder
        > {
  _$ValidationProblemAllOfDetails? _$v;

  ListBuilder<FieldError>? _fields;
  ListBuilder<FieldError> get fields =>
      _$this._fields ??= ListBuilder<FieldError>();
  set fields(ListBuilder<FieldError>? fields) => _$this._fields = fields;

  ValidationProblemAllOfDetailsBuilder() {
    ValidationProblemAllOfDetails._defaults(this);
  }

  ValidationProblemAllOfDetailsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fields = $v.fields.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ValidationProblemAllOfDetails other) {
    _$v = other as _$ValidationProblemAllOfDetails;
  }

  @override
  void update(void Function(ValidationProblemAllOfDetailsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ValidationProblemAllOfDetails build() => _build();

  _$ValidationProblemAllOfDetails _build() {
    _$ValidationProblemAllOfDetails _$result;
    try {
      _$result =
          _$v ?? _$ValidationProblemAllOfDetails._(fields: fields.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'fields';
        fields.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ValidationProblemAllOfDetails',
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
