//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/overview_kyc.dart';
import 'package:fp_api/src/model/overview_payout.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/overview_user.dart';
import 'package:fp_api/src/model/overview_sale.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_overview.g.dart';

/// MerchantOverview
///
/// Properties:
/// * [kyc] 
/// * [users] 
/// * [sales] 
/// * [payouts] 
@BuiltValue()
abstract class MerchantOverview implements Built<MerchantOverview, MerchantOverviewBuilder> {
  @BuiltValueField(wireName: r'kyc')
  OverviewKyc? get kyc;

  @BuiltValueField(wireName: r'users')
  BuiltList<OverviewUser> get users;

  @BuiltValueField(wireName: r'sales')
  BuiltList<OverviewSale> get sales;

  @BuiltValueField(wireName: r'payouts')
  BuiltList<OverviewPayout> get payouts;

  MerchantOverview._();

  factory MerchantOverview([void updates(MerchantOverviewBuilder b)]) = _$MerchantOverview;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantOverviewBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantOverview> get serializer => _$MerchantOverviewSerializer();
}

class _$MerchantOverviewSerializer implements PrimitiveSerializer<MerchantOverview> {
  @override
  final Iterable<Type> types = const [MerchantOverview, _$MerchantOverview];

  @override
  final String wireName = r'MerchantOverview';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantOverview object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kyc';
    yield object.kyc == null ? null : serializers.serialize(
      object.kyc,
      specifiedType: const FullType.nullable(OverviewKyc),
    );
    yield r'users';
    yield serializers.serialize(
      object.users,
      specifiedType: const FullType(BuiltList, [FullType(OverviewUser)]),
    );
    yield r'sales';
    yield serializers.serialize(
      object.sales,
      specifiedType: const FullType(BuiltList, [FullType(OverviewSale)]),
    );
    yield r'payouts';
    yield serializers.serialize(
      object.payouts,
      specifiedType: const FullType(BuiltList, [FullType(OverviewPayout)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantOverview object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MerchantOverviewBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'kyc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(OverviewKyc),
          ) as OverviewKyc?;
          if (valueDes == null) continue;
          result.kyc.replace(valueDes);
          break;
        case r'users':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(OverviewUser)]),
          ) as BuiltList<OverviewUser>;
          result.users.replace(valueDes);
          break;
        case r'sales':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(OverviewSale)]),
          ) as BuiltList<OverviewSale>;
          result.sales.replace(valueDes);
          break;
        case r'payouts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(OverviewPayout)]),
          ) as BuiltList<OverviewPayout>;
          result.payouts.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantOverview deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantOverviewBuilder();
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


