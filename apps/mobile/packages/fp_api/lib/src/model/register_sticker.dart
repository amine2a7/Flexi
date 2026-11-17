//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'register_sticker.g.dart';

/// RegisterSticker
///
/// Properties:
/// * [url] - Lien NDEF `https://pay.flexipay.tn/c/<publicId>?s=<signature>`, aussi imprimé en QR.
@BuiltValue()
abstract class RegisterSticker implements Built<RegisterSticker, RegisterStickerBuilder> {
  /// Lien NDEF `https://pay.flexipay.tn/c/<publicId>?s=<signature>`, aussi imprimé en QR.
  @BuiltValueField(wireName: r'url')
  String get url;

  RegisterSticker._();

  factory RegisterSticker([void updates(RegisterStickerBuilder b)]) = _$RegisterSticker;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RegisterStickerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RegisterSticker> get serializer => _$RegisterStickerSerializer();
}

class _$RegisterStickerSerializer implements PrimitiveSerializer<RegisterSticker> {
  @override
  final Iterable<Type> types = const [RegisterSticker, _$RegisterSticker];

  @override
  final String wireName = r'RegisterSticker';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RegisterSticker object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'url';
    yield serializers.serialize(
      object.url,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RegisterSticker object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RegisterStickerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.url = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RegisterSticker deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RegisterStickerBuilder();
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


