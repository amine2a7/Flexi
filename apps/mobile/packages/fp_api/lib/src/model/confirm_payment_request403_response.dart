//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/problem.dart';
import 'package:fp_api/src/model/pin_refused_problem.dart';
import 'package:fp_api/src/model/pin_refused_problem_all_of_details.dart';
import 'package:fp_api/src/model/problem_code.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:one_of/one_of.dart';

part 'confirm_payment_request403_response.g.dart';

/// ConfirmPaymentRequest403Response
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
abstract class ConfirmPaymentRequest403Response implements Built<ConfirmPaymentRequest403Response, ConfirmPaymentRequest403ResponseBuilder> {
  /// One Of [PinRefusedProblem], [Problem]
  OneOf get oneOf;

  ConfirmPaymentRequest403Response._();

  factory ConfirmPaymentRequest403Response([void updates(ConfirmPaymentRequest403ResponseBuilder b)]) = _$ConfirmPaymentRequest403Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ConfirmPaymentRequest403ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ConfirmPaymentRequest403Response> get serializer => _$ConfirmPaymentRequest403ResponseSerializer();
}

class _$ConfirmPaymentRequest403ResponseSerializer implements PrimitiveSerializer<ConfirmPaymentRequest403Response> {
  @override
  final Iterable<Type> types = const [ConfirmPaymentRequest403Response, _$ConfirmPaymentRequest403Response];

  @override
  final String wireName = r'ConfirmPaymentRequest403Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ConfirmPaymentRequest403Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
  }

  @override
  Object serialize(
    Serializers serializers,
    ConfirmPaymentRequest403Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final oneOf = object.oneOf;
    return serializers.serialize(oneOf.value, specifiedType: FullType(oneOf.valueType))!;
  }

  @override
  ConfirmPaymentRequest403Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ConfirmPaymentRequest403ResponseBuilder();
    Object? oneOfDataSrc;
    final targetType = const FullType(OneOf, [FullType(PinRefusedProblem), FullType(Problem), ]);
    oneOfDataSrc = serialized;
    result.oneOf = serializers.deserialize(oneOfDataSrc, specifiedType: targetType) as OneOf;
    return result.build();
  }
}


