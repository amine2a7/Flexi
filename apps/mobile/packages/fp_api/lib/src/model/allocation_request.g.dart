// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'allocation_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AllocationRequest extends AllocationRequest {
  @override
  final String? templateId;
  @override
  final BuiltList<AllocationLine> allocations;

  factory _$AllocationRequest([
    void Function(AllocationRequestBuilder)? updates,
  ]) => (AllocationRequestBuilder()..update(updates))._build();

  _$AllocationRequest._({this.templateId, required this.allocations})
    : super._();
  @override
  AllocationRequest rebuild(void Function(AllocationRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AllocationRequestBuilder toBuilder() =>
      AllocationRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AllocationRequest &&
        templateId == other.templateId &&
        allocations == other.allocations;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, templateId.hashCode);
    _$hash = $jc(_$hash, allocations.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AllocationRequest')
          ..add('templateId', templateId)
          ..add('allocations', allocations))
        .toString();
  }
}

class AllocationRequestBuilder
    implements Builder<AllocationRequest, AllocationRequestBuilder> {
  _$AllocationRequest? _$v;

  String? _templateId;
  String? get templateId => _$this._templateId;
  set templateId(String? templateId) => _$this._templateId = templateId;

  ListBuilder<AllocationLine>? _allocations;
  ListBuilder<AllocationLine> get allocations =>
      _$this._allocations ??= ListBuilder<AllocationLine>();
  set allocations(ListBuilder<AllocationLine>? allocations) =>
      _$this._allocations = allocations;

  AllocationRequestBuilder() {
    AllocationRequest._defaults(this);
  }

  AllocationRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _templateId = $v.templateId;
      _allocations = $v.allocations.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AllocationRequest other) {
    _$v = other as _$AllocationRequest;
  }

  @override
  void update(void Function(AllocationRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AllocationRequest build() => _build();

  _$AllocationRequest _build() {
    _$AllocationRequest _$result;
    try {
      _$result =
          _$v ??
          _$AllocationRequest._(
            templateId: templateId,
            allocations: allocations.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'allocations';
        allocations.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AllocationRequest',
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
