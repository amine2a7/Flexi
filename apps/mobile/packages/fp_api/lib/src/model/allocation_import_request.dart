//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'allocation_import_request.g.dart';

/// AllocationImportRequest
///
/// Properties:
/// * [csv] - Contenu du fichier CSV (UTF-8), 500 lignes au plus.
@BuiltValue()
abstract class AllocationImportRequest implements Built<AllocationImportRequest, AllocationImportRequestBuilder> {
  /// Contenu du fichier CSV (UTF-8), 500 lignes au plus.
  @BuiltValueField(wireName: r'csv')
  String get csv;

  AllocationImportRequest._();

  factory AllocationImportRequest([void updates(AllocationImportRequestBuilder b)]) = _$AllocationImportRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AllocationImportRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AllocationImportRequest> get serializer => _$AllocationImportRequestSerializer();
}

class _$AllocationImportRequestSerializer implements PrimitiveSerializer<AllocationImportRequest> {
  @override
  final Iterable<Type> types = const [AllocationImportRequest, _$AllocationImportRequest];

  @override
  final String wireName = r'AllocationImportRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AllocationImportRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'csv';
    yield serializers.serialize(
      object.csv,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AllocationImportRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AllocationImportRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'csv':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.csv = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AllocationImportRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AllocationImportRequestBuilder();
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


