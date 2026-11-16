//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/commission_tier.dart';
import 'package:fp_api/src/model/legal_form.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'company_create.g.dart';

/// CompanyCreate
///
/// Properties:
/// * [legalForm] 
/// * [name] 
/// * [city] 
/// * [phone] - Numéro tunisien au format E.164.
/// * [email] 
/// * [commissionGrid] - Grille de commission saisie à la création (étape 2, fenêtre « Commission »).
@BuiltValue()
abstract class CompanyCreate implements Built<CompanyCreate, CompanyCreateBuilder> {
  @BuiltValueField(wireName: r'legalForm')
  LegalForm get legalForm;
  // enum legalFormEnum {  PP_CIN,  PP_MF,  PM_MF,  };

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'city')
  String get city;

  /// Numéro tunisien au format E.164.
  @BuiltValueField(wireName: r'phone')
  String get phone;

  @BuiltValueField(wireName: r'email')
  String get email;

  /// Grille de commission saisie à la création (étape 2, fenêtre « Commission »).
  @BuiltValueField(wireName: r'commissionGrid')
  BuiltList<CommissionTier> get commissionGrid;

  CompanyCreate._();

  factory CompanyCreate([void updates(CompanyCreateBuilder b)]) = _$CompanyCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CompanyCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CompanyCreate> get serializer => _$CompanyCreateSerializer();
}

class _$CompanyCreateSerializer implements PrimitiveSerializer<CompanyCreate> {
  @override
  final Iterable<Type> types = const [CompanyCreate, _$CompanyCreate];

  @override
  final String wireName = r'CompanyCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CompanyCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'legalForm';
    yield serializers.serialize(
      object.legalForm,
      specifiedType: const FullType(LegalForm),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'city';
    yield serializers.serialize(
      object.city,
      specifiedType: const FullType(String),
    );
    yield r'phone';
    yield serializers.serialize(
      object.phone,
      specifiedType: const FullType(String),
    );
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'commissionGrid';
    yield serializers.serialize(
      object.commissionGrid,
      specifiedType: const FullType(BuiltList, [FullType(CommissionTier)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CompanyCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CompanyCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'legalForm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(LegalForm),
          ) as LegalForm;
          result.legalForm = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'city':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.city = valueDes;
          break;
        case r'phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.phone = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'commissionGrid':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CommissionTier)]),
          ) as BuiltList<CommissionTier>;
          result.commissionGrid.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CompanyCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CompanyCreateBuilder();
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


