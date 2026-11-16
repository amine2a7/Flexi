//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/problem_code.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'problem_base.g.dart';

/// Membres communs de toute erreur RFC 9457 (`application/problem+json`). Schéma de base **non utilisé seul** : il est composé par `Problem` (sans détails) et par les variantes typées `*Problem`, chacune **fermée** par `unevaluatedProperties: false`. Les membres RFC `detail` et `instance` ne sont jamais envoyés. Aucun texte destiné à l'utilisateur : le client traduit `messageKey`. 
///
/// Properties:
/// * [type] - URN stable dérivée du code, ex. `urn:flexipay:problem:insufficient-funds`.
/// * [title] - Libellé technique anglais fixe par code. Jamais affiché.
/// * [status] - Statut HTTP, identique à celui de la réponse.
/// * [code] 
/// * [messageKey] - Clé i18n du message (`errors.<codeEnCamelCase>`).
/// * [requestId] - Identifiant de corrélation, identique à l'en-tête `X-Request-Id`.
@BuiltValue(instantiable: false)
abstract class ProblemBase  {
  /// URN stable dérivée du code, ex. `urn:flexipay:problem:insufficient-funds`.
  @BuiltValueField(wireName: r'type')
  String get type;

  /// Libellé technique anglais fixe par code. Jamais affiché.
  @BuiltValueField(wireName: r'title')
  String get title;

  /// Statut HTTP, identique à celui de la réponse.
  @BuiltValueField(wireName: r'status')
  int get status;

  @BuiltValueField(wireName: r'code')
  ProblemCode get code;
  // enum codeEnum {  VALIDATION_FAILED,  IDEMPOTENCY_KEY_REQUIRED,  IDEMPOTENCY_KEY_INVALID,  UNAUTHENTICATED,  SESSION_EXPIRED,  INVALID_CREDENTIALS,  MFA_CODE_INVALID,  MFA_CHALLENGE_EXPIRED,  PASSWORD_CHANGE_REQUIRED,  MFA_ENROLLMENT_REQUIRED,  FORBIDDEN,  CSRF_TOKEN_INVALID,  NOT_FOUND,  IDEMPOTENCY_REQUEST_IN_PROGRESS,  RESOURCE_STATE_CONFLICT,  PAYLOAD_TOO_LARGE,  UNSUPPORTED_MEDIA_TYPE,  IDEMPOTENCY_KEY_REUSED,  INSUFFICIENT_FUNDS,  LIMIT_EXCEEDED,  LAST_SUPER_ADMIN,  PAYMENT_DECLINED,  RATE_LIMITED,  INTERNAL_ERROR,  SERVICE_UNAVAILABLE,  PIN_INVALID,  PIN_LOCKED,  COMMISSION_GRID_MISSING,  QUOTE_EXPIRED,  CANCEL_WINDOW_OVER,  };

  /// Clé i18n du message (`errors.<codeEnCamelCase>`).
  @BuiltValueField(wireName: r'messageKey')
  String get messageKey;

  /// Identifiant de corrélation, identique à l'en-tête `X-Request-Id`.
  @BuiltValueField(wireName: r'requestId')
  String get requestId;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProblemBase> get serializer => _$ProblemBaseSerializer();
}

class _$ProblemBaseSerializer implements PrimitiveSerializer<ProblemBase> {
  @override
  final Iterable<Type> types = const [ProblemBase];

  @override
  final String wireName = r'ProblemBase';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProblemBase object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(ProblemCode),
    );
    yield r'messageKey';
    yield serializers.serialize(
      object.messageKey,
      specifiedType: const FullType(String),
    );
    yield r'requestId';
    yield serializers.serialize(
      object.requestId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProblemBase object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  @override
  ProblemBase deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return serializers.deserialize(serialized, specifiedType: FullType($ProblemBase)) as $ProblemBase;
  }
}


/// a concrete implementation of [ProblemBase], since [ProblemBase] is not instantiable
@BuiltValue(instantiable: true)
abstract class $ProblemBase implements ProblemBase, Built<$ProblemBase, $ProblemBaseBuilder> {
  $ProblemBase._();

  factory $ProblemBase([void Function($ProblemBaseBuilder)? updates]) = _$$ProblemBase;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults($ProblemBaseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<$ProblemBase> get serializer => _$$ProblemBaseSerializer();
}

class _$$ProblemBaseSerializer implements PrimitiveSerializer<$ProblemBase> {
  @override
  final Iterable<Type> types = const [$ProblemBase, _$$ProblemBase];

  @override
  final String wireName = r'$ProblemBase';

  @override
  Object serialize(
    Serializers serializers,
    $ProblemBase object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return serializers.serialize(object, specifiedType: FullType(ProblemBase))!;
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProblemBaseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProblemCode),
          ) as ProblemCode;
          result.code = valueDes;
          break;
        case r'messageKey':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.messageKey = valueDes;
          break;
        case r'requestId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.requestId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  $ProblemBase deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = $ProblemBaseBuilder();
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

