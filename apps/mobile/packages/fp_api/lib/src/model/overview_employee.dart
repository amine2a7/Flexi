//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/employee_status.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'overview_employee.g.dart';

/// OverviewEmployee
///
/// Properties:
/// * [id] - Identifiant opaque de ressource.
/// * [employeeNumber] 
/// * [firstName] 
/// * [lastName] 
/// * [departmentName] 
/// * [position] 
/// * [status] 
@BuiltValue()
abstract class OverviewEmployee implements Built<OverviewEmployee, OverviewEmployeeBuilder> {
  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'employeeNumber')
  String get employeeNumber;

  @BuiltValueField(wireName: r'firstName')
  String get firstName;

  @BuiltValueField(wireName: r'lastName')
  String get lastName;

  @BuiltValueField(wireName: r'departmentName')
  String? get departmentName;

  @BuiltValueField(wireName: r'position')
  String? get position;

  @BuiltValueField(wireName: r'status')
  EmployeeStatus get status;
  // enum statusEnum {  INVITED,  ACTIVE,  SUSPENDED,  DEACTIVATED,  };

  OverviewEmployee._();

  factory OverviewEmployee([void updates(OverviewEmployeeBuilder b)]) = _$OverviewEmployee;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OverviewEmployeeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OverviewEmployee> get serializer => _$OverviewEmployeeSerializer();
}

class _$OverviewEmployeeSerializer implements PrimitiveSerializer<OverviewEmployee> {
  @override
  final Iterable<Type> types = const [OverviewEmployee, _$OverviewEmployee];

  @override
  final String wireName = r'OverviewEmployee';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OverviewEmployee object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
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
    yield r'departmentName';
    yield object.departmentName == null ? null : serializers.serialize(
      object.departmentName,
      specifiedType: const FullType.nullable(String),
    );
    yield r'position';
    yield object.position == null ? null : serializers.serialize(
      object.position,
      specifiedType: const FullType.nullable(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(EmployeeStatus),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OverviewEmployee object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OverviewEmployeeBuilder result,
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
        case r'departmentName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.departmentName = valueDes;
          break;
        case r'position':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.position = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(EmployeeStatus),
          ) as EmployeeStatus;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OverviewEmployee deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OverviewEmployeeBuilder();
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


