//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/limit_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'limit_exceeded_problem_all_of_details.g.dart';

/// LimitExceededProblemAllOfDetails
///
/// Properties:
/// * [limitType] 
/// * [remainingMillimes] - Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
@BuiltValue()
abstract class LimitExceededProblemAllOfDetails implements Built<LimitExceededProblemAllOfDetails, LimitExceededProblemAllOfDetailsBuilder> {
  @BuiltValueField(wireName: r'limitType')
  LimitType get limitType;
  // enum limitTypeEnum {  TRANSACTION,  DAILY,  MONTHLY,  FAMILY_MEMBER,  };

  /// Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
  @BuiltValueField(wireName: r'remainingMillimes')
  int get remainingMillimes;

  LimitExceededProblemAllOfDetails._();

  factory LimitExceededProblemAllOfDetails([void updates(LimitExceededProblemAllOfDetailsBuilder b)]) = _$LimitExceededProblemAllOfDetails;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LimitExceededProblemAllOfDetailsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LimitExceededProblemAllOfDetails> get serializer => _$LimitExceededProblemAllOfDetailsSerializer();
}

class _$LimitExceededProblemAllOfDetailsSerializer implements PrimitiveSerializer<LimitExceededProblemAllOfDetails> {
  @override
  final Iterable<Type> types = const [LimitExceededProblemAllOfDetails, _$LimitExceededProblemAllOfDetails];

  @override
  final String wireName = r'LimitExceededProblemAllOfDetails';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LimitExceededProblemAllOfDetails object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'limitType';
    yield serializers.serialize(
      object.limitType,
      specifiedType: const FullType(LimitType),
    );
    yield r'remainingMillimes';
    yield serializers.serialize(
      object.remainingMillimes,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    LimitExceededProblemAllOfDetails object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LimitExceededProblemAllOfDetailsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'limitType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(LimitType),
          ) as LimitType;
          result.limitType = valueDes;
          break;
        case r'remainingMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.remainingMillimes = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LimitExceededProblemAllOfDetails deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LimitExceededProblemAllOfDetailsBuilder();
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


