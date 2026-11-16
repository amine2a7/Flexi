// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pin_confirmation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PinConfirmation extends PinConfirmation {
  @override
  final String pin;

  factory _$PinConfirmation([void Function(PinConfirmationBuilder)? updates]) =>
      (PinConfirmationBuilder()..update(updates))._build();

  _$PinConfirmation._({required this.pin}) : super._();
  @override
  PinConfirmation rebuild(void Function(PinConfirmationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PinConfirmationBuilder toBuilder() => PinConfirmationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PinConfirmation && pin == other.pin;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, pin.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'PinConfirmation',
    )..add('pin', pin)).toString();
  }
}

class PinConfirmationBuilder
    implements Builder<PinConfirmation, PinConfirmationBuilder> {
  _$PinConfirmation? _$v;

  String? _pin;
  String? get pin => _$this._pin;
  set pin(String? pin) => _$this._pin = pin;

  PinConfirmationBuilder() {
    PinConfirmation._defaults(this);
  }

  PinConfirmationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _pin = $v.pin;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PinConfirmation other) {
    _$v = other as _$PinConfirmation;
  }

  @override
  void update(void Function(PinConfirmationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PinConfirmation build() => _build();

  _$PinConfirmation _build() {
    final _$result =
        _$v ??
        _$PinConfirmation._(
          pin: BuiltValueNullFieldError.checkNotNull(
            pin,
            r'PinConfirmation',
            'pin',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
