//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'insufficient_funds_problem_all_of_details.g.dart';

/// InsufficientFundsProblemAllOfDetails
///
/// Properties:
/// * [missingMillimes] - Montant en millimes strictement positif (montant d'une opération demandée).
@BuiltValue()
abstract class InsufficientFundsProblemAllOfDetails implements Built<InsufficientFundsProblemAllOfDetails, InsufficientFundsProblemAllOfDetailsBuilder> {
  /// Montant en millimes strictement positif (montant d'une opération demandée).
  @BuiltValueField(wireName: r'missingMillimes')
  int get missingMillimes;

  InsufficientFundsProblemAllOfDetails._();

  factory InsufficientFundsProblemAllOfDetails([void updates(InsufficientFundsProblemAllOfDetailsBuilder b)]) = _$InsufficientFundsProblemAllOfDetails;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InsufficientFundsProblemAllOfDetailsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InsufficientFundsProblemAllOfDetails> get serializer => _$InsufficientFundsProblemAllOfDetailsSerializer();
}

class _$InsufficientFundsProblemAllOfDetailsSerializer implements PrimitiveSerializer<InsufficientFundsProblemAllOfDetails> {
  @override
  final Iterable<Type> types = const [InsufficientFundsProblemAllOfDetails, _$InsufficientFundsProblemAllOfDetails];

  @override
  final String wireName = r'InsufficientFundsProblemAllOfDetails';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InsufficientFundsProblemAllOfDetails object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'missingMillimes';
    yield serializers.serialize(
      object.missingMillimes,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    InsufficientFundsProblemAllOfDetails object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InsufficientFundsProblemAllOfDetailsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'missingMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.missingMillimes = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InsufficientFundsProblemAllOfDetails deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InsufficientFundsProblemAllOfDetailsBuilder();
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


