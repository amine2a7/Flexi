// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_note.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DisputeNote extends DisputeNote {
  @override
  final String id;
  @override
  final String authorName;
  @override
  final String text;
  @override
  final DateTime createdAt;

  factory _$DisputeNote([void Function(DisputeNoteBuilder)? updates]) =>
      (DisputeNoteBuilder()..update(updates))._build();

  _$DisputeNote._({
    required this.id,
    required this.authorName,
    required this.text,
    required this.createdAt,
  }) : super._();
  @override
  DisputeNote rebuild(void Function(DisputeNoteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeNoteBuilder toBuilder() => DisputeNoteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeNote &&
        id == other.id &&
        authorName == other.authorName &&
        text == other.text &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, authorName.hashCode);
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DisputeNote')
          ..add('id', id)
          ..add('authorName', authorName)
          ..add('text', text)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class DisputeNoteBuilder implements Builder<DisputeNote, DisputeNoteBuilder> {
  _$DisputeNote? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _authorName;
  String? get authorName => _$this._authorName;
  set authorName(String? authorName) => _$this._authorName = authorName;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DisputeNoteBuilder() {
    DisputeNote._defaults(this);
  }

  DisputeNoteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _authorName = $v.authorName;
      _text = $v.text;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisputeNote other) {
    _$v = other as _$DisputeNote;
  }

  @override
  void update(void Function(DisputeNoteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeNote build() => _build();

  _$DisputeNote _build() {
    final _$result =
        _$v ??
        _$DisputeNote._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'DisputeNote', 'id'),
          authorName: BuiltValueNullFieldError.checkNotNull(
            authorName,
            r'DisputeNote',
            'authorName',
          ),
          text: BuiltValueNullFieldError.checkNotNull(
            text,
            r'DisputeNote',
            'text',
          ),
          createdAt: BuiltValueNullFieldError.checkNotNull(
            createdAt,
            r'DisputeNote',
            'createdAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
