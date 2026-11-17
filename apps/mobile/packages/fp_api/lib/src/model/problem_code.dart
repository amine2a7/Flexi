//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'problem_code.g.dart';

/// Code d'erreur machine stable (catalogue en section 4). Liste extensible.
class ProblemCode extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VALIDATION_FAILED')
  static const ProblemCode VALIDATION_FAILED = _$VALIDATION_FAILED;
  @BuiltValueEnumConst(wireName: r'IDEMPOTENCY_KEY_REQUIRED')
  static const ProblemCode IDEMPOTENCY_KEY_REQUIRED = _$IDEMPOTENCY_KEY_REQUIRED;
  @BuiltValueEnumConst(wireName: r'IDEMPOTENCY_KEY_INVALID')
  static const ProblemCode IDEMPOTENCY_KEY_INVALID = _$IDEMPOTENCY_KEY_INVALID;
  @BuiltValueEnumConst(wireName: r'UNAUTHENTICATED')
  static const ProblemCode UNAUTHENTICATED = _$UNAUTHENTICATED;
  @BuiltValueEnumConst(wireName: r'SESSION_EXPIRED')
  static const ProblemCode SESSION_EXPIRED = _$SESSION_EXPIRED;
  @BuiltValueEnumConst(wireName: r'INVALID_CREDENTIALS')
  static const ProblemCode INVALID_CREDENTIALS = _$INVALID_CREDENTIALS;
  @BuiltValueEnumConst(wireName: r'MFA_CODE_INVALID')
  static const ProblemCode MFA_CODE_INVALID = _$MFA_CODE_INVALID;
  @BuiltValueEnumConst(wireName: r'MFA_CHALLENGE_EXPIRED')
  static const ProblemCode MFA_CHALLENGE_EXPIRED = _$MFA_CHALLENGE_EXPIRED;
  @BuiltValueEnumConst(wireName: r'PASSWORD_CHANGE_REQUIRED')
  static const ProblemCode PASSWORD_CHANGE_REQUIRED = _$PASSWORD_CHANGE_REQUIRED;
  @BuiltValueEnumConst(wireName: r'MFA_ENROLLMENT_REQUIRED')
  static const ProblemCode MFA_ENROLLMENT_REQUIRED = _$MFA_ENROLLMENT_REQUIRED;
  @BuiltValueEnumConst(wireName: r'FORBIDDEN')
  static const ProblemCode FORBIDDEN = _$FORBIDDEN;
  @BuiltValueEnumConst(wireName: r'CSRF_TOKEN_INVALID')
  static const ProblemCode CSRF_TOKEN_INVALID = _$CSRF_TOKEN_INVALID;
  @BuiltValueEnumConst(wireName: r'NOT_FOUND')
  static const ProblemCode NOT_FOUND = _$NOT_FOUND;
  @BuiltValueEnumConst(wireName: r'IDEMPOTENCY_REQUEST_IN_PROGRESS')
  static const ProblemCode IDEMPOTENCY_REQUEST_IN_PROGRESS = _$IDEMPOTENCY_REQUEST_IN_PROGRESS;
  @BuiltValueEnumConst(wireName: r'RESOURCE_STATE_CONFLICT')
  static const ProblemCode RESOURCE_STATE_CONFLICT = _$RESOURCE_STATE_CONFLICT;
  @BuiltValueEnumConst(wireName: r'PAYLOAD_TOO_LARGE')
  static const ProblemCode PAYLOAD_TOO_LARGE = _$PAYLOAD_TOO_LARGE;
  @BuiltValueEnumConst(wireName: r'UNSUPPORTED_MEDIA_TYPE')
  static const ProblemCode UNSUPPORTED_MEDIA_TYPE = _$UNSUPPORTED_MEDIA_TYPE;
  @BuiltValueEnumConst(wireName: r'IDEMPOTENCY_KEY_REUSED')
  static const ProblemCode IDEMPOTENCY_KEY_REUSED = _$IDEMPOTENCY_KEY_REUSED;
  @BuiltValueEnumConst(wireName: r'INSUFFICIENT_FUNDS')
  static const ProblemCode INSUFFICIENT_FUNDS = _$INSUFFICIENT_FUNDS;
  @BuiltValueEnumConst(wireName: r'LIMIT_EXCEEDED')
  static const ProblemCode LIMIT_EXCEEDED = _$LIMIT_EXCEEDED;
  @BuiltValueEnumConst(wireName: r'LAST_SUPER_ADMIN')
  static const ProblemCode LAST_SUPER_ADMIN = _$LAST_SUPER_ADMIN;
  @BuiltValueEnumConst(wireName: r'PAYMENT_DECLINED')
  static const ProblemCode PAYMENT_DECLINED = _$PAYMENT_DECLINED;
  @BuiltValueEnumConst(wireName: r'RATE_LIMITED')
  static const ProblemCode RATE_LIMITED = _$RATE_LIMITED;
  @BuiltValueEnumConst(wireName: r'INTERNAL_ERROR')
  static const ProblemCode INTERNAL_ERROR = _$INTERNAL_ERROR;
  @BuiltValueEnumConst(wireName: r'SERVICE_UNAVAILABLE')
  static const ProblemCode SERVICE_UNAVAILABLE = _$SERVICE_UNAVAILABLE;
  @BuiltValueEnumConst(wireName: r'PIN_INVALID')
  static const ProblemCode PIN_INVALID = _$PIN_INVALID;
  @BuiltValueEnumConst(wireName: r'PIN_LOCKED')
  static const ProblemCode PIN_LOCKED = _$PIN_LOCKED;
  @BuiltValueEnumConst(wireName: r'COMMISSION_GRID_MISSING')
  static const ProblemCode COMMISSION_GRID_MISSING = _$COMMISSION_GRID_MISSING;
  @BuiltValueEnumConst(wireName: r'QUOTE_EXPIRED')
  static const ProblemCode QUOTE_EXPIRED = _$QUOTE_EXPIRED;
  @BuiltValueEnumConst(wireName: r'CANCEL_WINDOW_OVER')
  static const ProblemCode CANCEL_WINDOW_OVER = _$CANCEL_WINDOW_OVER;
  @BuiltValueEnumConst(wireName: r'CHECKOUT_REFUSED')
  static const ProblemCode CHECKOUT_REFUSED = _$CHECKOUT_REFUSED;

  static Serializer<ProblemCode> get serializer => _$problemCodeSerializer;

  const ProblemCode._(String name): super(name);

  static BuiltSet<ProblemCode> get values => _$values;
  static ProblemCode valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class ProblemCodeMixin = Object with _$ProblemCodeMixin;

