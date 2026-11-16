// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point_of_sale.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PointOfSale extends PointOfSale {
  @override
  final String id;
  @override
  final String name;
  @override
  final String city;

  factory _$PointOfSale([void Function(PointOfSaleBuilder)? updates]) =>
      (PointOfSaleBuilder()..update(updates))._build();

  _$PointOfSale._({required this.id, required this.name, required this.city})
    : super._();
  @override
  PointOfSale rebuild(void Function(PointOfSaleBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PointOfSaleBuilder toBuilder() => PointOfSaleBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PointOfSale &&
        id == other.id &&
        name == other.name &&
        city == other.city;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PointOfSale')
          ..add('id', id)
          ..add('name', name)
          ..add('city', city))
        .toString();
  }
}

class PointOfSaleBuilder implements Builder<PointOfSale, PointOfSaleBuilder> {
  _$PointOfSale? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _city;
  String? get city => _$this._city;
  set city(String? city) => _$this._city = city;

  PointOfSaleBuilder() {
    PointOfSale._defaults(this);
  }

  PointOfSaleBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _city = $v.city;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PointOfSale other) {
    _$v = other as _$PointOfSale;
  }

  @override
  void update(void Function(PointOfSaleBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PointOfSale build() => _build();

  _$PointOfSale _build() {
    final _$result =
        _$v ??
        _$PointOfSale._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'PointOfSale', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'PointOfSale',
            'name',
          ),
          city: BuiltValueNullFieldError.checkNotNull(
            city,
            r'PointOfSale',
            'city',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
