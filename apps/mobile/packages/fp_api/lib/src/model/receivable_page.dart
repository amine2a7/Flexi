//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/page_info.dart';
import 'package:fp_api/src/model/receivable.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'receivable_page.g.dart';

/// ReceivablePage
///
/// Properties:
/// * [data] 
/// * [page] 
/// * [totalMillimes] - Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
@BuiltValue()
abstract class ReceivablePage implements Built<ReceivablePage, ReceivablePageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<Receivable> get data;

  @BuiltValueField(wireName: r'page')
  PageInfo get page;

  /// Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
  @BuiltValueField(wireName: r'totalMillimes')
  int get totalMillimes;

  ReceivablePage._();

  factory ReceivablePage([void updates(ReceivablePageBuilder b)]) = _$ReceivablePage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReceivablePageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReceivablePage> get serializer => _$ReceivablePageSerializer();
}

class _$ReceivablePageSerializer implements PrimitiveSerializer<ReceivablePage> {
  @override
  final Iterable<Type> types = const [ReceivablePage, _$ReceivablePage];

  @override
  final String wireName = r'ReceivablePage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReceivablePage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(Receivable)]),
    );
    yield r'page';
    yield serializers.serialize(
      object.page,
      specifiedType: const FullType(PageInfo),
    );
    yield r'totalMillimes';
    yield serializers.serialize(
      object.totalMillimes,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ReceivablePage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ReceivablePageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Receivable)]),
          ) as BuiltList<Receivable>;
          result.data.replace(valueDes);
          break;
        case r'page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PageInfo),
          ) as PageInfo;
          result.page.replace(valueDes);
          break;
        case r'totalMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalMillimes = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ReceivablePage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReceivablePageBuilder();
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


