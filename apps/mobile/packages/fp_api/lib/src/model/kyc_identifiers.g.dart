// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kyc_identifiers.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$KycIdentifiers extends KycIdentifiers {
  @override
  final String? nationalId;
  @override
  final String? taxId;
  @override
  final String? iban;

  factory _$KycIdentifiers([void Function(KycIdentifiersBuilder)? updates]) =>
      (KycIdentifiersBuilder()..update(updates))._build();

  _$KycIdentifiers._({this.nationalId, this.taxId, this.iban}) : super._();
  @override
  KycIdentifiers rebuild(void Function(KycIdentifiersBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  KycIdentifiersBuilder toBuilder() => KycIdentifiersBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is KycIdentifiers &&
        nationalId == other.nationalId &&
        taxId == other.taxId &&
        iban == other.iban;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, nationalId.hashCode);
    _$hash = $jc(_$hash, taxId.hashCode);
    _$hash = $jc(_$hash, iban.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'KycIdentifiers')
          ..add('nationalId', nationalId)
          ..add('taxId', taxId)
          ..add('iban', iban))
        .toString();
  }
}

class KycIdentifiersBuilder
    implements Builder<KycIdentifiers, KycIdentifiersBuilder> {
  _$KycIdentifiers? _$v;

  String? _nationalId;
  String? get nationalId => _$this._nationalId;
  set nationalId(String? nationalId) => _$this._nationalId = nationalId;

  String? _taxId;
  String? get taxId => _$this._taxId;
  set taxId(String? taxId) => _$this._taxId = taxId;

  String? _iban;
  String? get iban => _$this._iban;
  set iban(String? iban) => _$this._iban = iban;

  KycIdentifiersBuilder() {
    KycIdentifiers._defaults(this);
  }

  KycIdentifiersBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _nationalId = $v.nationalId;
      _taxId = $v.taxId;
      _iban = $v.iban;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(KycIdentifiers other) {
    _$v = other as _$KycIdentifiers;
  }

  @override
  void update(void Function(KycIdentifiersBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  KycIdentifiers build() => _build();

  _$KycIdentifiers _build() {
    final _$result =
        _$v ??
        _$KycIdentifiers._(nationalId: nationalId, taxId: taxId, iban: iban);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
