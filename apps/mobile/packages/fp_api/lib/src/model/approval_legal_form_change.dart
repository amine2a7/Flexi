//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/legal_form.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'approval_legal_form_change.g.dart';

/// Changement de forme juridique (processus v2) — forme actuelle et proposée.
///
/// Properties:
/// * [previous] 
/// * [proposed] 
@BuiltValue()
abstract class ApprovalLegalFormChange implements Built<ApprovalLegalFormChange, ApprovalLegalFormChangeBuilder> {
  @BuiltValueField(wireName: r'previous')
  LegalForm get previous;
  // enum previousEnum {  PP_CIN,  PP_MF,  PM_MF,  };

  @BuiltValueField(wireName: r'proposed')
  LegalForm get proposed;
  // enum proposedEnum {  PP_CIN,  PP_MF,  PM_MF,  };

  ApprovalLegalFormChange._();

  factory ApprovalLegalFormChange([void updates(ApprovalLegalFormChangeBuilder b)]) = _$ApprovalLegalFormChange;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApprovalLegalFormChangeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApprovalLegalFormChange> get serializer => _$ApprovalLegalFormChangeSerializer();
}

class _$ApprovalLegalFormChangeSerializer implements PrimitiveSerializer<ApprovalLegalFormChange> {
  @override
  final Iterable<Type> types = const [ApprovalLegalFormChange, _$ApprovalLegalFormChange];

  @override
  final String wireName = r'ApprovalLegalFormChange';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApprovalLegalFormChange object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'previous';
    yield serializers.serialize(
      object.previous,
      specifiedType: const FullType(LegalForm),
    );
    yield r'proposed';
    yield serializers.serialize(
      object.proposed,
      specifiedType: const FullType(LegalForm),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApprovalLegalFormChange object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApprovalLegalFormChangeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'previous':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(LegalForm),
          ) as LegalForm;
          result.previous = valueDes;
          break;
        case r'proposed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(LegalForm),
          ) as LegalForm;
          result.proposed = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApprovalLegalFormChange deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApprovalLegalFormChangeBuilder();
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


