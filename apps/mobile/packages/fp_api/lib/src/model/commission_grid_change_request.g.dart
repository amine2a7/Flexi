// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commission_grid_change_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CommissionGridChangeRequest extends CommissionGridChangeRequest {
  @override
  final String? companyId;
  @override
  final String? merchantId;
  @override
  final BuiltList<CommissionTier> tiers;
  @override
  final String reason;

  factory _$CommissionGridChangeRequest([
    void Function(CommissionGridChangeRequestBuilder)? updates,
  ]) => (CommissionGridChangeRequestBuilder()..update(updates))._build();

  _$CommissionGridChangeRequest._({
    this.companyId,
    this.merchantId,
    required this.tiers,
    required this.reason,
  }) : super._();
  @override
  CommissionGridChangeRequest rebuild(
    void Function(CommissionGridChangeRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CommissionGridChangeRequestBuilder toBuilder() =>
      CommissionGridChangeRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CommissionGridChangeRequest &&
        companyId == other.companyId &&
        merchantId == other.merchantId &&
        tiers == other.tiers &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, companyId.hashCode);
    _$hash = $jc(_$hash, merchantId.hashCode);
    _$hash = $jc(_$hash, tiers.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CommissionGridChangeRequest')
          ..add('companyId', companyId)
          ..add('merchantId', merchantId)
          ..add('tiers', tiers)
          ..add('reason', reason))
        .toString();
  }
}

class CommissionGridChangeRequestBuilder
    implements
        Builder<
          CommissionGridChangeRequest,
          CommissionGridChangeRequestBuilder
        > {
  _$CommissionGridChangeRequest? _$v;

  String? _companyId;
  String? get companyId => _$this._companyId;
  set companyId(String? companyId) => _$this._companyId = companyId;

  String? _merchantId;
  String? get merchantId => _$this._merchantId;
  set merchantId(String? merchantId) => _$this._merchantId = merchantId;

  ListBuilder<CommissionTier>? _tiers;
  ListBuilder<CommissionTier> get tiers =>
      _$this._tiers ??= ListBuilder<CommissionTier>();
  set tiers(ListBuilder<CommissionTier>? tiers) => _$this._tiers = tiers;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  CommissionGridChangeRequestBuilder() {
    CommissionGridChangeRequest._defaults(this);
  }

  CommissionGridChangeRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _companyId = $v.companyId;
      _merchantId = $v.merchantId;
      _tiers = $v.tiers.toBuilder();
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CommissionGridChangeRequest other) {
    _$v = other as _$CommissionGridChangeRequest;
  }

  @override
  void update(void Function(CommissionGridChangeRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CommissionGridChangeRequest build() => _build();

  _$CommissionGridChangeRequest _build() {
    _$CommissionGridChangeRequest _$result;
    try {
      _$result =
          _$v ??
          _$CommissionGridChangeRequest._(
            companyId: companyId,
            merchantId: merchantId,
            tiers: tiers.build(),
            reason: BuiltValueNullFieldError.checkNotNull(
              reason,
              r'CommissionGridChangeRequest',
              'reason',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'tiers';
        tiers.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CommissionGridChangeRequest',
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
