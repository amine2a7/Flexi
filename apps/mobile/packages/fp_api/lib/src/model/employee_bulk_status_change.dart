//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'employee_bulk_status_change.g.dart';

/// EmployeeBulkStatusChange
///
/// Properties:
/// * [action] 
/// * [employeeIds] 
/// * [reason] 
@BuiltValue()
abstract class EmployeeBulkStatusChange implements Built<EmployeeBulkStatusChange, EmployeeBulkStatusChangeBuilder> {
  @BuiltValueField(wireName: r'action')
  EmployeeBulkStatusChangeActionEnum get action;
  // enum actionEnum {  SUSPEND,  REACTIVATE,  };

  @BuiltValueField(wireName: r'employeeIds')
  BuiltSet<String> get employeeIds;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  EmployeeBulkStatusChange._();

  factory EmployeeBulkStatusChange([void updates(EmployeeBulkStatusChangeBuilder b)]) = _$EmployeeBulkStatusChange;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EmployeeBulkStatusChangeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EmployeeBulkStatusChange> get serializer => _$EmployeeBulkStatusChangeSerializer();
}

class _$EmployeeBulkStatusChangeSerializer implements PrimitiveSerializer<EmployeeBulkStatusChange> {
  @override
  final Iterable<Type> types = const [EmployeeBulkStatusChange, _$EmployeeBulkStatusChange];

  @override
  final String wireName = r'EmployeeBulkStatusChange';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EmployeeBulkStatusChange object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'action';
    yield serializers.serialize(
      object.action,
      specifiedType: const FullType(EmployeeBulkStatusChangeActionEnum),
    );
    yield r'employeeIds';
    yield serializers.serialize(
      object.employeeIds,
      specifiedType: const FullType(BuiltSet, [FullType(String)]),
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
    EmployeeBulkStatusChange object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EmployeeBulkStatusChangeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'action':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(EmployeeBulkStatusChangeActionEnum),
          ) as EmployeeBulkStatusChangeActionEnum;
          result.action = valueDes;
          break;
        case r'employeeIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltSet, [FullType(String)]),
          ) as BuiltSet<String>;
          result.employeeIds.replace(valueDes);
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
  EmployeeBulkStatusChange deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EmployeeBulkStatusChangeBuilder();
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


class EmployeeBulkStatusChangeActionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SUSPEND')
  static const EmployeeBulkStatusChangeActionEnum SUSPEND = _$employeeBulkStatusChangeActionEnum_SUSPEND;
  @BuiltValueEnumConst(wireName: r'REACTIVATE')
  static const EmployeeBulkStatusChangeActionEnum REACTIVATE = _$employeeBulkStatusChangeActionEnum_REACTIVATE;

  static Serializer<EmployeeBulkStatusChangeActionEnum> get serializer => _$employeeBulkStatusChangeActionEnumSerializer;

  const EmployeeBulkStatusChangeActionEnum._(String name): super(name);

  static BuiltSet<EmployeeBulkStatusChangeActionEnum> get values => _$employeeBulkStatusChangeActionEnumValues;
  static EmployeeBulkStatusChangeActionEnum valueOf(String name) => _$employeeBulkStatusChangeActionEnumValueOf(name);
}

