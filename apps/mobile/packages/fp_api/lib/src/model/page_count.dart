//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'page_count.g.dart';

/// Compteur borné (§7), présent seulement avec `?withCount=true` et si le comptage a abouti. `isLowerBound: false` : `value` = nombre exact de résultats ; `true` : plus de `value` résultats (plafond 10 000, DP n° 23). 
///
/// Properties:
/// * [value] 
/// * [isLowerBound] 
@BuiltValue()
abstract class PageCount implements Built<PageCount, PageCountBuilder> {
  @BuiltValueField(wireName: r'value')
  int get value;

  @BuiltValueField(wireName: r'isLowerBound')
  bool get isLowerBound;

  PageCount._();

  factory PageCount([void updates(PageCountBuilder b)]) = _$PageCount;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PageCountBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PageCount> get serializer => _$PageCountSerializer();
}

class _$PageCountSerializer implements PrimitiveSerializer<PageCount> {
  @override
  final Iterable<Type> types = const [PageCount, _$PageCount];

  @override
  final String wireName = r'PageCount';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PageCount object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'value';
    yield serializers.serialize(
      object.value,
      specifiedType: const FullType(int),
    );
    yield r'isLowerBound';
    yield serializers.serialize(
      object.isLowerBound,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PageCount object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PageCountBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.value = valueDes;
          break;
        case r'isLowerBound':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isLowerBound = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PageCount deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PageCountBuilder();
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


