// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_order_quote_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreditOrderQuoteRequest extends CreditOrderQuoteRequest {
  @override
  final BuiltList<CreditOrderLine> lines;

  factory _$CreditOrderQuoteRequest([
    void Function(CreditOrderQuoteRequestBuilder)? updates,
  ]) => (CreditOrderQuoteRequestBuilder()..update(updates))._build();

  _$CreditOrderQuoteRequest._({required this.lines}) : super._();
  @override
  CreditOrderQuoteRequest rebuild(
    void Function(CreditOrderQuoteRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CreditOrderQuoteRequestBuilder toBuilder() =>
      CreditOrderQuoteRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreditOrderQuoteRequest && lines == other.lines;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'CreditOrderQuoteRequest',
    )..add('lines', lines)).toString();
  }
}

class CreditOrderQuoteRequestBuilder
    implements
        Builder<CreditOrderQuoteRequest, CreditOrderQuoteRequestBuilder> {
  _$CreditOrderQuoteRequest? _$v;

  ListBuilder<CreditOrderLine>? _lines;
  ListBuilder<CreditOrderLine> get lines =>
      _$this._lines ??= ListBuilder<CreditOrderLine>();
  set lines(ListBuilder<CreditOrderLine>? lines) => _$this._lines = lines;

  CreditOrderQuoteRequestBuilder() {
    CreditOrderQuoteRequest._defaults(this);
  }

  CreditOrderQuoteRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lines = $v.lines.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreditOrderQuoteRequest other) {
    _$v = other as _$CreditOrderQuoteRequest;
  }

  @override
  void update(void Function(CreditOrderQuoteRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreditOrderQuoteRequest build() => _build();

  _$CreditOrderQuoteRequest _build() {
    _$CreditOrderQuoteRequest _$result;
    try {
      _$result = _$v ?? _$CreditOrderQuoteRequest._(lines: lines.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lines';
        lines.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CreditOrderQuoteRequest',
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
