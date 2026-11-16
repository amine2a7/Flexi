//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/retry_after_details.dart';
import 'package:fp_api/src/model/problem_base.dart';
import 'package:built_value/json_object.dart';
import 'package:fp_api/src/model/problem_code.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'service_unavailable_problem.g.dart';

/// ServiceUnavailableProblem
///
/// Properties:
/// * [type] - URN stable dérivée du code, ex. `urn:flexipay:problem:insufficient-funds`.
/// * [title] - Libellé technique anglais fixe par code. Jamais affiché.
/// * [status] - Statut HTTP, identique à celui de la réponse.
/// * [code] 
/// * [messageKey] - Clé i18n du message (`errors.<codeEnCamelCase>`).
/// * [requestId] - Identifiant de corrélation, identique à l'en-tête `X-Request-Id`.
/// * [details] 
@BuiltValue()
abstract class ServiceUnavailableProblem implements ProblemBase, Built<ServiceUnavailableProblem, ServiceUnavailableProblemBuilder> {
  @BuiltValueField(wireName: r'details')
  RetryAfterDetails? get details;

  ServiceUnavailableProblem._();

  factory ServiceUnavailableProblem([void updates(ServiceUnavailableProblemBuilder b)]) = _$ServiceUnavailableProblem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ServiceUnavailableProblemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ServiceUnavailableProblem> get serializer => _$ServiceUnavailableProblemSerializer();
}

class _$ServiceUnavailableProblemSerializer implements PrimitiveSerializer<ServiceUnavailableProblem> {
  @override
  final Iterable<Type> types = const [ServiceUnavailableProblem, _$ServiceUnavailableProblem];

  @override
  final String wireName = r'ServiceUnavailableProblem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ServiceUnavailableProblem object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'messageKey';
    yield serializers.serialize(
      object.messageKey,
      specifiedType: const FullType(String),
    );
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(ProblemCode),
    );
    yield r'requestId';
    yield serializers.serialize(
      object.requestId,
      specifiedType: const FullType(String),
    );
    if (object.details != null) {
      yield r'details';
      yield serializers.serialize(
        object.details,
        specifiedType: const FullType(RetryAfterDetails),
      );
    }
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(String),
    );
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ServiceUnavailableProblem object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ServiceUnavailableProblemBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'messageKey':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.messageKey = valueDes;
          break;
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProblemCode),
          ) as ProblemCode;
          result.code = valueDes;
          break;
        case r'requestId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.requestId = valueDes;
          break;
        case r'details':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(RetryAfterDetails),
          ) as RetryAfterDetails?;
          if (valueDes == null) continue;
          result.details.replace(valueDes);
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.type = valueDes;
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
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
  ServiceUnavailableProblem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ServiceUnavailableProblemBuilder();
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


