//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'template_auto_run.g.dart';

/// TemplateAutoRun
///
/// Properties:
/// * [month] 
/// * [status] - Faite, solde insuffisant (rien n'a bougé), aucun employé, auteur du modèle inactif, ou erreur.
@BuiltValue()
abstract class TemplateAutoRun implements Built<TemplateAutoRun, TemplateAutoRunBuilder> {
  @BuiltValueField(wireName: r'month')
  String get month;

  /// Faite, solde insuffisant (rien n'a bougé), aucun employé, auteur du modèle inactif, ou erreur.
  @BuiltValueField(wireName: r'status')
  TemplateAutoRunStatusEnum get status;
  // enum statusEnum {  DONE,  INSUFFICIENT_FUNDS,  NO_EMPLOYEE,  AUTHOR_UNAVAILABLE,  FAILED,  };

  TemplateAutoRun._();

  factory TemplateAutoRun([void updates(TemplateAutoRunBuilder b)]) = _$TemplateAutoRun;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TemplateAutoRunBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TemplateAutoRun> get serializer => _$TemplateAutoRunSerializer();
}

class _$TemplateAutoRunSerializer implements PrimitiveSerializer<TemplateAutoRun> {
  @override
  final Iterable<Type> types = const [TemplateAutoRun, _$TemplateAutoRun];

  @override
  final String wireName = r'TemplateAutoRun';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TemplateAutoRun object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'month';
    yield serializers.serialize(
      object.month,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(TemplateAutoRunStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TemplateAutoRun object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TemplateAutoRunBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'month':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.month = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TemplateAutoRunStatusEnum),
          ) as TemplateAutoRunStatusEnum;
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
  TemplateAutoRun deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TemplateAutoRunBuilder();
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


/// Faite, solde insuffisant (rien n'a bougé), aucun employé, auteur du modèle inactif, ou erreur.
class TemplateAutoRunStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DONE')
  static const TemplateAutoRunStatusEnum DONE = _$templateAutoRunStatusEnum_DONE;
  @BuiltValueEnumConst(wireName: r'INSUFFICIENT_FUNDS')
  static const TemplateAutoRunStatusEnum INSUFFICIENT_FUNDS = _$templateAutoRunStatusEnum_INSUFFICIENT_FUNDS;
  @BuiltValueEnumConst(wireName: r'NO_EMPLOYEE')
  static const TemplateAutoRunStatusEnum NO_EMPLOYEE = _$templateAutoRunStatusEnum_NO_EMPLOYEE;
  @BuiltValueEnumConst(wireName: r'AUTHOR_UNAVAILABLE')
  static const TemplateAutoRunStatusEnum AUTHOR_UNAVAILABLE = _$templateAutoRunStatusEnum_AUTHOR_UNAVAILABLE;
  @BuiltValueEnumConst(wireName: r'FAILED')
  static const TemplateAutoRunStatusEnum FAILED = _$templateAutoRunStatusEnum_FAILED;

  static Serializer<TemplateAutoRunStatusEnum> get serializer => _$templateAutoRunStatusEnumSerializer;

  const TemplateAutoRunStatusEnum._(String name): super(name);

  static BuiltSet<TemplateAutoRunStatusEnum> get values => _$templateAutoRunStatusEnumValues;
  static TemplateAutoRunStatusEnum valueOf(String name) => _$templateAutoRunStatusEnumValueOf(name);
}

