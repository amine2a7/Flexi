// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_member_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FamilyMemberCreate extends FamilyMemberCreate {
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final FamilyRelationship relationship;
  @override
  final String phone;

  factory _$FamilyMemberCreate([
    void Function(FamilyMemberCreateBuilder)? updates,
  ]) => (FamilyMemberCreateBuilder()..update(updates))._build();

  _$FamilyMemberCreate._({
    required this.firstName,
    required this.lastName,
    required this.relationship,
    required this.phone,
  }) : super._();
  @override
  FamilyMemberCreate rebuild(
    void Function(FamilyMemberCreateBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  FamilyMemberCreateBuilder toBuilder() =>
      FamilyMemberCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FamilyMemberCreate &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        relationship == other.relationship &&
        phone == other.phone;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, firstName.hashCode);
    _$hash = $jc(_$hash, lastName.hashCode);
    _$hash = $jc(_$hash, relationship.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FamilyMemberCreate')
          ..add('firstName', firstName)
          ..add('lastName', lastName)
          ..add('relationship', relationship)
          ..add('phone', phone))
        .toString();
  }
}

class FamilyMemberCreateBuilder
    implements Builder<FamilyMemberCreate, FamilyMemberCreateBuilder> {
  _$FamilyMemberCreate? _$v;

  String? _firstName;
  String? get firstName => _$this._firstName;
  set firstName(String? firstName) => _$this._firstName = firstName;

  String? _lastName;
  String? get lastName => _$this._lastName;
  set lastName(String? lastName) => _$this._lastName = lastName;

  FamilyRelationship? _relationship;
  FamilyRelationship? get relationship => _$this._relationship;
  set relationship(FamilyRelationship? relationship) =>
      _$this._relationship = relationship;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  FamilyMemberCreateBuilder() {
    FamilyMemberCreate._defaults(this);
  }

  FamilyMemberCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _firstName = $v.firstName;
      _lastName = $v.lastName;
      _relationship = $v.relationship;
      _phone = $v.phone;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FamilyMemberCreate other) {
    _$v = other as _$FamilyMemberCreate;
  }

  @override
  void update(void Function(FamilyMemberCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FamilyMemberCreate build() => _build();

  _$FamilyMemberCreate _build() {
    final _$result =
        _$v ??
        _$FamilyMemberCreate._(
          firstName: BuiltValueNullFieldError.checkNotNull(
            firstName,
            r'FamilyMemberCreate',
            'firstName',
          ),
          lastName: BuiltValueNullFieldError.checkNotNull(
            lastName,
            r'FamilyMemberCreate',
            'lastName',
          ),
          relationship: BuiltValueNullFieldError.checkNotNull(
            relationship,
            r'FamilyMemberCreate',
            'relationship',
          ),
          phone: BuiltValueNullFieldError.checkNotNull(
            phone,
            r'FamilyMemberCreate',
            'phone',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
