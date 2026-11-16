// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'approval_legal_form_change.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApprovalLegalFormChange extends ApprovalLegalFormChange {
  @override
  final LegalForm previous;
  @override
  final LegalForm proposed;

  factory _$ApprovalLegalFormChange([
    void Function(ApprovalLegalFormChangeBuilder)? updates,
  ]) => (ApprovalLegalFormChangeBuilder()..update(updates))._build();

  _$ApprovalLegalFormChange._({required this.previous, required this.proposed})
    : super._();
  @override
  ApprovalLegalFormChange rebuild(
    void Function(ApprovalLegalFormChangeBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApprovalLegalFormChangeBuilder toBuilder() =>
      ApprovalLegalFormChangeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApprovalLegalFormChange &&
        previous == other.previous &&
        proposed == other.proposed;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, previous.hashCode);
    _$hash = $jc(_$hash, proposed.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApprovalLegalFormChange')
          ..add('previous', previous)
          ..add('proposed', proposed))
        .toString();
  }
}

class ApprovalLegalFormChangeBuilder
    implements
        Builder<ApprovalLegalFormChange, ApprovalLegalFormChangeBuilder> {
  _$ApprovalLegalFormChange? _$v;

  LegalForm? _previous;
  LegalForm? get previous => _$this._previous;
  set previous(LegalForm? previous) => _$this._previous = previous;

  LegalForm? _proposed;
  LegalForm? get proposed => _$this._proposed;
  set proposed(LegalForm? proposed) => _$this._proposed = proposed;

  ApprovalLegalFormChangeBuilder() {
    ApprovalLegalFormChange._defaults(this);
  }

  ApprovalLegalFormChangeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _previous = $v.previous;
      _proposed = $v.proposed;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApprovalLegalFormChange other) {
    _$v = other as _$ApprovalLegalFormChange;
  }

  @override
  void update(void Function(ApprovalLegalFormChangeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApprovalLegalFormChange build() => _build();

  _$ApprovalLegalFormChange _build() {
    final _$result =
        _$v ??
        _$ApprovalLegalFormChange._(
          previous: BuiltValueNullFieldError.checkNotNull(
            previous,
            r'ApprovalLegalFormChange',
            'previous',
          ),
          proposed: BuiltValueNullFieldError.checkNotNull(
            proposed,
            r'ApprovalLegalFormChange',
            'proposed',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
