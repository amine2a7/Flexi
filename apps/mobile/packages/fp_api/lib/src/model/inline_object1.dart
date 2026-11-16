//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/retry_after_details.dart';
import 'package:fp_api/src/model/problem.dart';
import 'package:fp_api/src/model/idempotency_in_progress_problem.dart';
import 'package:fp_api/src/model/problem_code.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:one_of/any_of.dart';

part 'inline_object1.g.dart';

/// InlineObject1
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
abstract class InlineObject1 implements Built<InlineObject1, InlineObject1Builder> {
  /// Any Of [IdempotencyInProgressProblem], [Problem]
  AnyOf get anyOf;

  InlineObject1._();

  factory InlineObject1([void updates(InlineObject1Builder b)]) = _$InlineObject1;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InlineObject1Builder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InlineObject1> get serializer => _$InlineObject1Serializer();
}

class _$InlineObject1Serializer implements PrimitiveSerializer<InlineObject1> {
  @override
  final Iterable<Type> types = const [InlineObject1, _$InlineObject1];

  @override
  final String wireName = r'InlineObject1';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InlineObject1 object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
  }

  @override
  Object serialize(
    Serializers serializers,
    InlineObject1 object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final anyOf = object.anyOf;
    return serializers.serialize(anyOf, specifiedType: FullType(AnyOf, anyOf.types.map((type) => FullType(type)).toList()))!;
  }

  @override
  InlineObject1 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InlineObject1Builder();
    Object? anyOfDataSrc;
    final targetType = const FullType(AnyOf, [FullType(IdempotencyInProgressProblem), FullType(Problem), ]);
    anyOfDataSrc = serialized;
    result.anyOf = serializers.deserialize(anyOfDataSrc, specifiedType: targetType) as AnyOf;
    return result.build();
  }
}


