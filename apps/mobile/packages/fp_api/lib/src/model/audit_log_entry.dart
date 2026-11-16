//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'audit_log_entry.g.dart';

/// AuditLogEntry
///
/// Properties:
/// * [id] - Identifiant opaque de ressource.
/// * [occurredAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
/// * [actorName] 
/// * [action] - Action journalisée (`module.action`).
/// * [target] - Libellé de la ressource (aucune donnée sensible).
@BuiltValue()
abstract class AuditLogEntry implements Built<AuditLogEntry, AuditLogEntryBuilder> {
  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'occurredAt')
  DateTime get occurredAt;

  @BuiltValueField(wireName: r'actorName')
  String get actorName;

  /// Action journalisée (`module.action`).
  @BuiltValueField(wireName: r'action')
  String get action;

  /// Libellé de la ressource (aucune donnée sensible).
  @BuiltValueField(wireName: r'target')
  String get target;

  AuditLogEntry._();

  factory AuditLogEntry([void updates(AuditLogEntryBuilder b)]) = _$AuditLogEntry;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AuditLogEntryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AuditLogEntry> get serializer => _$AuditLogEntrySerializer();
}

class _$AuditLogEntrySerializer implements PrimitiveSerializer<AuditLogEntry> {
  @override
  final Iterable<Type> types = const [AuditLogEntry, _$AuditLogEntry];

  @override
  final String wireName = r'AuditLogEntry';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AuditLogEntry object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'occurredAt';
    yield serializers.serialize(
      object.occurredAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'actorName';
    yield serializers.serialize(
      object.actorName,
      specifiedType: const FullType(String),
    );
    yield r'action';
    yield serializers.serialize(
      object.action,
      specifiedType: const FullType(String),
    );
    yield r'target';
    yield serializers.serialize(
      object.target,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AuditLogEntry object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AuditLogEntryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'occurredAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.occurredAt = valueDes;
          break;
        case r'actorName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.actorName = valueDes;
          break;
        case r'action':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.action = valueDes;
          break;
        case r'target':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.target = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AuditLogEntry deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AuditLogEntryBuilder();
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


