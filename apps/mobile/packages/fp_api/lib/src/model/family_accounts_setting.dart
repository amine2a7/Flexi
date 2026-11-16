//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'family_accounts_setting.g.dart';

/// FamilyAccountsSetting
///
/// Properties:
/// * [enabled] 
@BuiltValue()
abstract class FamilyAccountsSetting implements Built<FamilyAccountsSetting, FamilyAccountsSettingBuilder> {
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  FamilyAccountsSetting._();

  factory FamilyAccountsSetting([void updates(FamilyAccountsSettingBuilder b)]) = _$FamilyAccountsSetting;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FamilyAccountsSettingBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FamilyAccountsSetting> get serializer => _$FamilyAccountsSettingSerializer();
}

class _$FamilyAccountsSettingSerializer implements PrimitiveSerializer<FamilyAccountsSetting> {
  @override
  final Iterable<Type> types = const [FamilyAccountsSetting, _$FamilyAccountsSetting];

  @override
  final String wireName = r'FamilyAccountsSetting';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FamilyAccountsSetting object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FamilyAccountsSetting object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FamilyAccountsSettingBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FamilyAccountsSetting deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FamilyAccountsSettingBuilder();
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


