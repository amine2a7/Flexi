//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/credit_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_credit_types.g.dart';

/// MerchantCreditTypes
///
/// Properties:
/// * [acceptedCreditTypes] - Types de crédit acceptés.
@BuiltValue()
abstract class MerchantCreditTypes implements Built<MerchantCreditTypes, MerchantCreditTypesBuilder> {
  /// Types de crédit acceptés.
  @BuiltValueField(wireName: r'acceptedCreditTypes')
  BuiltSet<CreditType> get acceptedCreditTypes;

  MerchantCreditTypes._();

  factory MerchantCreditTypes([void updates(MerchantCreditTypesBuilder b)]) = _$MerchantCreditTypes;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantCreditTypesBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantCreditTypes> get serializer => _$MerchantCreditTypesSerializer();
}

class _$MerchantCreditTypesSerializer implements PrimitiveSerializer<MerchantCreditTypes> {
  @override
  final Iterable<Type> types = const [MerchantCreditTypes, _$MerchantCreditTypes];

  @override
  final String wireName = r'MerchantCreditTypes';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantCreditTypes object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'acceptedCreditTypes';
    yield serializers.serialize(
      object.acceptedCreditTypes,
      specifiedType: const FullType(BuiltSet, [FullType(CreditType)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantCreditTypes object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MerchantCreditTypesBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'acceptedCreditTypes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltSet, [FullType(CreditType)]),
          ) as BuiltSet<CreditType>;
          result.acceptedCreditTypes.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantCreditTypes deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantCreditTypesBuilder();
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


