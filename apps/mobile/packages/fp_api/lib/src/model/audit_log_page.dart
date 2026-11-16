//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/page_info.dart';
import 'package:fp_api/src/model/audit_log_entry.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'audit_log_page.g.dart';

/// Liste paginée de AuditLogEntry (§7).
///
/// Properties:
/// * [data] 
/// * [page] 
@BuiltValue()
abstract class AuditLogPage implements Built<AuditLogPage, AuditLogPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<AuditLogEntry> get data;

  @BuiltValueField(wireName: r'page')
  PageInfo get page;

  AuditLogPage._();

  factory AuditLogPage([void updates(AuditLogPageBuilder b)]) = _$AuditLogPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AuditLogPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AuditLogPage> get serializer => _$AuditLogPageSerializer();
}

class _$AuditLogPageSerializer implements PrimitiveSerializer<AuditLogPage> {
  @override
  final Iterable<Type> types = const [AuditLogPage, _$AuditLogPage];

  @override
  final String wireName = r'AuditLogPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AuditLogPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(AuditLogEntry)]),
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
    AuditLogPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AuditLogPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AuditLogEntry)]),
          ) as BuiltList<AuditLogEntry>;
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
  AuditLogPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AuditLogPageBuilder();
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


