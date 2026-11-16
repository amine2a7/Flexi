//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'employee_create.g.dart';

/// EmployeeCreate
///
/// Properties:
/// * [position] - Poste (texte libre, ex. Ouvrier).
/// * [departmentId] - Identifiant opaque de ressource.
/// * [employeeNumber] 
/// * [firstName] 
/// * [lastName] 
/// * [email] 
/// * [phone] - Numéro tunisien au format E.164.
@BuiltValue()
abstract class EmployeeCreate implements Built<EmployeeCreate, EmployeeCreateBuilder> {
  /// Poste (texte libre, ex. Ouvrier).
  @BuiltValueField(wireName: r'position')
  String? get position;

  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'departmentId')
  String? get departmentId;

  @BuiltValueField(wireName: r'employeeNumber')
  String get employeeNumber;

  @BuiltValueField(wireName: r'firstName')
  String get firstName;

  @BuiltValueField(wireName: r'lastName')
  String get lastName;

  @BuiltValueField(wireName: r'email')
  String get email;

  /// Numéro tunisien au format E.164.
  @BuiltValueField(wireName: r'phone')
  String get phone;

  EmployeeCreate._();

  factory EmployeeCreate([void updates(EmployeeCreateBuilder b)]) = _$EmployeeCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EmployeeCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EmployeeCreate> get serializer => _$EmployeeCreateSerializer();
}

class _$EmployeeCreateSerializer implements PrimitiveSerializer<EmployeeCreate> {
  @override
  final Iterable<Type> types = const [EmployeeCreate, _$EmployeeCreate];

  @override
  final String wireName = r'EmployeeCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EmployeeCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.position != null) {
      yield r'position';
      yield serializers.serialize(
        object.position,
        specifiedType: const FullType(String),
      );
    }
    if (object.departmentId != null) {
      yield r'departmentId';
      yield serializers.serialize(
        object.departmentId,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'employeeNumber';
    yield serializers.serialize(
      object.employeeNumber,
      specifiedType: const FullType(String),
    );
    yield r'firstName';
    yield serializers.serialize(
      object.firstName,
      specifiedType: const FullType(String),
    );
    yield r'lastName';
    yield serializers.serialize(
      object.lastName,
      specifiedType: const FullType(String),
    );
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'phone';
    yield serializers.serialize(
      object.phone,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EmployeeCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EmployeeCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'position':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.position = valueDes;
          break;
        case r'departmentId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.departmentId = valueDes;
          break;
        case r'employeeNumber':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.employeeNumber = valueDes;
          break;
        case r'firstName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.firstName = valueDes;
          break;
        case r'lastName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.lastName = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.phone = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EmployeeCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EmployeeCreateBuilder();
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


