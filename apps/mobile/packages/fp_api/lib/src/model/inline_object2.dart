//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/checkout_refused_problem.dart';
import 'package:fp_api/src/model/insufficient_funds_problem.dart';
import 'package:fp_api/src/model/problem.dart';
import 'package:fp_api/src/model/limit_exceeded_problem.dart';
import 'package:fp_api/src/model/checkout_refused_problem_all_of_details.dart';
import 'package:fp_api/src/model/problem_code.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:one_of/any_of.dart';

part 'inline_object2.g.dart';

/// InlineObject2
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
abstract class InlineObject2 implements Built<InlineObject2, InlineObject2Builder> {
  /// Any Of [CheckoutRefusedProblem], [InsufficientFundsProblem], [LimitExceededProblem], [Problem]
  AnyOf get anyOf;

  InlineObject2._();

  factory InlineObject2([void updates(InlineObject2Builder b)]) = _$InlineObject2;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InlineObject2Builder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InlineObject2> get serializer => _$InlineObject2Serializer();
}

class _$InlineObject2Serializer implements PrimitiveSerializer<InlineObject2> {
  @override
  final Iterable<Type> types = const [InlineObject2, _$InlineObject2];

  @override
  final String wireName = r'InlineObject2';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InlineObject2 object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
  }

  @override
  Object serialize(
    Serializers serializers,
    InlineObject2 object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final anyOf = object.anyOf;
    return serializers.serialize(anyOf, specifiedType: FullType(AnyOf, anyOf.types.map((type) => FullType(type)).toList()))!;
  }

  @override
  InlineObject2 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InlineObject2Builder();
    Object? anyOfDataSrc;
    final targetType = const FullType(AnyOf, [FullType(InsufficientFundsProblem), FullType(LimitExceededProblem), FullType(CheckoutRefusedProblem), FullType(Problem), ]);
    anyOfDataSrc = serialized;
    result.anyOf = serializers.deserialize(anyOfDataSrc, specifiedType: targetType) as AnyOf;
    return result.build();
  }
}


