//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/credit_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'family_reclaim.g.dart';

/// FamilyReclaim
///
/// Properties:
/// * [creditType] 
@BuiltValue()
abstract class FamilyReclaim implements Built<FamilyReclaim, FamilyReclaimBuilder> {
  @BuiltValueField(wireName: r'creditType')
  CreditType? get creditType;
  // enum creditTypeEnum {  RESTAURATION,  HABILLEMENT,  CARBURANT,  CADEAUX,  };

  FamilyReclaim._();

  factory FamilyReclaim([void updates(FamilyReclaimBuilder b)]) = _$FamilyReclaim;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FamilyReclaimBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FamilyReclaim> get serializer => _$FamilyReclaimSerializer();
}

class _$FamilyReclaimSerializer implements PrimitiveSerializer<FamilyReclaim> {
  @override
  final Iterable<Type> types = const [FamilyReclaim, _$FamilyReclaim];

  @override
  final String wireName = r'FamilyReclaim';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FamilyReclaim object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'creditType';
    yield object.creditType == null ? null : serializers.serialize(
      object.creditType,
      specifiedType: const FullType.nullable(CreditType),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FamilyReclaim object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FamilyReclaimBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'creditType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CreditType),
          ) as CreditType?;
          if (valueDes == null) continue;
          result.creditType = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FamilyReclaim deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FamilyReclaimBuilder();
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


