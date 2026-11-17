//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'cashier_register_assignment.g.dart';

/// CashierRegisterAssignment
///
/// Properties:
/// * [registerId] - Caisse du caissier ; `null` pour le détacher.
@BuiltValue()
abstract class CashierRegisterAssignment implements Built<CashierRegisterAssignment, CashierRegisterAssignmentBuilder> {
  /// Caisse du caissier ; `null` pour le détacher.
  @BuiltValueField(wireName: r'registerId')
  String? get registerId;

  CashierRegisterAssignment._();

  factory CashierRegisterAssignment([void updates(CashierRegisterAssignmentBuilder b)]) = _$CashierRegisterAssignment;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CashierRegisterAssignmentBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CashierRegisterAssignment> get serializer => _$CashierRegisterAssignmentSerializer();
}

class _$CashierRegisterAssignmentSerializer implements PrimitiveSerializer<CashierRegisterAssignment> {
  @override
  final Iterable<Type> types = const [CashierRegisterAssignment, _$CashierRegisterAssignment];

  @override
  final String wireName = r'CashierRegisterAssignment';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CashierRegisterAssignment object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'registerId';
    yield object.registerId == null ? null : serializers.serialize(
      object.registerId,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CashierRegisterAssignment object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CashierRegisterAssignmentBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'registerId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.registerId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CashierRegisterAssignment deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CashierRegisterAssignmentBuilder();
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


