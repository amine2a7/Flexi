// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'allocation_preview_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AllocationPreviewRequest extends AllocationPreviewRequest {
  @override
  final String? templateId;
  @override
  final String? departmentId;
  @override
  final String? position;
  @override
  final String? q;
  @override
  final BuiltList<String>? employeeIds;
  @override
  final BuiltList<AllocationTypeAmount> amounts;

  factory _$AllocationPreviewRequest([
    void Function(AllocationPreviewRequestBuilder)? updates,
  ]) => (AllocationPreviewRequestBuilder()..update(updates))._build();

  _$AllocationPreviewRequest._({
    this.templateId,
    this.departmentId,
    this.position,
    this.q,
    this.employeeIds,
    required this.amounts,
  }) : super._();
  @override
  AllocationPreviewRequest rebuild(
    void Function(AllocationPreviewRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AllocationPreviewRequestBuilder toBuilder() =>
      AllocationPreviewRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AllocationPreviewRequest &&
        templateId == other.templateId &&
        departmentId == other.departmentId &&
        position == other.position &&
        q == other.q &&
        employeeIds == other.employeeIds &&
        amounts == other.amounts;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, templateId.hashCode);
    _$hash = $jc(_$hash, departmentId.hashCode);
    _$hash = $jc(_$hash, position.hashCode);
    _$hash = $jc(_$hash, q.hashCode);
    _$hash = $jc(_$hash, employeeIds.hashCode);
    _$hash = $jc(_$hash, amounts.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AllocationPreviewRequest')
          ..add('templateId', templateId)
          ..add('departmentId', departmentId)
          ..add('position', position)
          ..add('q', q)
          ..add('employeeIds', employeeIds)
          ..add('amounts', amounts))
        .toString();
  }
}

class AllocationPreviewRequestBuilder
    implements
        Builder<AllocationPreviewRequest, AllocationPreviewRequestBuilder> {
  _$AllocationPreviewRequest? _$v;

  String? _templateId;
  String? get templateId => _$this._templateId;
  set templateId(String? templateId) => _$this._templateId = templateId;

  String? _departmentId;
  String? get departmentId => _$this._departmentId;
  set departmentId(String? departmentId) => _$this._departmentId = departmentId;

  String? _position;
  String? get position => _$this._position;
  set position(String? position) => _$this._position = position;

  String? _q;
  String? get q => _$this._q;
  set q(String? q) => _$this._q = q;

  ListBuilder<String>? _employeeIds;
  ListBuilder<String> get employeeIds =>
      _$this._employeeIds ??= ListBuilder<String>();
  set employeeIds(ListBuilder<String>? employeeIds) =>
      _$this._employeeIds = employeeIds;

  ListBuilder<AllocationTypeAmount>? _amounts;
  ListBuilder<AllocationTypeAmount> get amounts =>
      _$this._amounts ??= ListBuilder<AllocationTypeAmount>();
  set amounts(ListBuilder<AllocationTypeAmount>? amounts) =>
      _$this._amounts = amounts;

  AllocationPreviewRequestBuilder() {
    AllocationPreviewRequest._defaults(this);
  }

  AllocationPreviewRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _templateId = $v.templateId;
      _departmentId = $v.departmentId;
      _position = $v.position;
      _q = $v.q;
      _employeeIds = $v.employeeIds?.toBuilder();
      _amounts = $v.amounts.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AllocationPreviewRequest other) {
    _$v = other as _$AllocationPreviewRequest;
  }

  @override
  void update(void Function(AllocationPreviewRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AllocationPreviewRequest build() => _build();

  _$AllocationPreviewRequest _build() {
    _$AllocationPreviewRequest _$result;
    try {
      _$result =
          _$v ??
          _$AllocationPreviewRequest._(
            templateId: templateId,
            departmentId: departmentId,
            position: position,
            q: q,
            employeeIds: _employeeIds?.build(),
            amounts: amounts.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'employeeIds';
        _employeeIds?.build();
        _$failedField = 'amounts';
        amounts.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AllocationPreviewRequest',
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
