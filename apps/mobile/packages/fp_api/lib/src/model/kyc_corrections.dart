//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/kyc_corrections_corrections_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'kyc_corrections.g.dart';

/// KycCorrections
///
/// Properties:
/// * [corrections] 
@BuiltValue()
abstract class KycCorrections implements Built<KycCorrections, KycCorrectionsBuilder> {
  @BuiltValueField(wireName: r'corrections')
  BuiltList<KycCorrectionsCorrectionsInner> get corrections;

  KycCorrections._();

  factory KycCorrections([void updates(KycCorrectionsBuilder b)]) = _$KycCorrections;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(KycCorrectionsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<KycCorrections> get serializer => _$KycCorrectionsSerializer();
}

class _$KycCorrectionsSerializer implements PrimitiveSerializer<KycCorrections> {
  @override
  final Iterable<Type> types = const [KycCorrections, _$KycCorrections];

  @override
  final String wireName = r'KycCorrections';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    KycCorrections object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'corrections';
    yield serializers.serialize(
      object.corrections,
      specifiedType: const FullType(BuiltList, [FullType(KycCorrectionsCorrectionsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    KycCorrections object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required KycCorrectionsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'corrections':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(KycCorrectionsCorrectionsInner)]),
          ) as BuiltList<KycCorrectionsCorrectionsInner>;
          result.corrections.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  KycCorrections deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = KycCorrectionsBuilder();
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


