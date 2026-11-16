//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'employee_profile.g.dart';

/// EmployeeProfile
///
/// Properties:
/// * [firstName] 
/// * [lastName] 
/// * [employeeNumber] 
/// * [email] 
/// * [phone] - Numéro tunisien au format E.164.
/// * [companyName] 
/// * [pinSet] 
@BuiltValue()
abstract class EmployeeProfile implements Built<EmployeeProfile, EmployeeProfileBuilder> {
  @BuiltValueField(wireName: r'firstName')
  String get firstName;

  @BuiltValueField(wireName: r'lastName')
  String get lastName;

  @BuiltValueField(wireName: r'employeeNumber')
  String get employeeNumber;

  @BuiltValueField(wireName: r'email')
  String get email;

  /// Numéro tunisien au format E.164.
  @BuiltValueField(wireName: r'phone')
  String get phone;

  @BuiltValueField(wireName: r'companyName')
  String get companyName;

  @BuiltValueField(wireName: r'pinSet')
  bool get pinSet;

  EmployeeProfile._();

  factory EmployeeProfile([void updates(EmployeeProfileBuilder b)]) = _$EmployeeProfile;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EmployeeProfileBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EmployeeProfile> get serializer => _$EmployeeProfileSerializer();
}

class _$EmployeeProfileSerializer implements PrimitiveSerializer<EmployeeProfile> {
  @override
  final Iterable<Type> types = const [EmployeeProfile, _$EmployeeProfile];

  @override
  final String wireName = r'EmployeeProfile';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EmployeeProfile object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    yield r'employeeNumber';
    yield serializers.serialize(
      object.employeeNumber,
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
    yield r'companyName';
    yield serializers.serialize(
      object.companyName,
      specifiedType: const FullType(String),
    );
    yield r'pinSet';
    yield serializers.serialize(
      object.pinSet,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EmployeeProfile object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EmployeeProfileBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'employeeNumber':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.employeeNumber = valueDes;
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
        case r'companyName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.companyName = valueDes;
          break;
        case r'pinSet':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.pinSet = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EmployeeProfile deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EmployeeProfileBuilder();
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


