//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/fraud_alert.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/page_info.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fraud_alert_page.g.dart';

/// FraudAlertPage
///
/// Properties:
/// * [data] 
/// * [page] 
@BuiltValue()
abstract class FraudAlertPage implements Built<FraudAlertPage, FraudAlertPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<FraudAlert> get data;

  @BuiltValueField(wireName: r'page')
  PageInfo get page;

  FraudAlertPage._();

  factory FraudAlertPage([void updates(FraudAlertPageBuilder b)]) = _$FraudAlertPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FraudAlertPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FraudAlertPage> get serializer => _$FraudAlertPageSerializer();
}

class _$FraudAlertPageSerializer implements PrimitiveSerializer<FraudAlertPage> {
  @override
  final Iterable<Type> types = const [FraudAlertPage, _$FraudAlertPage];

  @override
  final String wireName = r'FraudAlertPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FraudAlertPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(FraudAlert)]),
    );
    yield r'page';
    yield serializers.serialize(
      object.page,
      specifiedType: const FullType(PageInfo),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FraudAlertPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FraudAlertPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(FraudAlert)]),
          ) as BuiltList<FraudAlert>;
          result.data.replace(valueDes);
          break;
        case r'page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PageInfo),
          ) as PageInfo;
          result.page.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FraudAlertPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FraudAlertPageBuilder();
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


