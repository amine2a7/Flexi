// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_note_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DisputeNoteCreate extends DisputeNoteCreate {
  @override
  final String text;

  factory _$DisputeNoteCreate([
    void Function(DisputeNoteCreateBuilder)? updates,
  ]) => (DisputeNoteCreateBuilder()..update(updates))._build();

  _$DisputeNoteCreate._({required this.text}) : super._();
  @override
  DisputeNoteCreate rebuild(void Function(DisputeNoteCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeNoteCreateBuilder toBuilder() =>
      DisputeNoteCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeNoteCreate && text == other.text;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'DisputeNoteCreate',
    )..add('text', text)).toString();
  }
}

class DisputeNoteCreateBuilder
    implements Builder<DisputeNoteCreate, DisputeNoteCreateBuilder> {
  _$DisputeNoteCreate? _$v;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  DisputeNoteCreateBuilder() {
    DisputeNoteCreate._defaults(this);
  }

  DisputeNoteCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _text = $v.text;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisputeNoteCreate other) {
    _$v = other as _$DisputeNoteCreate;
  }

  @override
  void update(void Function(DisputeNoteCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeNoteCreate build() => _build();

  _$DisputeNoteCreate _build() {
    final _$result =
        _$v ??
        _$DisputeNoteCreate._(
          text: BuiltValueNullFieldError.checkNotNull(
            text,
            r'DisputeNoteCreate',
            'text',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
