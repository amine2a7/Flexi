//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'approval_reject_request.g.dart';

/// ApprovalRejectRequest
///
/// Properties:
/// * [reason] 
@BuiltValue()
abstract class ApprovalRejectRequest implements Built<ApprovalRejectRequest, ApprovalRejectRequestBuilder> {
  @BuiltValueField(wireName: r'reason')
  String get reason;

  ApprovalRejectRequest._();

  factory ApprovalRejectRequest([void updates(ApprovalRejectRequestBuilder b)]) = _$ApprovalRejectRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApprovalRejectRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApprovalRejectRequest> get serializer => _$ApprovalRejectRequestSerializer();
}

class _$ApprovalRejectRequestSerializer implements PrimitiveSerializer<ApprovalRejectRequest> {
  @override
  final Iterable<Type> types = const [ApprovalRejectRequest, _$ApprovalRejectRequest];

  @override
  final String wireName = r'ApprovalRejectRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApprovalRejectRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApprovalRejectRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApprovalRejectRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
  ApprovalRejectRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApprovalRejectRequestBuilder();
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


