//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/temporary_credentials.dart';
import 'package:fp_api/src/model/legal_form.dart';
import 'package:fp_api/src/model/account_status.dart';
import 'package:fp_api/src/model/commission_grid.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'company_account.g.dart';

/// CompanyAccount
///
/// Properties:
/// * [credentials] 
/// * [legalForm] 
/// * [id] - Identifiant opaque de ressource.
/// * [name] 
/// * [city] 
/// * [status] 
/// * [employeesCount] 
/// * [commissionGrid] - Grille de commission de l'entreprise (taux sur le montant de chaque commande). Jamais `null` après la migration 0025 : sans grille, la commande est refusée (`422 COMMISSION_GRID_MISSING`) et une alerte est levée. 
/// * [createdAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
@BuiltValue()
abstract class CompanyAccount implements Built<CompanyAccount, CompanyAccountBuilder> {
  @BuiltValueField(wireName: r'credentials')
  TemporaryCredentials? get credentials;

  @BuiltValueField(wireName: r'legalForm')
  LegalForm get legalForm;
  // enum legalFormEnum {  PP_CIN,  PP_MF,  PM_MF,  };

  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'city')
  String get city;

  @BuiltValueField(wireName: r'status')
  AccountStatus get status;
  // enum statusEnum {  PENDING_KYC,  APPROVED,  REJECTED,  SUSPENDED,  };

  @BuiltValueField(wireName: r'employeesCount')
  int get employeesCount;

  /// Grille de commission de l'entreprise (taux sur le montant de chaque commande). Jamais `null` après la migration 0025 : sans grille, la commande est refusée (`422 COMMISSION_GRID_MISSING`) et une alerte est levée. 
  @BuiltValueField(wireName: r'commissionGrid')
  CommissionGrid? get commissionGrid;

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  CompanyAccount._();

  factory CompanyAccount([void updates(CompanyAccountBuilder b)]) = _$CompanyAccount;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CompanyAccountBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CompanyAccount> get serializer => _$CompanyAccountSerializer();
}

class _$CompanyAccountSerializer implements PrimitiveSerializer<CompanyAccount> {
  @override
  final Iterable<Type> types = const [CompanyAccount, _$CompanyAccount];

  @override
  final String wireName = r'CompanyAccount';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CompanyAccount object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.credentials != null) {
      yield r'credentials';
      yield serializers.serialize(
        object.credentials,
        specifiedType: const FullType(TemporaryCredentials),
      );
    }
    yield r'legalForm';
    yield serializers.serialize(
      object.legalForm,
      specifiedType: const FullType(LegalForm),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
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
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AccountStatus),
    );
    yield r'employeesCount';
    yield serializers.serialize(
      object.employeesCount,
      specifiedType: const FullType(int),
    );
    yield r'commissionGrid';
    yield object.commissionGrid == null ? null : serializers.serialize(
      object.commissionGrid,
      specifiedType: const FullType.nullable(CommissionGrid),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CompanyAccount object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CompanyAccountBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'credentials':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(TemporaryCredentials),
          ) as TemporaryCredentials?;
          if (valueDes == null) continue;
          result.credentials.replace(valueDes);
          break;
        case r'legalForm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(LegalForm),
          ) as LegalForm;
          result.legalForm = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
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
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AccountStatus),
          ) as AccountStatus;
          result.status = valueDes;
          break;
        case r'employeesCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.employeesCount = valueDes;
          break;
        case r'commissionGrid':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CommissionGrid),
          ) as CommissionGrid?;
          if (valueDes == null) continue;
          result.commissionGrid.replace(valueDes);
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CompanyAccount deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CompanyAccountBuilder();
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


