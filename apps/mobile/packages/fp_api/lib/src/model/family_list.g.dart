// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_list.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FamilyList extends FamilyList {
  @override
  final bool enabled;
  @override
  final int maxMembers;
  @override
  final BuiltList<FamilyMember> data;

  factory _$FamilyList([void Function(FamilyListBuilder)? updates]) =>
      (FamilyListBuilder()..update(updates))._build();

  _$FamilyList._({
    required this.enabled,
    required this.maxMembers,
    required this.data,
  }) : super._();
  @override
  FamilyList rebuild(void Function(FamilyListBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FamilyListBuilder toBuilder() => FamilyListBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FamilyList &&
        enabled == other.enabled &&
        maxMembers == other.maxMembers &&
        data == other.data;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jc(_$hash, maxMembers.hashCode);
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FamilyList')
          ..add('enabled', enabled)
          ..add('maxMembers', maxMembers)
          ..add('data', data))
        .toString();
  }
}

class FamilyListBuilder implements Builder<FamilyList, FamilyListBuilder> {
  _$FamilyList? _$v;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(bool? enabled) => _$this._enabled = enabled;

  int? _maxMembers;
  int? get maxMembers => _$this._maxMembers;
  set maxMembers(int? maxMembers) => _$this._maxMembers = maxMembers;

  ListBuilder<FamilyMember>? _data;
  ListBuilder<FamilyMember> get data =>
      _$this._data ??= ListBuilder<FamilyMember>();
  set data(ListBuilder<FamilyMember>? data) => _$this._data = data;

  FamilyListBuilder() {
    FamilyList._defaults(this);
  }

  FamilyListBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _enabled = $v.enabled;
      _maxMembers = $v.maxMembers;
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FamilyList other) {
    _$v = other as _$FamilyList;
  }

  @override
  void update(void Function(FamilyListBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FamilyList build() => _build();

  _$FamilyList _build() {
    _$FamilyList _$result;
    try {
      _$result =
          _$v ??
          _$FamilyList._(
            enabled: BuiltValueNullFieldError.checkNotNull(
              enabled,
              r'FamilyList',
              'enabled',
            ),
            maxMembers: BuiltValueNullFieldError.checkNotNull(
              maxMembers,
              r'FamilyList',
              'maxMembers',
            ),
            data: data.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'FamilyList',
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
