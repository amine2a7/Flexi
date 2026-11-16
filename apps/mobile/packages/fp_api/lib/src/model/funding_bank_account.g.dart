// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'funding_bank_account.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FundingBankAccount extends FundingBankAccount {
  @override
  final String bankName;
  @override
  final String holder;
  @override
  final String rib;
  @override
  final String iban;

  factory _$FundingBankAccount([
    void Function(FundingBankAccountBuilder)? updates,
  ]) => (FundingBankAccountBuilder()..update(updates))._build();

  _$FundingBankAccount._({
    required this.bankName,
    required this.holder,
    required this.rib,
    required this.iban,
  }) : super._();
  @override
  FundingBankAccount rebuild(
    void Function(FundingBankAccountBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  FundingBankAccountBuilder toBuilder() =>
      FundingBankAccountBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FundingBankAccount &&
        bankName == other.bankName &&
        holder == other.holder &&
        rib == other.rib &&
        iban == other.iban;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, bankName.hashCode);
    _$hash = $jc(_$hash, holder.hashCode);
    _$hash = $jc(_$hash, rib.hashCode);
    _$hash = $jc(_$hash, iban.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FundingBankAccount')
          ..add('bankName', bankName)
          ..add('holder', holder)
          ..add('rib', rib)
          ..add('iban', iban))
        .toString();
  }
}

class FundingBankAccountBuilder
    implements Builder<FundingBankAccount, FundingBankAccountBuilder> {
  _$FundingBankAccount? _$v;

  String? _bankName;
  String? get bankName => _$this._bankName;
  set bankName(String? bankName) => _$this._bankName = bankName;

  String? _holder;
  String? get holder => _$this._holder;
  set holder(String? holder) => _$this._holder = holder;

  String? _rib;
  String? get rib => _$this._rib;
  set rib(String? rib) => _$this._rib = rib;

  String? _iban;
  String? get iban => _$this._iban;
  set iban(String? iban) => _$this._iban = iban;

  FundingBankAccountBuilder() {
    FundingBankAccount._defaults(this);
  }

  FundingBankAccountBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _bankName = $v.bankName;
      _holder = $v.holder;
      _rib = $v.rib;
      _iban = $v.iban;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FundingBankAccount other) {
    _$v = other as _$FundingBankAccount;
  }

  @override
  void update(void Function(FundingBankAccountBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FundingBankAccount build() => _build();

  _$FundingBankAccount _build() {
    final _$result =
        _$v ??
        _$FundingBankAccount._(
          bankName: BuiltValueNullFieldError.checkNotNull(
            bankName,
            r'FundingBankAccount',
            'bankName',
          ),
          holder: BuiltValueNullFieldError.checkNotNull(
            holder,
            r'FundingBankAccount',
            'holder',
          ),
          rib: BuiltValueNullFieldError.checkNotNull(
            rib,
            r'FundingBankAccount',
            'rib',
          ),
          iban: BuiltValueNullFieldError.checkNotNull(
            iban,
            r'FundingBankAccount',
            'iban',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
