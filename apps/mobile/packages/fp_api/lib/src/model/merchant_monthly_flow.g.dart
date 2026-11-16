// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_monthly_flow.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantMonthlyFlow extends MerchantMonthlyFlow {
  @override
  final String month;
  @override
  final int collectedMillimes;
  @override
  final int settledMillimes;

  factory _$MerchantMonthlyFlow([
    void Function(MerchantMonthlyFlowBuilder)? updates,
  ]) => (MerchantMonthlyFlowBuilder()..update(updates))._build();

  _$MerchantMonthlyFlow._({
    required this.month,
    required this.collectedMillimes,
    required this.settledMillimes,
  }) : super._();
  @override
  MerchantMonthlyFlow rebuild(
    void Function(MerchantMonthlyFlowBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantMonthlyFlowBuilder toBuilder() =>
      MerchantMonthlyFlowBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantMonthlyFlow &&
        month == other.month &&
        collectedMillimes == other.collectedMillimes &&
        settledMillimes == other.settledMillimes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, month.hashCode);
    _$hash = $jc(_$hash, collectedMillimes.hashCode);
    _$hash = $jc(_$hash, settledMillimes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantMonthlyFlow')
          ..add('month', month)
          ..add('collectedMillimes', collectedMillimes)
          ..add('settledMillimes', settledMillimes))
        .toString();
  }
}

class MerchantMonthlyFlowBuilder
    implements Builder<MerchantMonthlyFlow, MerchantMonthlyFlowBuilder> {
  _$MerchantMonthlyFlow? _$v;

  String? _month;
  String? get month => _$this._month;
  set month(String? month) => _$this._month = month;

  int? _collectedMillimes;
  int? get collectedMillimes => _$this._collectedMillimes;
  set collectedMillimes(int? collectedMillimes) =>
      _$this._collectedMillimes = collectedMillimes;

  int? _settledMillimes;
  int? get settledMillimes => _$this._settledMillimes;
  set settledMillimes(int? settledMillimes) =>
      _$this._settledMillimes = settledMillimes;

  MerchantMonthlyFlowBuilder() {
    MerchantMonthlyFlow._defaults(this);
  }

  MerchantMonthlyFlowBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _month = $v.month;
      _collectedMillimes = $v.collectedMillimes;
      _settledMillimes = $v.settledMillimes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantMonthlyFlow other) {
    _$v = other as _$MerchantMonthlyFlow;
  }

  @override
  void update(void Function(MerchantMonthlyFlowBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantMonthlyFlow build() => _build();

  _$MerchantMonthlyFlow _build() {
    final _$result =
        _$v ??
        _$MerchantMonthlyFlow._(
          month: BuiltValueNullFieldError.checkNotNull(
            month,
            r'MerchantMonthlyFlow',
            'month',
          ),
          collectedMillimes: BuiltValueNullFieldError.checkNotNull(
            collectedMillimes,
            r'MerchantMonthlyFlow',
            'collectedMillimes',
          ),
          settledMillimes: BuiltValueNullFieldError.checkNotNull(
            settledMillimes,
            r'MerchantMonthlyFlow',
            'settledMillimes',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
