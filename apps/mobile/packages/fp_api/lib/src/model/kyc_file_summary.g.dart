// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kyc_file_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$KycFileSummary extends KycFileSummary {
  @override
  final String id;
  @override
  final KycAccountType accountType;
  @override
  final String accountId;
  @override
  final String accountName;
  @override
  final String city;
  @override
  final KycStatus status;
  @override
  final DateTime submittedAt;
  @override
  final int documentsCount;

  factory _$KycFileSummary([void Function(KycFileSummaryBuilder)? updates]) =>
      (KycFileSummaryBuilder()..update(updates))._build();

  _$KycFileSummary._({
    required this.id,
    required this.accountType,
    required this.accountId,
    required this.accountName,
    required this.city,
    required this.status,
    required this.submittedAt,
    required this.documentsCount,
  }) : super._();
  @override
  KycFileSummary rebuild(void Function(KycFileSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  KycFileSummaryBuilder toBuilder() => KycFileSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is KycFileSummary &&
        id == other.id &&
        accountType == other.accountType &&
        accountId == other.accountId &&
        accountName == other.accountName &&
        city == other.city &&
        status == other.status &&
        submittedAt == other.submittedAt &&
        documentsCount == other.documentsCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, accountType.hashCode);
    _$hash = $jc(_$hash, accountId.hashCode);
    _$hash = $jc(_$hash, accountName.hashCode);
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, submittedAt.hashCode);
    _$hash = $jc(_$hash, documentsCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'KycFileSummary')
          ..add('id', id)
          ..add('accountType', accountType)
          ..add('accountId', accountId)
          ..add('accountName', accountName)
          ..add('city', city)
          ..add('status', status)
          ..add('submittedAt', submittedAt)
          ..add('documentsCount', documentsCount))
        .toString();
  }
}

class KycFileSummaryBuilder
    implements Builder<KycFileSummary, KycFileSummaryBuilder> {
  _$KycFileSummary? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  KycAccountType? _accountType;
  KycAccountType? get accountType => _$this._accountType;
  set accountType(KycAccountType? accountType) =>
      _$this._accountType = accountType;

  String? _accountId;
  String? get accountId => _$this._accountId;
  set accountId(String? accountId) => _$this._accountId = accountId;

  String? _accountName;
  String? get accountName => _$this._accountName;
  set accountName(String? accountName) => _$this._accountName = accountName;

  String? _city;
  String? get city => _$this._city;
  set city(String? city) => _$this._city = city;

  KycStatus? _status;
  KycStatus? get status => _$this._status;
  set status(KycStatus? status) => _$this._status = status;

  DateTime? _submittedAt;
  DateTime? get submittedAt => _$this._submittedAt;
  set submittedAt(DateTime? submittedAt) => _$this._submittedAt = submittedAt;

  int? _documentsCount;
  int? get documentsCount => _$this._documentsCount;
  set documentsCount(int? documentsCount) =>
      _$this._documentsCount = documentsCount;

  KycFileSummaryBuilder() {
    KycFileSummary._defaults(this);
  }

  KycFileSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _accountType = $v.accountType;
      _accountId = $v.accountId;
      _accountName = $v.accountName;
      _city = $v.city;
      _status = $v.status;
      _submittedAt = $v.submittedAt;
      _documentsCount = $v.documentsCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(KycFileSummary other) {
    _$v = other as _$KycFileSummary;
  }

  @override
  void update(void Function(KycFileSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  KycFileSummary build() => _build();

  _$KycFileSummary _build() {
    final _$result =
        _$v ??
        _$KycFileSummary._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'KycFileSummary',
            'id',
          ),
          accountType: BuiltValueNullFieldError.checkNotNull(
            accountType,
            r'KycFileSummary',
            'accountType',
          ),
          accountId: BuiltValueNullFieldError.checkNotNull(
            accountId,
            r'KycFileSummary',
            'accountId',
          ),
          accountName: BuiltValueNullFieldError.checkNotNull(
            accountName,
            r'KycFileSummary',
            'accountName',
          ),
          city: BuiltValueNullFieldError.checkNotNull(
            city,
            r'KycFileSummary',
            'city',
          ),
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'KycFileSummary',
            'status',
          ),
          submittedAt: BuiltValueNullFieldError.checkNotNull(
            submittedAt,
            r'KycFileSummary',
            'submittedAt',
          ),
          documentsCount: BuiltValueNullFieldError.checkNotNull(
            documentsCount,
            r'KycFileSummary',
            'documentsCount',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
