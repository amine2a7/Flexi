// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'first_validation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FirstValidation extends FirstValidation {
  @override
  final String actorName;
  @override
  final DateTime occurredAt;
  @override
  final bool byMe;

  factory _$FirstValidation([void Function(FirstValidationBuilder)? updates]) =>
      (FirstValidationBuilder()..update(updates))._build();

  _$FirstValidation._({
    required this.actorName,
    required this.occurredAt,
    required this.byMe,
  }) : super._();
  @override
  FirstValidation rebuild(void Function(FirstValidationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FirstValidationBuilder toBuilder() => FirstValidationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FirstValidation &&
        actorName == other.actorName &&
        occurredAt == other.occurredAt &&
        byMe == other.byMe;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, actorName.hashCode);
    _$hash = $jc(_$hash, occurredAt.hashCode);
    _$hash = $jc(_$hash, byMe.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FirstValidation')
          ..add('actorName', actorName)
          ..add('occurredAt', occurredAt)
          ..add('byMe', byMe))
        .toString();
  }
}

class FirstValidationBuilder
    implements Builder<FirstValidation, FirstValidationBuilder> {
  _$FirstValidation? _$v;

  String? _actorName;
  String? get actorName => _$this._actorName;
  set actorName(String? actorName) => _$this._actorName = actorName;

  DateTime? _occurredAt;
  DateTime? get occurredAt => _$this._occurredAt;
  set occurredAt(DateTime? occurredAt) => _$this._occurredAt = occurredAt;

  bool? _byMe;
  bool? get byMe => _$this._byMe;
  set byMe(bool? byMe) => _$this._byMe = byMe;

  FirstValidationBuilder() {
    FirstValidation._defaults(this);
  }

  FirstValidationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _actorName = $v.actorName;
      _occurredAt = $v.occurredAt;
      _byMe = $v.byMe;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FirstValidation other) {
    _$v = other as _$FirstValidation;
  }

  @override
  void update(void Function(FirstValidationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FirstValidation build() => _build();

  _$FirstValidation _build() {
    final _$result =
        _$v ??
        _$FirstValidation._(
          actorName: BuiltValueNullFieldError.checkNotNull(
            actorName,
            r'FirstValidation',
            'actorName',
          ),
          occurredAt: BuiltValueNullFieldError.checkNotNull(
            occurredAt,
            r'FirstValidation',
            'occurredAt',
          ),
          byMe: BuiltValueNullFieldError.checkNotNull(
            byMe,
            r'FirstValidation',
            'byMe',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
