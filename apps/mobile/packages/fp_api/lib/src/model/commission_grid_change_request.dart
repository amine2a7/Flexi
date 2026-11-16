//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/commission_tier.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'commission_grid_change_request.g.dart';

/// Exactement une entité, `companyId` ou `merchantId`.
///
/// Properties:
/// * [companyId] - Identifiant opaque de ressource.
/// * [merchantId] - Identifiant opaque de ressource.
/// * [tiers] 
/// * [reason] 
@BuiltValue()
abstract class CommissionGridChangeRequest implements Built<CommissionGridChangeRequest, CommissionGridChangeRequestBuilder> {
  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'companyId')
  String? get companyId;

  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'merchantId')
  String? get merchantId;

  @BuiltValueField(wireName: r'tiers')
  BuiltList<CommissionTier> get tiers;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  CommissionGridChangeRequest._();

  factory CommissionGridChangeRequest([void updates(CommissionGridChangeRequestBuilder b)]) = _$CommissionGridChangeRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CommissionGridChangeRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CommissionGridChangeRequest> get serializer => _$CommissionGridChangeRequestSerializer();
}

class _$CommissionGridChangeRequestSerializer implements PrimitiveSerializer<CommissionGridChangeRequest> {
  @override
  final Iterable<Type> types = const [CommissionGridChangeRequest, _$CommissionGridChangeRequest];

  @override
  final String wireName = r'CommissionGridChangeRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CommissionGridChangeRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.companyId != null) {
      yield r'companyId';
      yield serializers.serialize(
        object.companyId,
        specifiedType: const FullType(String),
      );
    }
    if (object.merchantId != null) {
      yield r'merchantId';
      yield serializers.serialize(
        object.merchantId,
        specifiedType: const FullType(String),
      );
    }
    yield r'tiers';
    yield serializers.serialize(
      object.tiers,
      specifiedType: const FullType(BuiltList, [FullType(CommissionTier)]),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CommissionGridChangeRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CommissionGridChangeRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'companyId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.companyId = valueDes;
          break;
        case r'merchantId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.merchantId = valueDes;
          break;
        case r'tiers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CommissionTier)]),
          ) as BuiltList<CommissionTier>;
          result.tiers.replace(valueDes);
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CommissionGridChangeRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CommissionGridChangeRequestBuilder();
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


