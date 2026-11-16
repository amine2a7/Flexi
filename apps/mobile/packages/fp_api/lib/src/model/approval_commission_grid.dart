//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/commission_tier.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'approval_commission_grid.g.dart';

/// Grille en vigueur (`null` sans grille) et grille proposée (COMMISSION_GRID_CHANGE).
///
/// Properties:
/// * [previous] 
/// * [proposed] 
@BuiltValue()
abstract class ApprovalCommissionGrid implements Built<ApprovalCommissionGrid, ApprovalCommissionGridBuilder> {
  @BuiltValueField(wireName: r'previous')
  BuiltList<CommissionTier>? get previous;

  @BuiltValueField(wireName: r'proposed')
  BuiltList<CommissionTier> get proposed;

  ApprovalCommissionGrid._();

  factory ApprovalCommissionGrid([void updates(ApprovalCommissionGridBuilder b)]) = _$ApprovalCommissionGrid;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApprovalCommissionGridBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApprovalCommissionGrid> get serializer => _$ApprovalCommissionGridSerializer();
}

class _$ApprovalCommissionGridSerializer implements PrimitiveSerializer<ApprovalCommissionGrid> {
  @override
  final Iterable<Type> types = const [ApprovalCommissionGrid, _$ApprovalCommissionGrid];

  @override
  final String wireName = r'ApprovalCommissionGrid';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApprovalCommissionGrid object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'previous';
    yield object.previous == null ? null : serializers.serialize(
      object.previous,
      specifiedType: const FullType.nullable(BuiltList, [FullType(CommissionTier)]),
    );
    yield r'proposed';
    yield serializers.serialize(
      object.proposed,
      specifiedType: const FullType(BuiltList, [FullType(CommissionTier)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApprovalCommissionGrid object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApprovalCommissionGridBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'previous':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(CommissionTier)]),
          ) as BuiltList<CommissionTier>?;
          if (valueDes == null) continue;
          result.previous.replace(valueDes);
          break;
        case r'proposed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CommissionTier)]),
          ) as BuiltList<CommissionTier>;
          result.proposed.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApprovalCommissionGrid deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApprovalCommissionGridBuilder();
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


