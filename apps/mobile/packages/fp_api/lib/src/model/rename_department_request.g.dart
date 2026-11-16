// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rename_department_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RenameDepartmentRequest extends RenameDepartmentRequest {
  @override
  final String name;

  factory _$RenameDepartmentRequest([
    void Function(RenameDepartmentRequestBuilder)? updates,
  ]) => (RenameDepartmentRequestBuilder()..update(updates))._build();

  _$RenameDepartmentRequest._({required this.name}) : super._();
  @override
  RenameDepartmentRequest rebuild(
    void Function(RenameDepartmentRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  RenameDepartmentRequestBuilder toBuilder() =>
      RenameDepartmentRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RenameDepartmentRequest && name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'RenameDepartmentRequest',
    )..add('name', name)).toString();
  }
}

class RenameDepartmentRequestBuilder
    implements
        Builder<RenameDepartmentRequest, RenameDepartmentRequestBuilder> {
  _$RenameDepartmentRequest? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  RenameDepartmentRequestBuilder() {
    RenameDepartmentRequest._defaults(this);
  }

  RenameDepartmentRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RenameDepartmentRequest other) {
    _$v = other as _$RenameDepartmentRequest;
  }

  @override
  void update(void Function(RenameDepartmentRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RenameDepartmentRequest build() => _build();

  _$RenameDepartmentRequest _build() {
    final _$result =
        _$v ??
        _$RenameDepartmentRequest._(
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'RenameDepartmentRequest',
            'name',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
