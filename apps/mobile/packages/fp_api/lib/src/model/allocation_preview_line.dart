//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/credit_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'allocation_preview_line.g.dart';

/// AllocationPreviewLine
///
/// Properties:
/// * [creditType] 
/// * [perEmployeeMillimes] - Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
/// * [totalMillimes] - Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
/// * [balanceMillimes] - Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
/// * [remainingMillimes] - Solde du type après l'attribution (0 s'il manque de l'argent).
/// * [missingMillimes] - Montant manquant (affiché en rouge), 0 si le solde suffit.
@BuiltValue()
abstract class AllocationPreviewLine implements Built<AllocationPreviewLine, AllocationPreviewLineBuilder> {
  @BuiltValueField(wireName: r'creditType')
  CreditType get creditType;
  // enum creditTypeEnum {  RESTAURATION,  HABILLEMENT,  CARBURANT,  CADEAUX,  };

  /// Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
  @BuiltValueField(wireName: r'perEmployeeMillimes')
  int get perEmployeeMillimes;

  /// Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
  @BuiltValueField(wireName: r'totalMillimes')
  int get totalMillimes;

  /// Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
  @BuiltValueField(wireName: r'balanceMillimes')
  int get balanceMillimes;

  /// Solde du type après l'attribution (0 s'il manque de l'argent).
  @BuiltValueField(wireName: r'remainingMillimes')
  int get remainingMillimes;

  /// Montant manquant (affiché en rouge), 0 si le solde suffit.
  @BuiltValueField(wireName: r'missingMillimes')
  int get missingMillimes;

  AllocationPreviewLine._();

  factory AllocationPreviewLine([void updates(AllocationPreviewLineBuilder b)]) = _$AllocationPreviewLine;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AllocationPreviewLineBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AllocationPreviewLine> get serializer => _$AllocationPreviewLineSerializer();
}

class _$AllocationPreviewLineSerializer implements PrimitiveSerializer<AllocationPreviewLine> {
  @override
  final Iterable<Type> types = const [AllocationPreviewLine, _$AllocationPreviewLine];

  @override
  final String wireName = r'AllocationPreviewLine';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AllocationPreviewLine object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'creditType';
    yield serializers.serialize(
      object.creditType,
      specifiedType: const FullType(CreditType),
    );
    yield r'perEmployeeMillimes';
    yield serializers.serialize(
      object.perEmployeeMillimes,
      specifiedType: const FullType(int),
    );
    yield r'totalMillimes';
    yield serializers.serialize(
      object.totalMillimes,
      specifiedType: const FullType(int),
    );
    yield r'balanceMillimes';
    yield serializers.serialize(
      object.balanceMillimes,
      specifiedType: const FullType(int),
    );
    yield r'remainingMillimes';
    yield serializers.serialize(
      object.remainingMillimes,
      specifiedType: const FullType(int),
    );
    yield r'missingMillimes';
    yield serializers.serialize(
      object.missingMillimes,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AllocationPreviewLine object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AllocationPreviewLineBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'creditType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CreditType),
          ) as CreditType;
          result.creditType = valueDes;
          break;
        case r'perEmployeeMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.perEmployeeMillimes = valueDes;
          break;
        case r'totalMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalMillimes = valueDes;
          break;
        case r'balanceMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.balanceMillimes = valueDes;
          break;
        case r'remainingMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.remainingMillimes = valueDes;
          break;
        case r'missingMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.missingMillimes = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AllocationPreviewLine deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AllocationPreviewLineBuilder();
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


