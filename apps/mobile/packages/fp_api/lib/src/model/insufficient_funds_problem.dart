//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/problem_base.dart';
import 'package:fp_api/src/model/insufficient_funds_problem_all_of_details.dart';
import 'package:built_value/json_object.dart';
import 'package:fp_api/src/model/problem_code.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'insufficient_funds_problem.g.dart';

/// Solde insuffisant (E7). Code réservé au **payeur** (le commerçant reçoit `PAYMENT_DECLINED`). Employé titulaire du wallet : `details.missingMillimes` toujours présent. Membre famille (refus dû au solde de l'employé) : **aucun** `details`, aucun montant. `details` est donc facultatif dans le schéma. Jamais de solde disponible ni de montant requis. 
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
abstract class InsufficientFundsProblem implements ProblemBase, Built<InsufficientFundsProblem, InsufficientFundsProblemBuilder> {
  @BuiltValueField(wireName: r'details')
  InsufficientFundsProblemAllOfDetails? get details;

  InsufficientFundsProblem._();

  factory InsufficientFundsProblem([void updates(InsufficientFundsProblemBuilder b)]) = _$InsufficientFundsProblem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InsufficientFundsProblemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InsufficientFundsProblem> get serializer => _$InsufficientFundsProblemSerializer();
}

class _$InsufficientFundsProblemSerializer implements PrimitiveSerializer<InsufficientFundsProblem> {
  @override
  final Iterable<Type> types = const [InsufficientFundsProblem, _$InsufficientFundsProblem];

  @override
  final String wireName = r'InsufficientFundsProblem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InsufficientFundsProblem object, {
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
        specifiedType: const FullType(InsufficientFundsProblemAllOfDetails),
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
    InsufficientFundsProblem object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InsufficientFundsProblemBuilder result,
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
            specifiedType: const FullType.nullable(InsufficientFundsProblemAllOfDetails),
          ) as InsufficientFundsProblemAllOfDetails?;
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
  InsufficientFundsProblem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InsufficientFundsProblemBuilder();
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


