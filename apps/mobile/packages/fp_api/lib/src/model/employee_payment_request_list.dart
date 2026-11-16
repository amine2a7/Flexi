//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/employee_payment_request.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'employee_payment_request_list.g.dart';

/// EmployeePaymentRequestList
///
/// Properties:
/// * [data] 
@BuiltValue()
abstract class EmployeePaymentRequestList implements Built<EmployeePaymentRequestList, EmployeePaymentRequestListBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<EmployeePaymentRequest> get data;

  EmployeePaymentRequestList._();

  factory EmployeePaymentRequestList([void updates(EmployeePaymentRequestListBuilder b)]) = _$EmployeePaymentRequestList;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EmployeePaymentRequestListBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EmployeePaymentRequestList> get serializer => _$EmployeePaymentRequestListSerializer();
}

class _$EmployeePaymentRequestListSerializer implements PrimitiveSerializer<EmployeePaymentRequestList> {
  @override
  final Iterable<Type> types = const [EmployeePaymentRequestList, _$EmployeePaymentRequestList];

  @override
  final String wireName = r'EmployeePaymentRequestList';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EmployeePaymentRequestList object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(EmployeePaymentRequest)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EmployeePaymentRequestList object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EmployeePaymentRequestListBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(EmployeePaymentRequest)]),
          ) as BuiltList<EmployeePaymentRequest>;
          result.data.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EmployeePaymentRequestList deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EmployeePaymentRequestListBuilder();
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


