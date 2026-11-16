// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DisputeDetail extends DisputeDetail {
  @override
  final BuiltList<DisputeNote> notes;
  @override
  final String id;
  @override
  final String reference;
  @override
  final String paymentReference;
  @override
  final CreditType creditType;
  @override
  final String merchantName;
  @override
  final int amountMillimes;
  @override
  final String reason;
  @override
  final DisputeStatus status;
  @override
  final DateTime openedAt;
  @override
  final String openedByName;
  @override
  final DateTime dueAt;
  @override
  final String? decisionReason;
  @override
  final DateTime? decidedAt;

  factory _$DisputeDetail([void Function(DisputeDetailBuilder)? updates]) =>
      (DisputeDetailBuilder()..update(updates))._build();

  _$DisputeDetail._({
    required this.notes,
    required this.id,
    required this.reference,
    required this.paymentReference,
    required this.creditType,
    required this.merchantName,
    required this.amountMillimes,
    required this.reason,
    required this.status,
    required this.openedAt,
    required this.openedByName,
    required this.dueAt,
    this.decisionReason,
    this.decidedAt,
  }) : super._();
  @override
  DisputeDetail rebuild(void Function(DisputeDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeDetailBuilder toBuilder() => DisputeDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeDetail &&
        notes == other.notes &&
        id == other.id &&
        reference == other.reference &&
        paymentReference == other.paymentReference &&
        creditType == other.creditType &&
        merchantName == other.merchantName &&
        amountMillimes == other.amountMillimes &&
        reason == other.reason &&
        status == other.status &&
        openedAt == other.openedAt &&
        openedByName == other.openedByName &&
        dueAt == other.dueAt &&
        decisionReason == other.decisionReason &&
        decidedAt == other.decidedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, notes.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, reference.hashCode);
    _$hash = $jc(_$hash, paymentReference.hashCode);
    _$hash = $jc(_$hash, creditType.hashCode);
    _$hash = $jc(_$hash, merchantName.hashCode);
    _$hash = $jc(_$hash, amountMillimes.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, openedAt.hashCode);
    _$hash = $jc(_$hash, openedByName.hashCode);
    _$hash = $jc(_$hash, dueAt.hashCode);
    _$hash = $jc(_$hash, decisionReason.hashCode);
    _$hash = $jc(_$hash, decidedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DisputeDetail')
          ..add('notes', notes)
          ..add('id', id)
          ..add('reference', reference)
          ..add('paymentReference', paymentReference)
          ..add('creditType', creditType)
          ..add('merchantName', merchantName)
          ..add('amountMillimes', amountMillimes)
          ..add('reason', reason)
          ..add('status', status)
          ..add('openedAt', openedAt)
          ..add('openedByName', openedByName)
          ..add('dueAt', dueAt)
          ..add('decisionReason', decisionReason)
          ..add('decidedAt', decidedAt))
        .toString();
  }
}

