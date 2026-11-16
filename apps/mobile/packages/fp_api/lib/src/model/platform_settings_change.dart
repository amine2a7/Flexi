//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/platform_settings.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'platform_settings_change.g.dart';

/// PlatformSettingsChange
///
/// Properties:
/// * [settings] 
/// * [reason] 
@BuiltValue()
abstract class PlatformSettingsChange implements Built<PlatformSettingsChange, PlatformSettingsChangeBuilder> {
  @BuiltValueField(wireName: r'settings')
  PlatformSettings get settings;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  PlatformSettingsChange._();

  factory PlatformSettingsChange([void updates(PlatformSettingsChangeBuilder b)]) = _$PlatformSettingsChange;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PlatformSettingsChangeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PlatformSettingsChange> get serializer => _$PlatformSettingsChangeSerializer();
}

class _$PlatformSettingsChangeSerializer implements PrimitiveSerializer<PlatformSettingsChange> {
  @override
  final Iterable<Type> types = const [PlatformSettingsChange, _$PlatformSettingsChange];

  @override
  final String wireName = r'PlatformSettingsChange';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PlatformSettingsChange object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'settings';
    yield serializers.serialize(
      object.settings,
      specifiedType: const FullType(PlatformSettings),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PlatformSettingsChange object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PlatformSettingsChangeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'settings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PlatformSettings),
          ) as PlatformSettings;
          result.settings.replace(valueDes);
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PlatformSettingsChange deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PlatformSettingsChangeBuilder();
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


