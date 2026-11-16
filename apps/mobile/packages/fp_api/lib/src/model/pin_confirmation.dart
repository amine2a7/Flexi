//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pin_confirmation.g.dart';

/// PinConfirmation
///
/// Properties:
/// * [pin] - PIN à 4 chiffres. Jamais journalisé, jamais renvoyé.
@BuiltValue()
abstract class PinConfirmation implements Built<PinConfirmation, PinConfirmationBuilder> {
  /// PIN à 4 chiffres. Jamais journalisé, jamais renvoyé.
  @BuiltValueField(wireName: r'pin')
  String get pin;

  PinConfirmation._();

  factory PinConfirmation([void updates(PinConfirmationBuilder b)]) = _$PinConfirmation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PinConfirmationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PinConfirmation> get serializer => _$PinConfirmationSerializer();
}

class _$PinConfirmationSerializer implements PrimitiveSerializer<PinConfirmation> {
  @override
  final Iterable<Type> types = const [PinConfirmation, _$PinConfirmation];

  @override
  final String wireName = r'PinConfirmation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PinConfirmation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'pin';
    yield serializers.serialize(
      object.pin,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PinConfirmation object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PinConfirmationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'pin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.pin = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PinConfirmation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PinConfirmationBuilder();
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


