// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TenantSummary extends TenantSummary {
  @override
  final String id;
  @override
  final String label;

  factory _$TenantSummary([void Function(TenantSummaryBuilder)? updates]) =>
      (TenantSummaryBuilder()..update(updates))._build();

  _$TenantSummary._({required this.id, required this.label}) : super._();
  @override
  TenantSummary rebuild(void Function(TenantSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TenantSummaryBuilder toBuilder() => TenantSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TenantSummary && id == other.id && label == other.label;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TenantSummary')
          ..add('id', id)
          ..add('label', label))
        .toString();
  }
}

class TenantSummaryBuilder
    implements Builder<TenantSummary, TenantSummaryBuilder> {
  _$TenantSummary? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  TenantSummaryBuilder() {
    TenantSummary._defaults(this);
  }

  TenantSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _label = $v.label;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TenantSummary other) {
    _$v = other as _$TenantSummary;
  }

  @override
  void update(void Function(TenantSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TenantSummary build() => _build();

  _$TenantSummary _build() {
    final _$result =
        _$v ??
        _$TenantSummary._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'TenantSummary', 'id'),
          label: BuiltValueNullFieldError.checkNotNull(
            label,
            r'TenantSummary',
            'label',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
