//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'kyc_corrections_corrections_inner.g.dart';

/// KycCorrectionsCorrectionsInner
///
/// Properties:
/// * [documentId] - Identifiant opaque de ressource.
/// * [reason] 
@BuiltValue()
abstract class KycCorrectionsCorrectionsInner implements Built<KycCorrectionsCorrectionsInner, KycCorrectionsCorrectionsInnerBuilder> {
  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'documentId')
  String get documentId;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  KycCorrectionsCorrectionsInner._();

  factory KycCorrectionsCorrectionsInner([void updates(KycCorrectionsCorrectionsInnerBuilder b)]) = _$KycCorrectionsCorrectionsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(KycCorrectionsCorrectionsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<KycCorrectionsCorrectionsInner> get serializer => _$KycCorrectionsCorrectionsInnerSerializer();
}

class _$KycCorrectionsCorrectionsInnerSerializer implements PrimitiveSerializer<KycCorrectionsCorrectionsInner> {
  @override
  final Iterable<Type> types = const [KycCorrectionsCorrectionsInner, _$KycCorrectionsCorrectionsInner];

  @override
  final String wireName = r'KycCorrectionsCorrectionsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    KycCorrectionsCorrectionsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'documentId';
    yield serializers.serialize(
      object.documentId,
      specifiedType: const FullType(String),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    KycCorrectionsCorrectionsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required KycCorrectionsCorrectionsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'documentId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.documentId = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
  KycCorrectionsCorrectionsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = KycCorrectionsCorrectionsInnerBuilder();
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


