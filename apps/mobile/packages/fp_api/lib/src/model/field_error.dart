//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/field_error_code.dart';
import 'package:fp_api/src/model/field_error_params_value.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'field_error.g.dart';

/// FieldError
///
/// Properties:
/// * [in_] 
/// * [pointer] - JSON Pointer (RFC 6901) pour `body`, ex. `/amountMillimes` ; nom du paramètre sinon.
/// * [code] 
/// * [messageKey] - Clé i18n, ex. `errors.field.tooSmall`.
/// * [params] - Paramètres de la règle (ex. `{\"min\": 1}`). Jamais la valeur saisie.
@BuiltValue()
abstract class FieldError implements Built<FieldError, FieldErrorBuilder> {
  @BuiltValueField(wireName: r'in')
  FieldErrorIn_Enum get in_;
  // enum in_Enum {  body,  query,  path,  header,  };

  /// JSON Pointer (RFC 6901) pour `body`, ex. `/amountMillimes` ; nom du paramètre sinon.
  @BuiltValueField(wireName: r'pointer')
  String get pointer;

  @BuiltValueField(wireName: r'code')
  FieldErrorCode get code;
  // enum codeEnum {  REQUIRED,  INVALID_TYPE,  INVALID_FORMAT,  INVALID_ENUM,  NOT_INTEGER,  TOO_SMALL,  TOO_BIG,  TOO_SHORT,  TOO_LONG,  UNKNOWN_FIELD,  INVALID_CURSOR,  CURRENT_PASSWORD_INVALID,  PASSWORD_POLICY_VIOLATION,  IN_FUTURE,  GRID_OVERLAP,  GRID_DEFAULT_REQUIRED,  GRID_DEFAULT_DUPLICATE,  GRID_BOUNDS,  };

  /// Clé i18n, ex. `errors.field.tooSmall`.
  @BuiltValueField(wireName: r'messageKey')
  String get messageKey;

  /// Paramètres de la règle (ex. `{\"min\": 1}`). Jamais la valeur saisie.
  @BuiltValueField(wireName: r'params')
  BuiltMap<String, FieldErrorParamsValue>? get params;

  FieldError._();

  factory FieldError([void updates(FieldErrorBuilder b)]) = _$FieldError;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FieldErrorBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FieldError> get serializer => _$FieldErrorSerializer();
}

class _$FieldErrorSerializer implements PrimitiveSerializer<FieldError> {
  @override
  final Iterable<Type> types = const [FieldError, _$FieldError];

  @override
  final String wireName = r'FieldError';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FieldError object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'in';
    yield serializers.serialize(
      object.in_,
      specifiedType: const FullType(FieldErrorIn_Enum),
    );
    yield r'pointer';
    yield serializers.serialize(
      object.pointer,
      specifiedType: const FullType(String),
    );
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(FieldErrorCode),
    );
    yield r'messageKey';
    yield serializers.serialize(
      object.messageKey,
      specifiedType: const FullType(String),
    );
    if (object.params != null) {
      yield r'params';
      yield serializers.serialize(
        object.params,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType(FieldErrorParamsValue)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    FieldError object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FieldErrorBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'in':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FieldErrorIn_Enum),
          ) as FieldErrorIn_Enum;
          result.in_ = valueDes;
          break;
        case r'pointer':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.pointer = valueDes;
          break;
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FieldErrorCode),
          ) as FieldErrorCode;
          result.code = valueDes;
          break;
        case r'messageKey':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.messageKey = valueDes;
          break;
        case r'params':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType(FieldErrorParamsValue)]),
          ) as BuiltMap<String, FieldErrorParamsValue>?;
          if (valueDes == null) continue;
          result.params.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FieldError deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FieldErrorBuilder();
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


class FieldErrorIn_Enum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'body')
  static const FieldErrorIn_Enum body = _$fieldErrorInEnum_body;
  @BuiltValueEnumConst(wireName: r'query')
  static const FieldErrorIn_Enum query = _$fieldErrorInEnum_query;
  @BuiltValueEnumConst(wireName: r'path')
  static const FieldErrorIn_Enum path = _$fieldErrorInEnum_path;
  @BuiltValueEnumConst(wireName: r'header')
  static const FieldErrorIn_Enum header = _$fieldErrorInEnum_header;

  static Serializer<FieldErrorIn_Enum> get serializer => _$fieldErrorInEnumSerializer;

  const FieldErrorIn_Enum._(String name): super(name);

  static BuiltSet<FieldErrorIn_Enum> get values => _$fieldErrorInEnumValues;
  static FieldErrorIn_Enum valueOf(String name) => _$fieldErrorInEnumValueOf(name);
}

