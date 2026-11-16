// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_member.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FamilyMember extends FamilyMember {
  @override
  final String id;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final FamilyRelationship relationship;
  @override
  final String? login;
  @override
  final EmployeeStatus status;
  @override
  final BuiltList<FamilyMemberBalance> balances;

  factory _$FamilyMember([void Function(FamilyMemberBuilder)? updates]) =>
      (FamilyMemberBuilder()..update(updates))._build();

  _$FamilyMember._({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.relationship,
    this.login,
    required this.status,
    required this.balances,
  }) : super._();
  @override
  FamilyMember rebuild(void Function(FamilyMemberBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FamilyMemberBuilder toBuilder() => FamilyMemberBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FamilyMember &&
        id == other.id &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        relationship == other.relationship &&
        login == other.login &&
        status == other.status &&
        balances == other.balances;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, firstName.hashCode);
    _$hash = $jc(_$hash, lastName.hashCode);
    _$hash = $jc(_$hash, relationship.hashCode);
    _$hash = $jc(_$hash, login.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, balances.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FamilyMember')
          ..add('id', id)
          ..add('firstName', firstName)
          ..add('lastName', lastName)
          ..add('relationship', relationship)
          ..add('login', login)
          ..add('status', status)
          ..add('balances', balances))
        .toString();
  }
}

class FamilyMemberBuilder
    implements Builder<FamilyMember, FamilyMemberBuilder> {
  _$FamilyMember? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

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

  String? _login;
  String? get login => _$this._login;
  set login(String? login) => _$this._login = login;

  EmployeeStatus? _status;
  EmployeeStatus? get status => _$this._status;
  set status(EmployeeStatus? status) => _$this._status = status;

  ListBuilder<FamilyMemberBalance>? _balances;
  ListBuilder<FamilyMemberBalance> get balances =>
      _$this._balances ??= ListBuilder<FamilyMemberBalance>();
  set balances(ListBuilder<FamilyMemberBalance>? balances) =>
      _$this._balances = balances;

  FamilyMemberBuilder() {
    FamilyMember._defaults(this);
  }

  FamilyMemberBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _firstName = $v.firstName;
      _lastName = $v.lastName;
      _relationship = $v.relationship;
      _login = $v.login;
      _status = $v.status;
      _balances = $v.balances.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FamilyMember other) {
    _$v = other as _$FamilyMember;
  }

  @override
  void update(void Function(FamilyMemberBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FamilyMember build() => _build();

  _$FamilyMember _build() {
    _$FamilyMember _$result;
    try {
      _$result =
          _$v ??
          _$FamilyMember._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'FamilyMember',
              'id',
            ),
            firstName: BuiltValueNullFieldError.checkNotNull(
              firstName,
              r'FamilyMember',
              'firstName',
            ),
            lastName: BuiltValueNullFieldError.checkNotNull(
              lastName,
              r'FamilyMember',
              'lastName',
            ),
            relationship: BuiltValueNullFieldError.checkNotNull(
              relationship,
              r'FamilyMember',
              'relationship',
            ),
            login: login,
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'FamilyMember',
              'status',
            ),
            balances: balances.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'balances';
        balances.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'FamilyMember',
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
