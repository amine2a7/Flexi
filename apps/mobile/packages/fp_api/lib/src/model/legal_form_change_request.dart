//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/legal_form.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'legal_form_change_request.g.dart';

/// LegalFormChangeRequest
///
/// Properties:
/// * [legalForm] 
/// * [reason] 
@BuiltValue()
abstract class LegalFormChangeRequest implements Built<LegalFormChangeRequest, LegalFormChangeRequestBuilder> {
  @BuiltValueField(wireName: r'legalForm')
  LegalForm get legalForm;
  // enum legalFormEnum {  PP_CIN,  PP_MF,  PM_MF,  };

  @BuiltValueField(wireName: r'reason')
  String get reason;

  LegalFormChangeRequest._();

  factory LegalFormChangeRequest([void updates(LegalFormChangeRequestBuilder b)]) = _$LegalFormChangeRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LegalFormChangeRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LegalFormChangeRequest> get serializer => _$LegalFormChangeRequestSerializer();
}

class _$LegalFormChangeRequestSerializer implements PrimitiveSerializer<LegalFormChangeRequest> {
  @override
  final Iterable<Type> types = const [LegalFormChangeRequest, _$LegalFormChangeRequest];

  @override
  final String wireName = r'LegalFormChangeRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LegalFormChangeRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'legalForm';
    yield serializers.serialize(
      object.legalForm,
      specifiedType: const FullType(LegalForm),
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
    LegalFormChangeRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LegalFormChangeRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'legalForm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(LegalForm),
          ) as LegalForm;
          result.legalForm = valueDes;
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
  LegalFormChangeRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LegalFormChangeRequestBuilder();
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


