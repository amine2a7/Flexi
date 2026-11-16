//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'recovery_codes.g.dart';

/// Les 10 codes de secours, renvoyés une seule fois (DP n° 10). Les précédents sont annulés. 
///
/// Properties:
/// * [recoveryCodes] 
@BuiltValue()
abstract class RecoveryCodes implements Built<RecoveryCodes, RecoveryCodesBuilder> {
  @BuiltValueField(wireName: r'recoveryCodes')
  BuiltSet<String> get recoveryCodes;

  RecoveryCodes._();

  factory RecoveryCodes([void updates(RecoveryCodesBuilder b)]) = _$RecoveryCodes;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RecoveryCodesBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RecoveryCodes> get serializer => _$RecoveryCodesSerializer();
}

class _$RecoveryCodesSerializer implements PrimitiveSerializer<RecoveryCodes> {
  @override
  final Iterable<Type> types = const [RecoveryCodes, _$RecoveryCodes];

  @override
  final String wireName = r'RecoveryCodes';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RecoveryCodes object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'recoveryCodes';
    yield serializers.serialize(
      object.recoveryCodes,
      specifiedType: const FullType(BuiltSet, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RecoveryCodes object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RecoveryCodesBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'recoveryCodes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltSet, [FullType(String)]),
          ) as BuiltSet<String>;
          result.recoveryCodes.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RecoveryCodes deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RecoveryCodesBuilder();
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


