// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_sticker.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RegisterSticker extends RegisterSticker {
  @override
  final String url;

  factory _$RegisterSticker([void Function(RegisterStickerBuilder)? updates]) =>
      (RegisterStickerBuilder()..update(updates))._build();

  _$RegisterSticker._({required this.url}) : super._();
  @override
  RegisterSticker rebuild(void Function(RegisterStickerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RegisterStickerBuilder toBuilder() => RegisterStickerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RegisterSticker && url == other.url;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'RegisterSticker',
    )..add('url', url)).toString();
  }
}

class RegisterStickerBuilder
    implements Builder<RegisterSticker, RegisterStickerBuilder> {
  _$RegisterSticker? _$v;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  RegisterStickerBuilder() {
    RegisterSticker._defaults(this);
  }

  RegisterStickerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _url = $v.url;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RegisterSticker other) {
    _$v = other as _$RegisterSticker;
  }

  @override
  void update(void Function(RegisterStickerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RegisterSticker build() => _build();

  _$RegisterSticker _build() {
    final _$result =
        _$v ??
        _$RegisterSticker._(
          url: BuiltValueNullFieldError.checkNotNull(
            url,
            r'RegisterSticker',
            'url',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
