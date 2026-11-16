//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/kyc_status.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'overview_kyc.g.dart';

/// OverviewKyc
///
/// Properties:
/// * [fileId] - Identifiant opaque de ressource.
/// * [status] 
@BuiltValue()
abstract class OverviewKyc implements Built<OverviewKyc, OverviewKycBuilder> {
  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'fileId')
  String get fileId;

  @BuiltValueField(wireName: r'status')
  KycStatus get status;
  // enum statusEnum {  PENDING,  APPROVED,  REJECTED,  };

  OverviewKyc._();

  factory OverviewKyc([void updates(OverviewKycBuilder b)]) = _$OverviewKyc;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OverviewKycBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OverviewKyc> get serializer => _$OverviewKycSerializer();
}

class _$OverviewKycSerializer implements PrimitiveSerializer<OverviewKyc> {
  @override
  final Iterable<Type> types = const [OverviewKyc, _$OverviewKyc];

  @override
  final String wireName = r'OverviewKyc';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OverviewKyc object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'fileId';
    yield serializers.serialize(
      object.fileId,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(KycStatus),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OverviewKyc object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OverviewKycBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'fileId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fileId = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(KycStatus),
          ) as KycStatus;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OverviewKyc deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OverviewKycBuilder();
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


