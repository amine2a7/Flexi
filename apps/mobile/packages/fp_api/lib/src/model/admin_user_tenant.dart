//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_user_tenant.g.dart';

/// Entreprise ou commerçant du compte (absent pour un administrateur).
///
/// Properties:
/// * [id] - Identifiant opaque de ressource.
/// * [name] 
@BuiltValue()
abstract class AdminUserTenant implements Built<AdminUserTenant, AdminUserTenantBuilder> {
  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  AdminUserTenant._();

  factory AdminUserTenant([void updates(AdminUserTenantBuilder b)]) = _$AdminUserTenant;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminUserTenantBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminUserTenant> get serializer => _$AdminUserTenantSerializer();
}

class _$AdminUserTenantSerializer implements PrimitiveSerializer<AdminUserTenant> {
  @override
  final Iterable<Type> types = const [AdminUserTenant, _$AdminUserTenant];

  @override
  final String wireName = r'AdminUserTenant';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminUserTenant object, {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminUserTenant object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminUserTenantBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminUserTenant deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminUserTenantBuilder();
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


