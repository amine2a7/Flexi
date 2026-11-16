//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/kyc_status.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/kyc_piece.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'my_kyc_file.g.dart';

/// Dossier KYC du client connecté (Compte › Mon dossier).
///
/// Properties:
/// * [id] - Identifiant opaque de ressource.
/// * [status] 
/// * [rejectionReason] 
/// * [documents] 
@BuiltValue()
abstract class MyKycFile implements Built<MyKycFile, MyKycFileBuilder> {
  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'status')
  KycStatus get status;
  // enum statusEnum {  PENDING,  APPROVED,  REJECTED,  };

  @BuiltValueField(wireName: r'rejectionReason')
  String? get rejectionReason;

  @BuiltValueField(wireName: r'documents')
  BuiltList<KycPiece> get documents;

  MyKycFile._();

  factory MyKycFile([void updates(MyKycFileBuilder b)]) = _$MyKycFile;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MyKycFileBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MyKycFile> get serializer => _$MyKycFileSerializer();
}

class _$MyKycFileSerializer implements PrimitiveSerializer<MyKycFile> {
  @override
  final Iterable<Type> types = const [MyKycFile, _$MyKycFile];

  @override
  final String wireName = r'MyKycFile';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MyKycFile object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(KycStatus),
    );
    if (object.rejectionReason != null) {
      yield r'rejectionReason';
      yield serializers.serialize(
        object.rejectionReason,
        specifiedType: const FullType(String),
      );
    }
    yield r'documents';
    yield serializers.serialize(
      object.documents,
      specifiedType: const FullType(BuiltList, [FullType(KycPiece)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MyKycFile object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MyKycFileBuilder result,
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
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(KycStatus),
          ) as KycStatus;
          result.status = valueDes;
          break;
        case r'rejectionReason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.rejectionReason = valueDes;
          break;
        case r'documents':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(KycPiece)]),
          ) as BuiltList<KycPiece>;
          result.documents.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MyKycFile deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MyKycFileBuilder();
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


