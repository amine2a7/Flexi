// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_transfer_result.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FamilyTransferResult extends FamilyTransferResult {
  @override
  final String memberId;
  @override
  final CreditType creditType;
  @override
  final int amountMillimes;
  @override
  final String transactionId;

  factory _$FamilyTransferResult([
    void Function(FamilyTransferResultBuilder)? updates,
  ]) => (FamilyTransferResultBuilder()..update(updates))._build();

  _$FamilyTransferResult._({
    required this.memberId,
    required this.creditType,
    required this.amountMillimes,
    required this.transactionId,
  }) : super._();
  @override
  FamilyTransferResult rebuild(
    void Function(FamilyTransferResultBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  FamilyTransferResultBuilder toBuilder() =>
      FamilyTransferResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FamilyTransferResult &&
        memberId == other.memberId &&
        creditType == other.creditType &&
        amountMillimes == other.amountMillimes &&
        transactionId == other.transactionId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, memberId.hashCode);
    _$hash = $jc(_$hash, creditType.hashCode);
    _$hash = $jc(_$hash, amountMillimes.hashCode);
    _$hash = $jc(_$hash, transactionId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FamilyTransferResult')
          ..add('memberId', memberId)
          ..add('creditType', creditType)
          ..add('amountMillimes', amountMillimes)
          ..add('transactionId', transactionId))
        .toString();
  }
}

class FamilyTransferResultBuilder
    implements Builder<FamilyTransferResult, FamilyTransferResultBuilder> {
  _$FamilyTransferResult? _$v;

  String? _memberId;
  String? get memberId => _$this._memberId;
  set memberId(String? memberId) => _$this._memberId = memberId;

  CreditType? _creditType;
  CreditType? get creditType => _$this._creditType;
  set creditType(CreditType? creditType) => _$this._creditType = creditType;

  int? _amountMillimes;
  int? get amountMillimes => _$this._amountMillimes;
  set amountMillimes(int? amountMillimes) =>
      _$this._amountMillimes = amountMillimes;

  String? _transactionId;
  String? get transactionId => _$this._transactionId;
  set transactionId(String? transactionId) =>
      _$this._transactionId = transactionId;

  FamilyTransferResultBuilder() {
    FamilyTransferResult._defaults(this);
  }

  FamilyTransferResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _memberId = $v.memberId;
      _creditType = $v.creditType;
      _amountMillimes = $v.amountMillimes;
      _transactionId = $v.transactionId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FamilyTransferResult other) {
    _$v = other as _$FamilyTransferResult;
  }

  @override
  void update(void Function(FamilyTransferResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FamilyTransferResult build() => _build();

  _$FamilyTransferResult _build() {
    final _$result =
        _$v ??
        _$FamilyTransferResult._(
          memberId: BuiltValueNullFieldError.checkNotNull(
            memberId,
            r'FamilyTransferResult',
            'memberId',
          ),
          creditType: BuiltValueNullFieldError.checkNotNull(
            creditType,
            r'FamilyTransferResult',
            'creditType',
          ),
          amountMillimes: BuiltValueNullFieldError.checkNotNull(
            amountMillimes,
            r'FamilyTransferResult',
            'amountMillimes',
          ),
          transactionId: BuiltValueNullFieldError.checkNotNull(
            transactionId,
            r'FamilyTransferResult',
            'transactionId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
