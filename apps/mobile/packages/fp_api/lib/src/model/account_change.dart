//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'account_change.g.dart';

/// AccountChange
///
/// Properties:
/// * [occurredAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
/// * [actorName] 
/// * [fields] 
/// * [reason] 
@BuiltValue()
abstract class AccountChange implements Built<AccountChange, AccountChangeBuilder> {
  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'occurredAt')
  DateTime get occurredAt;

  @BuiltValueField(wireName: r'actorName')
  String get actorName;

  @BuiltValueField(wireName: r'fields')
  BuiltList<AccountChangeFieldsEnum> get fields;
  // enum fieldsEnum {  name,  city,  address,  category,  phone,  email,  iban,  commissionGrid,  };

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  AccountChange._();

  factory AccountChange([void updates(AccountChangeBuilder b)]) = _$AccountChange;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AccountChangeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AccountChange> get serializer => _$AccountChangeSerializer();
}

class _$AccountChangeSerializer implements PrimitiveSerializer<AccountChange> {
  @override
  final Iterable<Type> types = const [AccountChange, _$AccountChange];

  @override
  final String wireName = r'AccountChange';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AccountChange object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    yield r'fields';
    yield serializers.serialize(
      object.fields,
      specifiedType: const FullType(BuiltList, [FullType(AccountChangeFieldsEnum)]),
    );
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AccountChange object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AccountChangeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'fields':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AccountChangeFieldsEnum)]),
          ) as BuiltList<AccountChangeFieldsEnum>;
          result.fields.replace(valueDes);
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
  AccountChange deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AccountChangeBuilder();
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


class AccountChangeFieldsEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'name')
  static const AccountChangeFieldsEnum fieldName = _$accountChangeFieldsEnum_fieldName;
  @BuiltValueEnumConst(wireName: r'city')
  static const AccountChangeFieldsEnum city = _$accountChangeFieldsEnum_city;
  @BuiltValueEnumConst(wireName: r'address')
  static const AccountChangeFieldsEnum address = _$accountChangeFieldsEnum_address;
  @BuiltValueEnumConst(wireName: r'category')
  static const AccountChangeFieldsEnum category = _$accountChangeFieldsEnum_category;
  @BuiltValueEnumConst(wireName: r'phone')
  static const AccountChangeFieldsEnum phone = _$accountChangeFieldsEnum_phone;
  @BuiltValueEnumConst(wireName: r'email')
  static const AccountChangeFieldsEnum email = _$accountChangeFieldsEnum_email;
  @BuiltValueEnumConst(wireName: r'iban')
  static const AccountChangeFieldsEnum iban = _$accountChangeFieldsEnum_iban;
  @BuiltValueEnumConst(wireName: r'commissionGrid')
  static const AccountChangeFieldsEnum commissionGrid = _$accountChangeFieldsEnum_commissionGrid;

  static Serializer<AccountChangeFieldsEnum> get serializer => _$accountChangeFieldsEnumSerializer;

  const AccountChangeFieldsEnum._(String name): super(name);

  static BuiltSet<AccountChangeFieldsEnum> get values => _$accountChangeFieldsEnumValues;
  static AccountChangeFieldsEnum valueOf(String name) => _$accountChangeFieldsEnumValueOf(name);
}

