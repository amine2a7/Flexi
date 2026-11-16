// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'approval.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Approval extends Approval {
  @override
  final String id;
  @override
  final ApprovalType type;
  @override
  final ApprovalStatus status;
  @override
  final String subject;
  @override
  final int? oldRateBps;
  @override
  final int? newRateBps;
  @override
  final ApprovalLegalFormChange? legalFormChange;
  @override
  final String? maskedIban;
  @override
  final ApprovalCommissionGrid? commissionGrid;
  @override
  final String? reason;
  @override
  final String initiatorName;
  @override
  final bool initiatedByMe;
  @override
  final DateTime createdAt;

  factory _$Approval([void Function(ApprovalBuilder)? updates]) =>
      (ApprovalBuilder()..update(updates))._build();

  _$Approval._({
    required this.id,
    required this.type,
    required this.status,
    required this.subject,
    this.oldRateBps,
    this.newRateBps,
    this.legalFormChange,
    this.maskedIban,
    this.commissionGrid,
    this.reason,
    required this.initiatorName,
    required this.initiatedByMe,
    required this.createdAt,
  }) : super._();
  @override
  Approval rebuild(void Function(ApprovalBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApprovalBuilder toBuilder() => ApprovalBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Approval &&
        id == other.id &&
        type == other.type &&
        status == other.status &&
        subject == other.subject &&
        oldRateBps == other.oldRateBps &&
        newRateBps == other.newRateBps &&
        legalFormChange == other.legalFormChange &&
        maskedIban == other.maskedIban &&
        commissionGrid == other.commissionGrid &&
        reason == other.reason &&
        initiatorName == other.initiatorName &&
        initiatedByMe == other.initiatedByMe &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, subject.hashCode);
    _$hash = $jc(_$hash, oldRateBps.hashCode);
    _$hash = $jc(_$hash, newRateBps.hashCode);
    _$hash = $jc(_$hash, legalFormChange.hashCode);
    _$hash = $jc(_$hash, maskedIban.hashCode);
    _$hash = $jc(_$hash, commissionGrid.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, initiatorName.hashCode);
    _$hash = $jc(_$hash, initiatedByMe.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Approval')
          ..add('id', id)
          ..add('type', type)
          ..add('status', status)
          ..add('subject', subject)
          ..add('oldRateBps', oldRateBps)
          ..add('newRateBps', newRateBps)
          ..add('legalFormChange', legalFormChange)
          ..add('maskedIban', maskedIban)
          ..add('commissionGrid', commissionGrid)
          ..add('reason', reason)
          ..add('initiatorName', initiatorName)
          ..add('initiatedByMe', initiatedByMe)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class ApprovalBuilder implements Builder<Approval, ApprovalBuilder> {
  _$Approval? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  ApprovalType? _type;
  ApprovalType? get type => _$this._type;
  set type(ApprovalType? type) => _$this._type = type;

  ApprovalStatus? _status;
  ApprovalStatus? get status => _$this._status;
  set status(ApprovalStatus? status) => _$this._status = status;

  String? _subject;
  String? get subject => _$this._subject;
  set subject(String? subject) => _$this._subject = subject;

  int? _oldRateBps;
  int? get oldRateBps => _$this._oldRateBps;
  set oldRateBps(int? oldRateBps) => _$this._oldRateBps = oldRateBps;

  int? _newRateBps;
  int? get newRateBps => _$this._newRateBps;
  set newRateBps(int? newRateBps) => _$this._newRateBps = newRateBps;

  ApprovalLegalFormChangeBuilder? _legalFormChange;
  ApprovalLegalFormChangeBuilder get legalFormChange =>
      _$this._legalFormChange ??= ApprovalLegalFormChangeBuilder();
  set legalFormChange(ApprovalLegalFormChangeBuilder? legalFormChange) =>
      _$this._legalFormChange = legalFormChange;

  String? _maskedIban;
  String? get maskedIban => _$this._maskedIban;
  set maskedIban(String? maskedIban) => _$this._maskedIban = maskedIban;

  ApprovalCommissionGridBuilder? _commissionGrid;
  ApprovalCommissionGridBuilder get commissionGrid =>
      _$this._commissionGrid ??= ApprovalCommissionGridBuilder();
  set commissionGrid(ApprovalCommissionGridBuilder? commissionGrid) =>
      _$this._commissionGrid = commissionGrid;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _initiatorName;
  String? get initiatorName => _$this._initiatorName;
  set initiatorName(String? initiatorName) =>
      _$this._initiatorName = initiatorName;

  bool? _initiatedByMe;
  bool? get initiatedByMe => _$this._initiatedByMe;
  set initiatedByMe(bool? initiatedByMe) =>
      _$this._initiatedByMe = initiatedByMe;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  ApprovalBuilder() {
    Approval._defaults(this);
  }

  ApprovalBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _type = $v.type;
      _status = $v.status;
      _subject = $v.subject;
      _oldRateBps = $v.oldRateBps;
      _newRateBps = $v.newRateBps;
      _legalFormChange = $v.legalFormChange?.toBuilder();
      _maskedIban = $v.maskedIban;
      _commissionGrid = $v.commissionGrid?.toBuilder();
      _reason = $v.reason;
      _initiatorName = $v.initiatorName;
      _initiatedByMe = $v.initiatedByMe;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Approval other) {
    _$v = other as _$Approval;
  }

  @override
  void update(void Function(ApprovalBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Approval build() => _build();

  _$Approval _build() {
    _$Approval _$result;
    try {
      _$result =
          _$v ??
          _$Approval._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'Approval', 'id'),
            type: BuiltValueNullFieldError.checkNotNull(
              type,
              r'Approval',
              'type',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'Approval',
              'status',
            ),
            subject: BuiltValueNullFieldError.checkNotNull(
              subject,
              r'Approval',
              'subject',
            ),
            oldRateBps: oldRateBps,
            newRateBps: newRateBps,
            legalFormChange: _legalFormChange?.build(),
            maskedIban: maskedIban,
            commissionGrid: _commissionGrid?.build(),
            reason: reason,
            initiatorName: BuiltValueNullFieldError.checkNotNull(
              initiatorName,
              r'Approval',
              'initiatorName',
            ),
            initiatedByMe: BuiltValueNullFieldError.checkNotNull(
              initiatedByMe,
              r'Approval',
              'initiatedByMe',
            ),
            createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'Approval',
              'createdAt',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'legalFormChange';
        _legalFormChange?.build();

        _$failedField = 'commissionGrid';
        _commissionGrid?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'Approval',
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
