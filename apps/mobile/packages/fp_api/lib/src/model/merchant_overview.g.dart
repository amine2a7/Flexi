// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_overview.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantOverview extends MerchantOverview {
  @override
  final OverviewKyc? kyc;
  @override
  final BuiltList<OverviewUser> users;
  @override
  final BuiltList<OverviewSale> sales;
  @override
  final BuiltList<OverviewPayout> payouts;

  factory _$MerchantOverview([
    void Function(MerchantOverviewBuilder)? updates,
  ]) => (MerchantOverviewBuilder()..update(updates))._build();

  _$MerchantOverview._({
    this.kyc,
    required this.users,
    required this.sales,
    required this.payouts,
  }) : super._();
  @override
  MerchantOverview rebuild(void Function(MerchantOverviewBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MerchantOverviewBuilder toBuilder() =>
      MerchantOverviewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantOverview &&
        kyc == other.kyc &&
        users == other.users &&
        sales == other.sales &&
        payouts == other.payouts;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kyc.hashCode);
    _$hash = $jc(_$hash, users.hashCode);
    _$hash = $jc(_$hash, sales.hashCode);
    _$hash = $jc(_$hash, payouts.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantOverview')
          ..add('kyc', kyc)
          ..add('users', users)
          ..add('sales', sales)
          ..add('payouts', payouts))
        .toString();
  }
}

class MerchantOverviewBuilder
    implements Builder<MerchantOverview, MerchantOverviewBuilder> {
  _$MerchantOverview? _$v;

  OverviewKycBuilder? _kyc;
  OverviewKycBuilder get kyc => _$this._kyc ??= OverviewKycBuilder();
  set kyc(OverviewKycBuilder? kyc) => _$this._kyc = kyc;

  ListBuilder<OverviewUser>? _users;
  ListBuilder<OverviewUser> get users =>
      _$this._users ??= ListBuilder<OverviewUser>();
  set users(ListBuilder<OverviewUser>? users) => _$this._users = users;

  ListBuilder<OverviewSale>? _sales;
  ListBuilder<OverviewSale> get sales =>
      _$this._sales ??= ListBuilder<OverviewSale>();
  set sales(ListBuilder<OverviewSale>? sales) => _$this._sales = sales;

  ListBuilder<OverviewPayout>? _payouts;
  ListBuilder<OverviewPayout> get payouts =>
      _$this._payouts ??= ListBuilder<OverviewPayout>();
  set payouts(ListBuilder<OverviewPayout>? payouts) =>
      _$this._payouts = payouts;

  MerchantOverviewBuilder() {
    MerchantOverview._defaults(this);
  }

  MerchantOverviewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kyc = $v.kyc?.toBuilder();
      _users = $v.users.toBuilder();
      _sales = $v.sales.toBuilder();
      _payouts = $v.payouts.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantOverview other) {
    _$v = other as _$MerchantOverview;
  }

  @override
  void update(void Function(MerchantOverviewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantOverview build() => _build();

  _$MerchantOverview _build() {
    _$MerchantOverview _$result;
    try {
      _$result =
          _$v ??
          _$MerchantOverview._(
            kyc: _kyc?.build(),
            users: users.build(),
            sales: sales.build(),
            payouts: payouts.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'kyc';
        _kyc?.build();
        _$failedField = 'users';
        users.build();
        _$failedField = 'sales';
        sales.build();
        _$failedField = 'payouts';
        payouts.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantOverview',
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
