//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/register_status.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'register.g.dart';

/// Caisse d'un commerce, avec l'identifiant public de son autocollant NFC.
///
/// Properties:
/// * [id] - Identifiant opaque de ressource.
/// * [name] 
/// * [status] 
/// * [publicId] - Aléatoire, non devinable (identifiant du lien de l'autocollant).
/// * [createdAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
@BuiltValue()
abstract class Register implements Built<Register, RegisterBuilder> {
  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'status')
  RegisterStatus get status;
  // enum statusEnum {  ACTIVE,  DISABLED,  };

  /// Aléatoire, non devinable (identifiant du lien de l'autocollant).
  @BuiltValueField(wireName: r'publicId')
  String get publicId;

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  Register._();

  factory Register([void updates(RegisterBuilder b)]) = _$Register;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RegisterBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Register> get serializer => _$RegisterSerializer();
}

class _$RegisterSerializer implements PrimitiveSerializer<Register> {
  @override
  final Iterable<Type> types = const [Register, _$Register];

  @override
  final String wireName = r'Register';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Register object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(RegisterStatus),
    );
    yield r'publicId';
    yield serializers.serialize(
      object.publicId,
      specifiedType: const FullType(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    Register object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RegisterBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RegisterStatus),
          ) as RegisterStatus;
          result.status = valueDes;
          break;
        case r'publicId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.publicId = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Register deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RegisterBuilder();
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


