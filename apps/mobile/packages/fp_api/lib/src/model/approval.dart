//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/approval_legal_form_change.dart';
import 'package:fp_api/src/model/approval_type.dart';
import 'package:fp_api/src/model/approval_status.dart';
import 'package:fp_api/src/model/approval_commission_grid.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'approval.g.dart';

/// Approval
///
/// Properties:
/// * [id] - Identifiant opaque de ressource.
/// * [type] 
/// * [status] 
/// * [subject] - Libellé de la ressource concernée (profil, paramètre).
/// * [oldRateBps] - Taux en **points de base** (200 = 2 %, 150 = 1,5 %). Champs suffixés `Bps`.
/// * [newRateBps] - Taux en **points de base** (200 = 2 %, 150 = 1,5 %). Champs suffixés `Bps`.
/// * [legalFormChange] 
/// * [maskedIban] - Nouveau RIB masqué (IBAN_CHANGE).
/// * [commissionGrid] 
/// * [reason] 
/// * [initiatorName] 
/// * [initiatedByMe] - Vrai si la demande vient de l'utilisateur courant (il ne peut pas l'approuver).
/// * [createdAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
@BuiltValue()
abstract class Approval implements Built<Approval, ApprovalBuilder> {
  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'type')
  ApprovalType get type;
  // enum typeEnum {  COMMISSION_RATE_CHANGE,  SETTINGS_CHANGE,  DISPUTE_REFUND,  COMMISSION_GRID_CHANGE,  IBAN_CHANGE,  BATCH_RELEASE,  LEGAL_FORM_CHANGE,  };

  @BuiltValueField(wireName: r'status')
  ApprovalStatus get status;
  // enum statusEnum {  PENDING,  APPROVED,  REJECTED,  };

  /// Libellé de la ressource concernée (profil, paramètre).
  @BuiltValueField(wireName: r'subject')
  String get subject;

  /// Taux en **points de base** (200 = 2 %, 150 = 1,5 %). Champs suffixés `Bps`.
  @BuiltValueField(wireName: r'oldRateBps')
  int? get oldRateBps;

  /// Taux en **points de base** (200 = 2 %, 150 = 1,5 %). Champs suffixés `Bps`.
  @BuiltValueField(wireName: r'newRateBps')
  int? get newRateBps;

  @BuiltValueField(wireName: r'legalFormChange')
  ApprovalLegalFormChange? get legalFormChange;

  /// Nouveau RIB masqué (IBAN_CHANGE).
  @BuiltValueField(wireName: r'maskedIban')
  String? get maskedIban;

  @BuiltValueField(wireName: r'commissionGrid')
  ApprovalCommissionGrid? get commissionGrid;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'initiatorName')
  String get initiatorName;

  /// Vrai si la demande vient de l'utilisateur courant (il ne peut pas l'approuver).
  @BuiltValueField(wireName: r'initiatedByMe')
  bool get initiatedByMe;

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  Approval._();

  factory Approval([void updates(ApprovalBuilder b)]) = _$Approval;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApprovalBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Approval> get serializer => _$ApprovalSerializer();
}

class _$ApprovalSerializer implements PrimitiveSerializer<Approval> {
  @override
  final Iterable<Type> types = const [Approval, _$Approval];

  @override
  final String wireName = r'Approval';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Approval object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(ApprovalType),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(ApprovalStatus),
    );
    yield r'subject';
    yield serializers.serialize(
      object.subject,
      specifiedType: const FullType(String),
    );
    if (object.oldRateBps != null) {
      yield r'oldRateBps';
      yield serializers.serialize(
        object.oldRateBps,
        specifiedType: const FullType(int),
      );
    }
    if (object.newRateBps != null) {
      yield r'newRateBps';
      yield serializers.serialize(
        object.newRateBps,
        specifiedType: const FullType(int),
      );
    }
    if (object.legalFormChange != null) {
      yield r'legalFormChange';
      yield serializers.serialize(
        object.legalFormChange,
        specifiedType: const FullType(ApprovalLegalFormChange),
      );
    }
    if (object.maskedIban != null) {
      yield r'maskedIban';
      yield serializers.serialize(
        object.maskedIban,
        specifiedType: const FullType(String),
      );
    }
    if (object.commissionGrid != null) {
      yield r'commissionGrid';
      yield serializers.serialize(
        object.commissionGrid,
        specifiedType: const FullType(ApprovalCommissionGrid),
      );
    }
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType(String),
      );
    }
    yield r'initiatorName';
    yield serializers.serialize(
      object.initiatorName,
      specifiedType: const FullType(String),
    );
    yield r'initiatedByMe';
    yield serializers.serialize(
      object.initiatedByMe,
      specifiedType: const FullType(bool),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    Approval object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApprovalBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ApprovalType),
          ) as ApprovalType;
          result.type = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ApprovalStatus),
          ) as ApprovalStatus;
          result.status = valueDes;
          break;
        case r'subject':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.subject = valueDes;
          break;
        case r'oldRateBps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.oldRateBps = valueDes;
          break;
        case r'newRateBps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.newRateBps = valueDes;
          break;
        case r'legalFormChange':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ApprovalLegalFormChange),
          ) as ApprovalLegalFormChange?;
          if (valueDes == null) continue;
          result.legalFormChange.replace(valueDes);
          break;
        case r'maskedIban':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.maskedIban = valueDes;
          break;
        case r'commissionGrid':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ApprovalCommissionGrid),
          ) as ApprovalCommissionGrid?;
          if (valueDes == null) continue;
          result.commissionGrid.replace(valueDes);
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'initiatorName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.initiatorName = valueDes;
          break;
        case r'initiatedByMe':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.initiatedByMe = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Approval deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApprovalBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}


