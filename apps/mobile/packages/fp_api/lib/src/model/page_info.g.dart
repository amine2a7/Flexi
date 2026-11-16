// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_info.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PageInfo extends PageInfo {
  @override
  final int limit;
  @override
  final bool hasMore;
  @override
  final String? nextCursor;
  @override
  final PageCount? count;

  factory _$PageInfo([void Function(PageInfoBuilder)? updates]) =>
      (PageInfoBuilder()..update(updates))._build();

  _$PageInfo._({
    required this.limit,
    required this.hasMore,
    this.nextCursor,
    this.count,
  }) : super._();
  @override
  PageInfo rebuild(void Function(PageInfoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PageInfoBuilder toBuilder() => PageInfoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PageInfo &&
        limit == other.limit &&
        hasMore == other.hasMore &&
        nextCursor == other.nextCursor &&
        count == other.count;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, limit.hashCode);
    _$hash = $jc(_$hash, hasMore.hashCode);
    _$hash = $jc(_$hash, nextCursor.hashCode);
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PageInfo')
          ..add('limit', limit)
          ..add('hasMore', hasMore)
          ..add('nextCursor', nextCursor)
          ..add('count', count))
        .toString();
  }
}

class PageInfoBuilder implements Builder<PageInfo, PageInfoBuilder> {
  _$PageInfo? _$v;

  int? _limit;
  int? get limit => _$this._limit;
  set limit(int? limit) => _$this._limit = limit;

  bool? _hasMore;
  bool? get hasMore => _$this._hasMore;
  set hasMore(bool? hasMore) => _$this._hasMore = hasMore;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  PageCountBuilder? _count;
  PageCountBuilder get count => _$this._count ??= PageCountBuilder();
  set count(PageCountBuilder? count) => _$this._count = count;

  PageInfoBuilder() {
    PageInfo._defaults(this);
  }

  PageInfoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _limit = $v.limit;
      _hasMore = $v.hasMore;
      _nextCursor = $v.nextCursor;
      _count = $v.count?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PageInfo other) {
    _$v = other as _$PageInfo;
  }

  @override
  void update(void Function(PageInfoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PageInfo build() => _build();

  _$PageInfo _build() {
    _$PageInfo _$result;
    try {
      _$result =
          _$v ??
          _$PageInfo._(
            limit: BuiltValueNullFieldError.checkNotNull(
              limit,
              r'PageInfo',
              'limit',
            ),
            hasMore: BuiltValueNullFieldError.checkNotNull(
              hasMore,
              r'PageInfo',
              'hasMore',
            ),
            nextCursor: nextCursor,
            count: _count?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'count';
        _count?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'PageInfo',
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