class DisputeDetailBuilder
    implements Builder<DisputeDetail, DisputeDetailBuilder>, DisputeBuilder {
  _$DisputeDetail? _$v;

  ListBuilder<DisputeNote>? _notes;
  ListBuilder<DisputeNote> get notes =>
      _$this._notes ??= ListBuilder<DisputeNote>();
  set notes(covariant ListBuilder<DisputeNote>? notes) => _$this._notes = notes;

  String? _id;
  String? get id => _$this._id;
  set id(covariant String? id) => _$this._id = id;

  String? _reference;
  String? get reference => _$this._reference;
  set reference(covariant String? reference) => _$this._reference = reference;

  String? _paymentReference;
  String? get paymentReference => _$this._paymentReference;
  set paymentReference(covariant String? paymentReference) =>
      _$this._paymentReference = paymentReference;

  CreditType? _creditType;
  CreditType? get creditType => _$this._creditType;
  set creditType(covariant CreditType? creditType) =>
      _$this._creditType = creditType;

  String? _merchantName;
  String? get merchantName => _$this._merchantName;
  set merchantName(covariant String? merchantName) =>
      _$this._merchantName = merchantName;

  int? _amountMillimes;
  int? get amountMillimes => _$this._amountMillimes;
  set amountMillimes(covariant int? amountMillimes) =>
      _$this._amountMillimes = amountMillimes;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(covariant String? reason) => _$this._reason = reason;

  DisputeStatus? _status;
  DisputeStatus? get status => _$this._status;
  set status(covariant DisputeStatus? status) => _$this._status = status;

  DateTime? _openedAt;
  DateTime? get openedAt => _$this._openedAt;
  set openedAt(covariant DateTime? openedAt) => _$this._openedAt = openedAt;

  String? _openedByName;
  String? get openedByName => _$this._openedByName;
  set openedByName(covariant String? openedByName) =>
      _$this._openedByName = openedByName;

  DateTime? _dueAt;
  DateTime? get dueAt => _$this._dueAt;
  set dueAt(covariant DateTime? dueAt) => _$this._dueAt = dueAt;

  String? _decisionReason;
  String? get decisionReason => _$this._decisionReason;
  set decisionReason(covariant String? decisionReason) =>
      _$this._decisionReason = decisionReason;

  DateTime? _decidedAt;
  DateTime? get decidedAt => _$this._decidedAt;
  set decidedAt(covariant DateTime? decidedAt) => _$this._decidedAt = decidedAt;

  DisputeDetailBuilder() {
    DisputeDetail._defaults(this);
  }

  DisputeDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _notes = $v.notes.toBuilder();
      _id = $v.id;
      _reference = $v.reference;
      _paymentReference = $v.paymentReference;
      _creditType = $v.creditType;
      _merchantName = $v.merchantName;
      _amountMillimes = $v.amountMillimes;
      _reason = $v.reason;
      _status = $v.status;
      _openedAt = $v.openedAt;
      _openedByName = $v.openedByName;
      _dueAt = $v.dueAt;
      _decisionReason = $v.decisionReason;
      _decidedAt = $v.decidedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant DisputeDetail other) {
    _$v = other as _$DisputeDetail;
  }

  @override
  void update(void Function(DisputeDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeDetail build() => _build();

  _$DisputeDetail _build() {
    _$DisputeDetail _$result;
    try {
      _$result =
          _$v ??
          _$DisputeDetail._(
            notes: notes.build(),
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'DisputeDetail',
              'id',
            ),
            reference: BuiltValueNullFieldError.checkNotNull(
              reference,
              r'DisputeDetail',
              'reference',
            ),
            paymentReference: BuiltValueNullFieldError.checkNotNull(
              paymentReference,
              r'DisputeDetail',
              'paymentReference',
            ),
            creditType: BuiltValueNullFieldError.checkNotNull(
              creditType,
              r'DisputeDetail',
              'creditType',
            ),
            merchantName: BuiltValueNullFieldError.checkNotNull(
              merchantName,
              r'DisputeDetail',
              'merchantName',
            ),
            amountMillimes: BuiltValueNullFieldError.checkNotNull(
              amountMillimes,
              r'DisputeDetail',
              'amountMillimes',
            ),
            reason: BuiltValueNullFieldError.checkNotNull(
              reason,
              r'DisputeDetail',
              'reason',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'DisputeDetail',
              'status',
            ),
            openedAt: BuiltValueNullFieldError.checkNotNull(
              openedAt,
              r'DisputeDetail',
              'openedAt',
            ),
            openedByName: BuiltValueNullFieldError.checkNotNull(
              openedByName,
              r'DisputeDetail',
              'openedByName',
            ),
            dueAt: BuiltValueNullFieldError.checkNotNull(
              dueAt,
              r'DisputeDetail',
              'dueAt',
            ),
            decisionReason: decisionReason,
            decidedAt: decidedAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'notes';
        notes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'DisputeDetail',
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
