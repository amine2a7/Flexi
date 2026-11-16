//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/kyc_status.dart';
import 'package:fp_api/src/model/kyc_account_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'kyc_file_summary.g.dart';

/// KycFileSummary
///
/// Properties:
/// * [id] - Identifiant opaque de ressource.
/// * [accountType] 
/// * [accountId] - Identifiant opaque de ressource.
/// * [accountName] 
/// * [city] 
/// * [status] 
/// * [submittedAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
/// * [documentsCount] 
@BuiltValue()
abstract class KycFileSummary implements Built<KycFileSummary, KycFileSummaryBuilder> {
  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'accountType')
  KycAccountType get accountType;
  // enum accountTypeEnum {  MERCHANT,  COMPANY,  };

  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'accountId')
  String get accountId;

  @BuiltValueField(wireName: r'accountName')
  String get accountName;

  @BuiltValueField(wireName: r'city')
  String get city;

  @BuiltValueField(wireName: r'status')
  KycStatus get status;
  // enum statusEnum {  PENDING,  APPROVED,  REJECTED,  };

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'submittedAt')
  DateTime get submittedAt;

  @BuiltValueField(wireName: r'documentsCount')
  int get documentsCount;

  KycFileSummary._();

  factory KycFileSummary([void updates(KycFileSummaryBuilder b)]) = _$KycFileSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(KycFileSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<KycFileSummary> get serializer => _$KycFileSummarySerializer();
}

class _$KycFileSummarySerializer implements PrimitiveSerializer<KycFileSummary> {
  @override
  final Iterable<Type> types = const [KycFileSummary, _$KycFileSummary];

  @override
  final String wireName = r'KycFileSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    KycFileSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'accountType';
    yield serializers.serialize(
      object.accountType,
      specifiedType: const FullType(KycAccountType),
    );
    yield r'accountId';
    yield serializers.serialize(
      object.accountId,
      specifiedType: const FullType(String),
    );
    yield r'accountName';
    yield serializers.serialize(
      object.accountName,
      specifiedType: const FullType(String),
    );
    yield r'city';
    yield serializers.serialize(
      object.city,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(KycStatus),
    );
    yield r'submittedAt';
    yield serializers.serialize(
      object.submittedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'documentsCount';
    yield serializers.serialize(
      object.documentsCount,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    KycFileSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required KycFileSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'accountType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(KycAccountType),
          ) as KycAccountType;
          result.accountType = valueDes;
          break;
        case r'accountId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.accountId = valueDes;
          break;
        case r'accountName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.accountName = valueDes;
          break;
        case r'city':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.city = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(KycStatus),
          ) as KycStatus;
          result.status = valueDes;
          break;
        case r'submittedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.submittedAt = valueDes;
          break;
        case r'documentsCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.documentsCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  KycFileSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = KycFileSummaryBuilder();
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


