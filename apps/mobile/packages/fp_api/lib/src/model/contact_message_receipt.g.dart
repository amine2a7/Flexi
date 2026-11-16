// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_message_receipt.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ContactMessageReceipt extends ContactMessageReceipt {
  @override
  final String reference;

  factory _$ContactMessageReceipt([
    void Function(ContactMessageReceiptBuilder)? updates,
  ]) => (ContactMessageReceiptBuilder()..update(updates))._build();

  _$ContactMessageReceipt._({required this.reference}) : super._();
  @override
  ContactMessageReceipt rebuild(
    void Function(ContactMessageReceiptBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ContactMessageReceiptBuilder toBuilder() =>
      ContactMessageReceiptBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ContactMessageReceipt && reference == other.reference;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reference.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'ContactMessageReceipt',
    )..add('reference', reference)).toString();
  }
}

class ContactMessageReceiptBuilder
    implements Builder<ContactMessageReceipt, ContactMessageReceiptBuilder> {
  _$ContactMessageReceipt? _$v;

  String? _reference;
  String? get reference => _$this._reference;
  set reference(String? reference) => _$this._reference = reference;

  ContactMessageReceiptBuilder() {
    ContactMessageReceipt._defaults(this);
  }

  ContactMessageReceiptBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reference = $v.reference;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ContactMessageReceipt other) {
    _$v = other as _$ContactMessageReceipt;
  }

  @override
  void update(void Function(ContactMessageReceiptBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ContactMessageReceipt build() => _build();

  _$ContactMessageReceipt _build() {
    final _$result =
        _$v ??
        _$ContactMessageReceipt._(
          reference: BuiltValueNullFieldError.checkNotNull(
            reference,
            r'ContactMessageReceipt',
            'reference',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
