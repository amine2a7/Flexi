// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pin_change.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PinChange extends PinChange {
  @override
  final String? currentPin;
  @override
  final String newPin;

  factory _$PinChange([void Function(PinChangeBuilder)? updates]) =>
      (PinChangeBuilder()..update(updates))._build();

  _$PinChange._({this.currentPin, required this.newPin}) : super._();
  @override
  PinChange rebuild(void Function(PinChangeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PinChangeBuilder toBuilder() => PinChangeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PinChange &&
        currentPin == other.currentPin &&
        newPin == other.newPin;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currentPin.hashCode);
    _$hash = $jc(_$hash, newPin.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PinChange')
          ..add('currentPin', currentPin)
          ..add('newPin', newPin))
        .toString();
  }
}

class PinChangeBuilder implements Builder<PinChange, PinChangeBuilder> {
  _$PinChange? _$v;

  String? _currentPin;
  String? get currentPin => _$this._currentPin;
  set currentPin(String? currentPin) => _$this._currentPin = currentPin;

  String? _newPin;
  String? get newPin => _$this._newPin;
  set newPin(String? newPin) => _$this._newPin = newPin;

  PinChangeBuilder() {
    PinChange._defaults(this);
  }

  PinChangeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currentPin = $v.currentPin;
      _newPin = $v.newPin;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PinChange other) {
    _$v = other as _$PinChange;
  }

  @override
  void update(void Function(PinChangeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PinChange build() => _build();

  _$PinChange _build() {
    final _$result =
        _$v ??
        _$PinChange._(
          currentPin: currentPin,
          newPin: BuiltValueNullFieldError.checkNotNull(
            newPin,
            r'PinChange',
            'newPin',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
