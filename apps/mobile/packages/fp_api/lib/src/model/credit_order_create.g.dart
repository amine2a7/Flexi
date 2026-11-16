// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_order_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreditOrderCreate extends CreditOrderCreate {
  @override
  final String? quoteId;
  @override
  final BuiltList<CreditOrderLine>? lines;

  factory _$CreditOrderCreate([
    void Function(CreditOrderCreateBuilder)? updates,
  ]) => (CreditOrderCreateBuilder()..update(updates))._build();

  _$CreditOrderCreate._({this.quoteId, this.lines}) : super._();
  @override
  CreditOrderCreate rebuild(void Function(CreditOrderCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreditOrderCreateBuilder toBuilder() =>
      CreditOrderCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreditOrderCreate &&
        quoteId == other.quoteId &&
        lines == other.lines;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, quoteId.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreditOrderCreate')
          ..add('quoteId', quoteId)
          ..add('lines', lines))
        .toString();
  }
}

class CreditOrderCreateBuilder
    implements Builder<CreditOrderCreate, CreditOrderCreateBuilder> {
  _$CreditOrderCreate? _$v;

  String? _quoteId;
  String? get quoteId => _$this._quoteId;
  set quoteId(String? quoteId) => _$this._quoteId = quoteId;

  ListBuilder<CreditOrderLine>? _lines;
  ListBuilder<CreditOrderLine> get lines =>
      _$this._lines ??= ListBuilder<CreditOrderLine>();
  set lines(ListBuilder<CreditOrderLine>? lines) => _$this._lines = lines;

  CreditOrderCreateBuilder() {
    CreditOrderCreate._defaults(this);
  }

  CreditOrderCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _quoteId = $v.quoteId;
      _lines = $v.lines?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreditOrderCreate other) {
    _$v = other as _$CreditOrderCreate;
  }

  @override
  void update(void Function(CreditOrderCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreditOrderCreate build() => _build();

  _$CreditOrderCreate _build() {
    _$CreditOrderCreate _$result;
    try {
      _$result =
          _$v ??
          _$CreditOrderCreate._(quoteId: quoteId, lines: _lines?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lines';
        _lines?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CreditOrderCreate',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
