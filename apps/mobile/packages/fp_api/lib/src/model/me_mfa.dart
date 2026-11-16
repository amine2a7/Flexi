//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'me_mfa.g.dart';

/// MeMfa
///
/// Properties:
/// * [required_] 
/// * [enrolled] 
/// * [recoveryCodesRemaining] - Codes de secours encore utilisables (0 à 10, DP n° 10).
@BuiltValue()
abstract class MeMfa implements Built<MeMfa, MeMfaBuilder> {
  @BuiltValueField(wireName: r'required')
  bool get required_;

  @BuiltValueField(wireName: r'enrolled')
  bool get enrolled;

  /// Codes de secours encore utilisables (0 à 10, DP n° 10).
  @BuiltValueField(wireName: r'recoveryCodesRemaining')
  int get recoveryCodesRemaining;

  MeMfa._();

  factory MeMfa([void updates(MeMfaBuilder b)]) = _$MeMfa;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MeMfaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MeMfa> get serializer => _$MeMfaSerializer();
}

class _$MeMfaSerializer implements PrimitiveSerializer<MeMfa> {
  @override
  final Iterable<Type> types = const [MeMfa, _$MeMfa];

  @override
  final String wireName = r'MeMfa';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MeMfa object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'required';
    yield serializers.serialize(
      object.required_,
      specifiedType: const FullType(bool),
    );
    yield r'enrolled';
    yield serializers.serialize(
      object.enrolled,
      specifiedType: const FullType(bool),
    );
    yield r'recoveryCodesRemaining';
    yield serializers.serialize(
      object.recoveryCodesRemaining,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MeMfa object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MeMfaBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'required':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.required_ = valueDes;
          break;
        case r'enrolled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enrolled = valueDes;
          break;
        case r'recoveryCodesRemaining':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.recoveryCodesRemaining = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MeMfa deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MeMfaBuilder();
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


