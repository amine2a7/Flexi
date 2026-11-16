//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'iban_change_request.g.dart';

/// IbanChangeRequest
///
/// Properties:
/// * [iban] - TN + 22 chiffres. Jamais renvoyé en clair (`maskedIban`).
/// * [reason] 
@BuiltValue()
abstract class IbanChangeRequest implements Built<IbanChangeRequest, IbanChangeRequestBuilder> {
  /// TN + 22 chiffres. Jamais renvoyé en clair (`maskedIban`).
  @BuiltValueField(wireName: r'iban')
  String get iban;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  IbanChangeRequest._();

  factory IbanChangeRequest([void updates(IbanChangeRequestBuilder b)]) = _$IbanChangeRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(IbanChangeRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<IbanChangeRequest> get serializer => _$IbanChangeRequestSerializer();
}

class _$IbanChangeRequestSerializer implements PrimitiveSerializer<IbanChangeRequest> {
  @override
  final Iterable<Type> types = const [IbanChangeRequest, _$IbanChangeRequest];

  @override
  final String wireName = r'IbanChangeRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    IbanChangeRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'iban';
    yield serializers.serialize(
      object.iban,
      specifiedType: const FullType(String),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    IbanChangeRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required IbanChangeRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'iban':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.iban = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  IbanChangeRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = IbanChangeRequestBuilder();
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


