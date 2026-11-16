// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_count.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PageCount extends PageCount {
  @override
  final int value;
  @override
  final bool isLowerBound;

  factory _$PageCount([void Function(PageCountBuilder)? updates]) =>
      (PageCountBuilder()..update(updates))._build();

  _$PageCount._({required this.value, required this.isLowerBound}) : super._();
  @override
  PageCount rebuild(void Function(PageCountBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PageCountBuilder toBuilder() => PageCountBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PageCount &&
        value == other.value &&
        isLowerBound == other.isLowerBound;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jc(_$hash, isLowerBound.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PageCount')
          ..add('value', value)
          ..add('isLowerBound', isLowerBound))
        .toString();
  }
}

class PageCountBuilder implements Builder<PageCount, PageCountBuilder> {
  _$PageCount? _$v;

  int? _value;
  int? get value => _$this._value;
  set value(int? value) => _$this._value = value;

  bool? _isLowerBound;
  bool? get isLowerBound => _$this._isLowerBound;
  set isLowerBound(bool? isLowerBound) => _$this._isLowerBound = isLowerBound;

  PageCountBuilder() {
    PageCount._defaults(this);
  }

  PageCountBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _value = $v.value;
      _isLowerBound = $v.isLowerBound;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PageCount other) {
    _$v = other as _$PageCount;
  }

  @override
  void update(void Function(PageCountBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PageCount build() => _build();

  _$PageCount _build() {
    final _$result =
        _$v ??
        _$PageCount._(
          value: BuiltValueNullFieldError.checkNotNull(
            value,
            r'PageCount',
            'value',
          ),
          isLowerBound: BuiltValueNullFieldError.checkNotNull(
            isLowerBound,
            r'PageCount',
            'isLowerBound',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
