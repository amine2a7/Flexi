// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PaginatedEnvelope extends PaginatedEnvelope {
  @override
  final BuiltList<JsonObject?> data;
  @override
  final PageInfo page;

  factory _$PaginatedEnvelope([
    void Function(PaginatedEnvelopeBuilder)? updates,
  ]) => (PaginatedEnvelopeBuilder()..update(updates))._build();

  _$PaginatedEnvelope._({required this.data, required this.page}) : super._();
  @override
  PaginatedEnvelope rebuild(void Function(PaginatedEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaginatedEnvelopeBuilder toBuilder() =>
      PaginatedEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaginatedEnvelope &&
        data == other.data &&
        page == other.page;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jc(_$hash, page.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaginatedEnvelope')
          ..add('data', data)
          ..add('page', page))
        .toString();
  }
}

class PaginatedEnvelopeBuilder
    implements Builder<PaginatedEnvelope, PaginatedEnvelopeBuilder> {
  _$PaginatedEnvelope? _$v;

  ListBuilder<JsonObject?>? _data;
  ListBuilder<JsonObject?> get data =>
      _$this._data ??= ListBuilder<JsonObject?>();
  set data(ListBuilder<JsonObject?>? data) => _$this._data = data;

  PageInfoBuilder? _page;
  PageInfoBuilder get page => _$this._page ??= PageInfoBuilder();
  set page(PageInfoBuilder? page) => _$this._page = page;

  PaginatedEnvelopeBuilder() {
    PaginatedEnvelope._defaults(this);
  }

  PaginatedEnvelopeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _page = $v.page.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaginatedEnvelope other) {
    _$v = other as _$PaginatedEnvelope;
  }

  @override
  void update(void Function(PaginatedEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaginatedEnvelope build() => _build();

  _$PaginatedEnvelope _build() {
    _$PaginatedEnvelope _$result;
    try {
      _$result =
          _$v ?? _$PaginatedEnvelope._(data: data.build(), page: page.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
        _$failedField = 'page';
        page.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'PaginatedEnvelope',
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
