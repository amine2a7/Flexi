//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/family_member.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'family_list.g.dart';

/// FamilyList
///
/// Properties:
/// * [enabled] - Faux si l'entreprise a désactivé les comptes famille.
/// * [maxMembers] 
/// * [data] 
@BuiltValue()
abstract class FamilyList implements Built<FamilyList, FamilyListBuilder> {
  /// Faux si l'entreprise a désactivé les comptes famille.
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  @BuiltValueField(wireName: r'maxMembers')
  int get maxMembers;

  @BuiltValueField(wireName: r'data')
  BuiltList<FamilyMember> get data;

  FamilyList._();

  factory FamilyList([void updates(FamilyListBuilder b)]) = _$FamilyList;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FamilyListBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FamilyList> get serializer => _$FamilyListSerializer();
}

class _$FamilyListSerializer implements PrimitiveSerializer<FamilyList> {
  @override
  final Iterable<Type> types = const [FamilyList, _$FamilyList];

  @override
  final String wireName = r'FamilyList';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FamilyList object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    yield r'maxMembers';
    yield serializers.serialize(
      object.maxMembers,
      specifiedType: const FullType(int),
    );
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(FamilyMember)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FamilyList object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FamilyListBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enabled = valueDes;
          break;
        case r'maxMembers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.maxMembers = valueDes;
          break;
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(FamilyMember)]),
          ) as BuiltList<FamilyMember>;
          result.data.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FamilyList deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FamilyListBuilder();
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


