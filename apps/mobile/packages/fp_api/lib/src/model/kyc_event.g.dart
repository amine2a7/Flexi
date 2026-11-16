// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kyc_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const KycEventActionEnum _$kycEventActionEnum_SUBMITTED =
    const KycEventActionEnum._('SUBMITTED');
const KycEventActionEnum _$kycEventActionEnum_APPROVED =
    const KycEventActionEnum._('APPROVED');
const KycEventActionEnum _$kycEventActionEnum_REJECTED =
    const KycEventActionEnum._('REJECTED');
const KycEventActionEnum _$kycEventActionEnum_DOCUMENT_UPLOADED =
    const KycEventActionEnum._('DOCUMENT_UPLOADED');
const KycEventActionEnum _$kycEventActionEnum_CORRECTION_REQUESTED =
    const KycEventActionEnum._('CORRECTION_REQUESTED');

KycEventActionEnum _$kycEventActionEnumValueOf(String name) {
  switch (name) {
    case 'SUBMITTED':
      return _$kycEventActionEnum_SUBMITTED;
    case 'APPROVED':
      return _$kycEventActionEnum_APPROVED;
    case 'REJECTED':
      return _$kycEventActionEnum_REJECTED;
    case 'DOCUMENT_UPLOADED':
      return _$kycEventActionEnum_DOCUMENT_UPLOADED;
    case 'CORRECTION_REQUESTED':
      return _$kycEventActionEnum_CORRECTION_REQUESTED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<KycEventActionEnum> _$kycEventActionEnumValues =
    BuiltSet<KycEventActionEnum>(const <KycEventActionEnum>[
      _$kycEventActionEnum_SUBMITTED,
      _$kycEventActionEnum_APPROVED,
      _$kycEventActionEnum_REJECTED,
      _$kycEventActionEnum_DOCUMENT_UPLOADED,
      _$kycEventActionEnum_CORRECTION_REQUESTED,
    ]);

Serializer<KycEventActionEnum> _$kycEventActionEnumSerializer =
    _$KycEventActionEnumSerializer();

class _$KycEventActionEnumSerializer
    implements PrimitiveSerializer<KycEventActionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'SUBMITTED': 'SUBMITTED',
    'APPROVED': 'APPROVED',
    'REJECTED': 'REJECTED',
    'DOCUMENT_UPLOADED': 'DOCUMENT_UPLOADED',
    'CORRECTION_REQUESTED': 'CORRECTION_REQUESTED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'SUBMITTED': 'SUBMITTED',
    'APPROVED': 'APPROVED',
    'REJECTED': 'REJECTED',
    'DOCUMENT_UPLOADED': 'DOCUMENT_UPLOADED',
    'CORRECTION_REQUESTED': 'CORRECTION_REQUESTED',
  };

  @override
  final Iterable<Type> types = const <Type>[KycEventActionEnum];
  @override
  final String wireName = 'KycEventActionEnum';

  @override
  Object serialize(
    Serializers serializers,
    KycEventActionEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  KycEventActionEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => KycEventActionEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$KycEvent extends KycEvent {
  @override
  final KycEventActionEnum action;
  @override
  final DateTime occurredAt;
  @override
  final String actorName;
  @override
  final String? reason;

  factory _$KycEvent([void Function(KycEventBuilder)? updates]) =>
      (KycEventBuilder()..update(updates))._build();

  _$KycEvent._({
    required this.action,
    required this.occurredAt,
    required this.actorName,
    this.reason,
  }) : super._();
  @override
  KycEvent rebuild(void Function(KycEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  KycEventBuilder toBuilder() => KycEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is KycEvent &&
        action == other.action &&
        occurredAt == other.occurredAt &&
        actorName == other.actorName &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, action.hashCode);
    _$hash = $jc(_$hash, occurredAt.hashCode);
    _$hash = $jc(_$hash, actorName.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'KycEvent')
          ..add('action', action)
          ..add('occurredAt', occurredAt)
          ..add('actorName', actorName)
          ..add('reason', reason))
        .toString();
  }
}

class KycEventBuilder implements Builder<KycEvent, KycEventBuilder> {
  _$KycEvent? _$v;

  KycEventActionEnum? _action;
  KycEventActionEnum? get action => _$this._action;
  set action(KycEventActionEnum? action) => _$this._action = action;

  DateTime? _occurredAt;
  DateTime? get occurredAt => _$this._occurredAt;
  set occurredAt(DateTime? occurredAt) => _$this._occurredAt = occurredAt;

  String? _actorName;
  String? get actorName => _$this._actorName;
  set actorName(String? actorName) => _$this._actorName = actorName;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  KycEventBuilder() {
    KycEvent._defaults(this);
  }

  KycEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _action = $v.action;
      _occurredAt = $v.occurredAt;
      _actorName = $v.actorName;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(KycEvent other) {
    _$v = other as _$KycEvent;
  }

  @override
  void update(void Function(KycEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  KycEvent build() => _build();

  _$KycEvent _build() {
    final _$result =
        _$v ??
        _$KycEvent._(
          action: BuiltValueNullFieldError.checkNotNull(
            action,
            r'KycEvent',
            'action',
          ),
          occurredAt: BuiltValueNullFieldError.checkNotNull(
            occurredAt,
            r'KycEvent',
            'occurredAt',
          ),
          actorName: BuiltValueNullFieldError.checkNotNull(
            actorName,
            r'KycEvent',
            'actorName',
          ),
          reason: reason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
