//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/date.dart';
import 'package:fp_api/src/model/transfer_proof.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'transfer_declaration.g.dart';

/// TransferDeclaration
///
/// Properties:
/// * [transferReference] 
/// * [transferDate] - Date calendaire sans heure, dans le fuseau des règles métier `Africa/Tunis`.
/// * [amountMillimes] - Montant en millimes strictement positif (montant d'une opération demandée).
/// * [proof] 
/// * [declaredAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
@BuiltValue()
abstract class TransferDeclaration implements Built<TransferDeclaration, TransferDeclarationBuilder> {
  @BuiltValueField(wireName: r'transferReference')
  String get transferReference;

  /// Date calendaire sans heure, dans le fuseau des règles métier `Africa/Tunis`.
  @BuiltValueField(wireName: r'transferDate')
  Date get transferDate;

  /// Montant en millimes strictement positif (montant d'une opération demandée).
  @BuiltValueField(wireName: r'amountMillimes')
  int get amountMillimes;

  @BuiltValueField(wireName: r'proof')
  TransferProof get proof;

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'declaredAt')
  DateTime get declaredAt;

  TransferDeclaration._();

  factory TransferDeclaration([void updates(TransferDeclarationBuilder b)]) = _$TransferDeclaration;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TransferDeclarationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TransferDeclaration> get serializer => _$TransferDeclarationSerializer();
}

class _$TransferDeclarationSerializer implements PrimitiveSerializer<TransferDeclaration> {
  @override
  final Iterable<Type> types = const [TransferDeclaration, _$TransferDeclaration];

  @override
  final String wireName = r'TransferDeclaration';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TransferDeclaration object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'transferReference';
    yield serializers.serialize(
      object.transferReference,
      specifiedType: const FullType(String),
    );
    yield r'transferDate';
    yield serializers.serialize(
      object.transferDate,
      specifiedType: const FullType(Date),
    );
    yield r'amountMillimes';
    yield serializers.serialize(
      object.amountMillimes,
      specifiedType: const FullType(int),
    );
    yield r'proof';
    yield serializers.serialize(
      object.proof,
      specifiedType: const FullType(TransferProof),
    );
    yield r'declaredAt';
    yield serializers.serialize(
      object.declaredAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TransferDeclaration object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TransferDeclarationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'transferReference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.transferReference = valueDes;
          break;
        case r'transferDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.transferDate = valueDes;
          break;
        case r'amountMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.amountMillimes = valueDes;
          break;
        case r'proof':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TransferProof),
          ) as TransferProof;
          result.proof.replace(valueDes);
          break;
        case r'declaredAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.declaredAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TransferDeclaration deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TransferDeclarationBuilder();
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


