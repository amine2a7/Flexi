//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pin_change.g.dart';

/// PinChange
///
/// Properties:
/// * [currentPin] - PIN actuel, obligatoire dès qu'un PIN existe ; absent pour le premier PIN d'un nouveau bénéficiaire (une seule fois).
/// * [newPin] 
@BuiltValue()
abstract class PinChange implements Built<PinChange, PinChangeBuilder> {
  /// PIN actuel, obligatoire dès qu'un PIN existe ; absent pour le premier PIN d'un nouveau bénéficiaire (une seule fois).
  @BuiltValueField(wireName: r'currentPin')
  String? get currentPin;

  @BuiltValueField(wireName: r'newPin')
  String get newPin;

  PinChange._();

  factory PinChange([void updates(PinChangeBuilder b)]) = _$PinChange;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PinChangeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PinChange> get serializer => _$PinChangeSerializer();
}

class _$PinChangeSerializer implements PrimitiveSerializer<PinChange> {
  @override
  final Iterable<Type> types = const [PinChange, _$PinChange];

  @override
  final String wireName = r'PinChange';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PinChange object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.currentPin != null) {
      yield r'currentPin';
      yield serializers.serialize(
        object.currentPin,
        specifiedType: const FullType(String),
      );
    }
    yield r'newPin';
    yield serializers.serialize(
      object.newPin,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PinChange object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PinChangeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'currentPin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.currentPin = valueDes;
          break;
        case r'newPin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.newPin = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PinChange deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PinChangeBuilder();
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


