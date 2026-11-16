// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_credit_types.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantCreditTypes extends MerchantCreditTypes {
  @override
  final BuiltSet<CreditType> acceptedCreditTypes;

  factory _$MerchantCreditTypes([
    void Function(MerchantCreditTypesBuilder)? updates,
  ]) => (MerchantCreditTypesBuilder()..update(updates))._build();

  _$MerchantCreditTypes._({required this.acceptedCreditTypes}) : super._();
  @override
  MerchantCreditTypes rebuild(
    void Function(MerchantCreditTypesBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantCreditTypesBuilder toBuilder() =>
      MerchantCreditTypesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantCreditTypes &&
        acceptedCreditTypes == other.acceptedCreditTypes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, acceptedCreditTypes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'MerchantCreditTypes',
    )..add('acceptedCreditTypes', acceptedCreditTypes)).toString();
  }
}

class MerchantCreditTypesBuilder
    implements Builder<MerchantCreditTypes, MerchantCreditTypesBuilder> {
  _$MerchantCreditTypes? _$v;

  SetBuilder<CreditType>? _acceptedCreditTypes;
  SetBuilder<CreditType> get acceptedCreditTypes =>
      _$this._acceptedCreditTypes ??= SetBuilder<CreditType>();
  set acceptedCreditTypes(SetBuilder<CreditType>? acceptedCreditTypes) =>
      _$this._acceptedCreditTypes = acceptedCreditTypes;

  MerchantCreditTypesBuilder() {
    MerchantCreditTypes._defaults(this);
  }

  MerchantCreditTypesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _acceptedCreditTypes = $v.acceptedCreditTypes.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantCreditTypes other) {
    _$v = other as _$MerchantCreditTypes;
  }

  @override
  void update(void Function(MerchantCreditTypesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantCreditTypes build() => _build();

  _$MerchantCreditTypes _build() {
    _$MerchantCreditTypes _$result;
    try {
      _$result =
          _$v ??
          _$MerchantCreditTypes._(
            acceptedCreditTypes: acceptedCreditTypes.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'acceptedCreditTypes';
        acceptedCreditTypes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantCreditTypes',
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
