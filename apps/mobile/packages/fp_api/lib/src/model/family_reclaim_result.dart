//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'family_reclaim_result.g.dart';

/// FamilyReclaimResult
///
/// Properties:
/// * [memberId] - Identifiant opaque de ressource.
/// * [reclaimedMillimes] - Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
@BuiltValue()
abstract class FamilyReclaimResult implements Built<FamilyReclaimResult, FamilyReclaimResultBuilder> {
  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'memberId')
  String get memberId;

  /// Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
  @BuiltValueField(wireName: r'reclaimedMillimes')
  int get reclaimedMillimes;

  FamilyReclaimResult._();

  factory FamilyReclaimResult([void updates(FamilyReclaimResultBuilder b)]) = _$FamilyReclaimResult;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FamilyReclaimResultBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FamilyReclaimResult> get serializer => _$FamilyReclaimResultSerializer();
}

class _$FamilyReclaimResultSerializer implements PrimitiveSerializer<FamilyReclaimResult> {
  @override
  final Iterable<Type> types = const [FamilyReclaimResult, _$FamilyReclaimResult];

  @override
  final String wireName = r'FamilyReclaimResult';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FamilyReclaimResult object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'memberId';
    yield serializers.serialize(
      object.memberId,
      specifiedType: const FullType(String),
    );
    yield r'reclaimedMillimes';
    yield serializers.serialize(
      object.reclaimedMillimes,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FamilyReclaimResult object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FamilyReclaimResultBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'memberId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.memberId = valueDes;
          break;
        case r'reclaimedMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.reclaimedMillimes = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FamilyReclaimResult deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FamilyReclaimResultBuilder();
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


