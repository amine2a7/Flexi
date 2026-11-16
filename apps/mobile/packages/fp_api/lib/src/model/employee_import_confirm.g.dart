// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_import_confirm.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EmployeeImportConfirm extends EmployeeImportConfirm {
  @override
  final String previewId;

  factory _$EmployeeImportConfirm([
    void Function(EmployeeImportConfirmBuilder)? updates,
  ]) => (EmployeeImportConfirmBuilder()..update(updates))._build();

  _$EmployeeImportConfirm._({required this.previewId}) : super._();
  @override
  EmployeeImportConfirm rebuild(
    void Function(EmployeeImportConfirmBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  EmployeeImportConfirmBuilder toBuilder() =>
      EmployeeImportConfirmBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmployeeImportConfirm && previewId == other.previewId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, previewId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'EmployeeImportConfirm',
    )..add('previewId', previewId)).toString();
  }
}

class EmployeeImportConfirmBuilder
    implements Builder<EmployeeImportConfirm, EmployeeImportConfirmBuilder> {
  _$EmployeeImportConfirm? _$v;

  String? _previewId;
  String? get previewId => _$this._previewId;
  set previewId(String? previewId) => _$this._previewId = previewId;

  EmployeeImportConfirmBuilder() {
    EmployeeImportConfirm._defaults(this);
  }

  EmployeeImportConfirmBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _previewId = $v.previewId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EmployeeImportConfirm other) {
    _$v = other as _$EmployeeImportConfirm;
  }

  @override
  void update(void Function(EmployeeImportConfirmBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmployeeImportConfirm build() => _build();

  _$EmployeeImportConfirm _build() {
    final _$result =
        _$v ??
        _$EmployeeImportConfirm._(
          previewId: BuiltValueNullFieldError.checkNotNull(
            previewId,
            r'EmployeeImportConfirm',
            'previewId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
