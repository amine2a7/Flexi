//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/employee_status.dart';
import 'package:fp_api/src/model/temporary_credentials.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'employee.g.dart';

/// Employee
///
/// Properties:
/// * [credentials] - Identifiants affichés une seule fois à qui crée l'employé (administrateur ou entreprise). Pour une adresse qui a déjà un compte, ce mot de passe n'est jamais activé (même réponse, rien n'est révélé).
/// * [position] - Poste (texte libre, ex. Ouvrier).
/// * [departmentId] - Département de l'employé (absent sans département).
/// * [invitationExpired] - Invité dont le mot de passe temporaire a expiré avant la première connexion (absent sinon).
/// * [id] - Identifiant opaque de ressource.
/// * [employeeNumber] 
/// * [firstName] 
/// * [lastName] 
/// * [email] 
/// * [phone] - Numéro tunisien au format E.164.
/// * [status] 
/// * [monthAllocatedMillimes] - Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
/// * [graceUntil] - Fin du délai de grâce d'un employé désactivé (absent sinon).
@BuiltValue()
abstract class Employee implements Built<Employee, EmployeeBuilder> {
  /// Identifiants affichés une seule fois à qui crée l'employé (administrateur ou entreprise). Pour une adresse qui a déjà un compte, ce mot de passe n'est jamais activé (même réponse, rien n'est révélé).
  @BuiltValueField(wireName: r'credentials')
  TemporaryCredentials? get credentials;

  /// Poste (texte libre, ex. Ouvrier).
  @BuiltValueField(wireName: r'position')
  String? get position;

  /// Département de l'employé (absent sans département).
  @BuiltValueField(wireName: r'departmentId')
  String? get departmentId;

  /// Invité dont le mot de passe temporaire a expiré avant la première connexion (absent sinon).
  @BuiltValueField(wireName: r'invitationExpired')
  bool? get invitationExpired;

  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'id')
  String get id;

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

  @BuiltValueField(wireName: r'status')
  EmployeeStatus get status;
  // enum statusEnum {  INVITED,  ACTIVE,  SUSPENDED,  DEACTIVATED,  };

  /// Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
  @BuiltValueField(wireName: r'monthAllocatedMillimes')
  int get monthAllocatedMillimes;

  /// Fin du délai de grâce d'un employé désactivé (absent sinon).
  @BuiltValueField(wireName: r'graceUntil')
  DateTime? get graceUntil;

  Employee._();

  factory Employee([void updates(EmployeeBuilder b)]) = _$Employee;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EmployeeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Employee> get serializer => _$EmployeeSerializer();
}

class _$EmployeeSerializer implements PrimitiveSerializer<Employee> {
  @override
  final Iterable<Type> types = const [Employee, _$Employee];

  @override
  final String wireName = r'Employee';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Employee object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.credentials != null) {
      yield r'credentials';
      yield serializers.serialize(
        object.credentials,
        specifiedType: const FullType(TemporaryCredentials),
      );
    }
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
        specifiedType: const FullType(String),
      );
    }
    if (object.invitationExpired != null) {
      yield r'invitationExpired';
      yield serializers.serialize(
        object.invitationExpired,
        specifiedType: const FullType(bool),
      );
    }
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
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(EmployeeStatus),
    );
    yield r'monthAllocatedMillimes';
    yield serializers.serialize(
      object.monthAllocatedMillimes,
      specifiedType: const FullType(int),
    );
    if (object.graceUntil != null) {
      yield r'graceUntil';
      yield serializers.serialize(
        object.graceUntil,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    Employee object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EmployeeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'credentials':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(TemporaryCredentials),
          ) as TemporaryCredentials?;
          if (valueDes == null) continue;
          result.credentials.replace(valueDes);
          break;
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
        case r'invitationExpired':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.invitationExpired = valueDes;
          break;
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
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(EmployeeStatus),
          ) as EmployeeStatus;
          result.status = valueDes;
          break;
        case r'monthAllocatedMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.monthAllocatedMillimes = valueDes;
          break;
        case r'graceUntil':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.graceUntil = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Employee deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EmployeeBuilder();
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


