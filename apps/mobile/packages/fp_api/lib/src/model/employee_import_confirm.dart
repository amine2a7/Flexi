//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'employee_import_confirm.g.dart';

/// EmployeeImportConfirm
///
/// Properties:
/// * [previewId] - Identifiant opaque de ressource.
@BuiltValue()
abstract class EmployeeImportConfirm implements Built<EmployeeImportConfirm, EmployeeImportConfirmBuilder> {
  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'previewId')
  String get previewId;

  EmployeeImportConfirm._();

  factory EmployeeImportConfirm([void updates(EmployeeImportConfirmBuilder b)]) = _$EmployeeImportConfirm;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EmployeeImportConfirmBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EmployeeImportConfirm> get serializer => _$EmployeeImportConfirmSerializer();
}

class _$EmployeeImportConfirmSerializer implements PrimitiveSerializer<EmployeeImportConfirm> {
  @override
  final Iterable<Type> types = const [EmployeeImportConfirm, _$EmployeeImportConfirm];

  @override
  final String wireName = r'EmployeeImportConfirm';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EmployeeImportConfirm object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'previewId';
    yield serializers.serialize(
      object.previewId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EmployeeImportConfirm object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EmployeeImportConfirmBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'previewId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.previewId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EmployeeImportConfirm deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EmployeeImportConfirmBuilder();
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


