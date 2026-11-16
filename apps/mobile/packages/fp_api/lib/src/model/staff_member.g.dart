// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_member.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StaffMember extends StaffMember {
  @override
  final String id;
  @override
  final String displayName;
  @override
  final SubRole subRole;

  factory _$StaffMember([void Function(StaffMemberBuilder)? updates]) =>
      (StaffMemberBuilder()..update(updates))._build();

  _$StaffMember._({
    required this.id,
    required this.displayName,
    required this.subRole,
  }) : super._();
  @override
  StaffMember rebuild(void Function(StaffMemberBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StaffMemberBuilder toBuilder() => StaffMemberBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StaffMember &&
        id == other.id &&
        displayName == other.displayName &&
        subRole == other.subRole;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, subRole.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StaffMember')
          ..add('id', id)
          ..add('displayName', displayName)
          ..add('subRole', subRole))
        .toString();
  }
}

class StaffMemberBuilder implements Builder<StaffMember, StaffMemberBuilder> {
  _$StaffMember? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  SubRole? _subRole;
  SubRole? get subRole => _$this._subRole;
  set subRole(SubRole? subRole) => _$this._subRole = subRole;

  StaffMemberBuilder() {
    StaffMember._defaults(this);
  }

  StaffMemberBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _displayName = $v.displayName;
      _subRole = $v.subRole;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StaffMember other) {
    _$v = other as _$StaffMember;
  }

  @override
  void update(void Function(StaffMemberBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StaffMember build() => _build();

  _$StaffMember _build() {
    final _$result =
        _$v ??
        _$StaffMember._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'StaffMember', 'id'),
          displayName: BuiltValueNullFieldError.checkNotNull(
            displayName,
            r'StaffMember',
            'displayName',
          ),
          subRole: BuiltValueNullFieldError.checkNotNull(
            subRole,
            r'StaffMember',
            'subRole',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
