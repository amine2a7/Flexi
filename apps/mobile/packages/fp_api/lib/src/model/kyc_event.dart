//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'kyc_event.g.dart';

/// KycEvent
///
/// Properties:
/// * [action] 
/// * [occurredAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
/// * [actorName] 
/// * [reason] 
@BuiltValue()
abstract class KycEvent implements Built<KycEvent, KycEventBuilder> {
  @BuiltValueField(wireName: r'action')
  KycEventActionEnum get action;
  // enum actionEnum {  SUBMITTED,  APPROVED,  REJECTED,  DOCUMENT_UPLOADED,  CORRECTION_REQUESTED,  };

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'occurredAt')
  DateTime get occurredAt;

  @BuiltValueField(wireName: r'actorName')
  String get actorName;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  KycEvent._();

  factory KycEvent([void updates(KycEventBuilder b)]) = _$KycEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(KycEventBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<KycEvent> get serializer => _$KycEventSerializer();
}

class _$KycEventSerializer implements PrimitiveSerializer<KycEvent> {
  @override
  final Iterable<Type> types = const [KycEvent, _$KycEvent];

  @override
  final String wireName = r'KycEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    KycEvent object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'action';
    yield serializers.serialize(
      object.action,
      specifiedType: const FullType(KycEventActionEnum),
    );
    yield r'occurredAt';
    yield serializers.serialize(
      object.occurredAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'actorName';
    yield serializers.serialize(
      object.actorName,
      specifiedType: const FullType(String),
    );
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    KycEvent object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required KycEventBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'action':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(KycEventActionEnum),
          ) as KycEventActionEnum;
          result.action = valueDes;
          break;
        case r'occurredAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.occurredAt = valueDes;
          break;
        case r'actorName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.actorName = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  KycEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = KycEventBuilder();
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


class KycEventActionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SUBMITTED')
  static const KycEventActionEnum SUBMITTED = _$kycEventActionEnum_SUBMITTED;
  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const KycEventActionEnum APPROVED = _$kycEventActionEnum_APPROVED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const KycEventActionEnum REJECTED = _$kycEventActionEnum_REJECTED;
  @BuiltValueEnumConst(wireName: r'DOCUMENT_UPLOADED')
  static const KycEventActionEnum DOCUMENT_UPLOADED = _$kycEventActionEnum_DOCUMENT_UPLOADED;
  @BuiltValueEnumConst(wireName: r'CORRECTION_REQUESTED')
  static const KycEventActionEnum CORRECTION_REQUESTED = _$kycEventActionEnum_CORRECTION_REQUESTED;

  static Serializer<KycEventActionEnum> get serializer => _$kycEventActionEnumSerializer;

  const KycEventActionEnum._(String name): super(name);

  static BuiltSet<KycEventActionEnum> get values => _$kycEventActionEnumValues;
  static KycEventActionEnum valueOf(String name) => _$kycEventActionEnumValueOf(name);
}

