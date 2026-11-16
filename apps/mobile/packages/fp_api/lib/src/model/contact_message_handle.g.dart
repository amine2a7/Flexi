// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_message_handle.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ContactMessageHandle extends ContactMessageHandle {
  @override
  final String? note;

  factory _$ContactMessageHandle([
    void Function(ContactMessageHandleBuilder)? updates,
  ]) => (ContactMessageHandleBuilder()..update(updates))._build();

  _$ContactMessageHandle._({this.note}) : super._();
  @override
  ContactMessageHandle rebuild(
    void Function(ContactMessageHandleBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ContactMessageHandleBuilder toBuilder() =>
      ContactMessageHandleBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ContactMessageHandle && note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'ContactMessageHandle',
    )..add('note', note)).toString();
  }
}

class ContactMessageHandleBuilder
    implements Builder<ContactMessageHandle, ContactMessageHandleBuilder> {
  _$ContactMessageHandle? _$v;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  ContactMessageHandleBuilder() {
    ContactMessageHandle._defaults(this);
  }

  ContactMessageHandleBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ContactMessageHandle other) {
    _$v = other as _$ContactMessageHandle;
  }

  @override
  void update(void Function(ContactMessageHandleBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ContactMessageHandle build() => _build();

  _$ContactMessageHandle _build() {
    final _$result = _$v ?? _$ContactMessageHandle._(note: note);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
