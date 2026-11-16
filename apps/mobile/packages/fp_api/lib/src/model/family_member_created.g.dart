// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_member_created.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FamilyMemberCreated extends FamilyMemberCreated {
  @override
  final String id;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final FamilyRelationship relationship;
  @override
  final TemporaryCredentials credentials;

  factory _$FamilyMemberCreated([
    void Function(FamilyMemberCreatedBuilder)? updates,
  ]) => (FamilyMemberCreatedBuilder()..update(updates))._build();

  _$FamilyMemberCreated._({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.relationship,
    required this.credentials,
  }) : super._();
  @override
  FamilyMemberCreated rebuild(
    void Function(FamilyMemberCreatedBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  FamilyMemberCreatedBuilder toBuilder() =>
      FamilyMemberCreatedBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FamilyMemberCreated &&
        id == other.id &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        relationship == other.relationship &&
        credentials == other.credentials;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, firstName.hashCode);
    _$hash = $jc(_$hash, lastName.hashCode);
    _$hash = $jc(_$hash, relationship.hashCode);
    _$hash = $jc(_$hash, credentials.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FamilyMemberCreated')
          ..add('id', id)
          ..add('firstName', firstName)
          ..add('lastName', lastName)
          ..add('relationship', relationship)
          ..add('credentials', credentials))
        .toString();
  }
}

class FamilyMemberCreatedBuilder
    implements Builder<FamilyMemberCreated, FamilyMemberCreatedBuilder> {
  _$FamilyMemberCreated? _$v;

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

  TemporaryCredentialsBuilder? _credentials;
  TemporaryCredentialsBuilder get credentials =>
      _$this._credentials ??= TemporaryCredentialsBuilder();
  set credentials(TemporaryCredentialsBuilder? credentials) =>
      _$this._credentials = credentials;

  FamilyMemberCreatedBuilder() {
    FamilyMemberCreated._defaults(this);
  }

  FamilyMemberCreatedBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _firstName = $v.firstName;
      _lastName = $v.lastName;
      _relationship = $v.relationship;
      _credentials = $v.credentials.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FamilyMemberCreated other) {
    _$v = other as _$FamilyMemberCreated;
  }

  @override
  void update(void Function(FamilyMemberCreatedBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FamilyMemberCreated build() => _build();

  _$FamilyMemberCreated _build() {
    _$FamilyMemberCreated _$result;
    try {
      _$result =
          _$v ??
          _$FamilyMemberCreated._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'FamilyMemberCreated',
              'id',
            ),
            firstName: BuiltValueNullFieldError.checkNotNull(
              firstName,
              r'FamilyMemberCreated',
              'firstName',
            ),
            lastName: BuiltValueNullFieldError.checkNotNull(
              lastName,
              r'FamilyMemberCreated',
              'lastName',
            ),
            relationship: BuiltValueNullFieldError.checkNotNull(
              relationship,
              r'FamilyMemberCreated',
              'relationship',
            ),
            credentials: credentials.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'credentials';
        credentials.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'FamilyMemberCreated',
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
