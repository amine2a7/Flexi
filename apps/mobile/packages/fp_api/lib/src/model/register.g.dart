// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Register extends Register {
  @override
  final String id;
  @override
  final String name;
  @override
  final RegisterStatus status;
  @override
  final String publicId;
  @override
  final DateTime createdAt;

  factory _$Register([void Function(RegisterBuilder)? updates]) =>
      (RegisterBuilder()..update(updates))._build();

  _$Register._({
    required this.id,
    required this.name,
    required this.status,
    required this.publicId,
    required this.createdAt,
  }) : super._();
  @override
  Register rebuild(void Function(RegisterBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RegisterBuilder toBuilder() => RegisterBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Register &&
        id == other.id &&
        name == other.name &&
        status == other.status &&
        publicId == other.publicId &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, publicId.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Register')
          ..add('id', id)
          ..add('name', name)
          ..add('status', status)
          ..add('publicId', publicId)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class RegisterBuilder implements Builder<Register, RegisterBuilder> {
  _$Register? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  RegisterStatus? _status;
  RegisterStatus? get status => _$this._status;
  set status(RegisterStatus? status) => _$this._status = status;

  String? _publicId;
  String? get publicId => _$this._publicId;
  set publicId(String? publicId) => _$this._publicId = publicId;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  RegisterBuilder() {
    Register._defaults(this);
  }

  RegisterBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _status = $v.status;
      _publicId = $v.publicId;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Register other) {
    _$v = other as _$Register;
  }

  @override
  void update(void Function(RegisterBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Register build() => _build();

  _$Register _build() {
    final _$result =
        _$v ??
        _$Register._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'Register', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'Register',
            'name',
          ),
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'Register',
            'status',
          ),
          publicId: BuiltValueNullFieldError.checkNotNull(
            publicId,
            r'Register',
            'publicId',
          ),
          createdAt: BuiltValueNullFieldError.checkNotNull(
            createdAt,
            r'Register',
            'createdAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
