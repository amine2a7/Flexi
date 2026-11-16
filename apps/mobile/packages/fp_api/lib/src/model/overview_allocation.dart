//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'overview_allocation.g.dart';

/// Une attribution (une transaction du grand livre) et le modèle relancé, le cas échéant.
///
/// Properties:
/// * [transactionId] - Identifiant opaque de ressource.
/// * [allocatedAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
/// * [lineCount] 
/// * [totalMillimes] - Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
/// * [templateName] 
@BuiltValue()
abstract class OverviewAllocation implements Built<OverviewAllocation, OverviewAllocationBuilder> {
  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'transactionId')
  String get transactionId;

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'allocatedAt')
  DateTime get allocatedAt;

  @BuiltValueField(wireName: r'lineCount')
  int get lineCount;

  /// Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
  @BuiltValueField(wireName: r'totalMillimes')
  int get totalMillimes;

  @BuiltValueField(wireName: r'templateName')
  String? get templateName;

  OverviewAllocation._();

  factory OverviewAllocation([void updates(OverviewAllocationBuilder b)]) = _$OverviewAllocation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OverviewAllocationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OverviewAllocation> get serializer => _$OverviewAllocationSerializer();
}

class _$OverviewAllocationSerializer implements PrimitiveSerializer<OverviewAllocation> {
  @override
  final Iterable<Type> types = const [OverviewAllocation, _$OverviewAllocation];

  @override
  final String wireName = r'OverviewAllocation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OverviewAllocation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'transactionId';
    yield serializers.serialize(
      object.transactionId,
      specifiedType: const FullType(String),
    );
    yield r'allocatedAt';
    yield serializers.serialize(
      object.allocatedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'lineCount';
    yield serializers.serialize(
      object.lineCount,
      specifiedType: const FullType(int),
    );
    yield r'totalMillimes';
    yield serializers.serialize(
      object.totalMillimes,
      specifiedType: const FullType(int),
    );
    yield r'templateName';
    yield object.templateName == null ? null : serializers.serialize(
      object.templateName,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OverviewAllocation object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OverviewAllocationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'transactionId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.transactionId = valueDes;
          break;
        case r'allocatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.allocatedAt = valueDes;
          break;
        case r'lineCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lineCount = valueDes;
          break;
        case r'totalMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalMillimes = valueDes;
          break;
        case r'templateName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.templateName = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OverviewAllocation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OverviewAllocationBuilder();
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


