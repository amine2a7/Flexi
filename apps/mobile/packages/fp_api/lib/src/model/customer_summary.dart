//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_summary.g.dart';

/// Client vu par le commerçant : prénom, initiale, matricule masqué (COM-04). Jamais de solde.
///
/// Properties:
/// * [firstName] 
/// * [lastInitial] 
/// * [maskedEmployeeNumber] - Matricule masqué (4 derniers caractères).
@BuiltValue()
abstract class CustomerSummary implements Built<CustomerSummary, CustomerSummaryBuilder> {
  @BuiltValueField(wireName: r'firstName')
  String get firstName;

  @BuiltValueField(wireName: r'lastInitial')
  String get lastInitial;

  /// Matricule masqué (4 derniers caractères).
  @BuiltValueField(wireName: r'maskedEmployeeNumber')
  String get maskedEmployeeNumber;

  CustomerSummary._();

  factory CustomerSummary([void updates(CustomerSummaryBuilder b)]) = _$CustomerSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerSummary> get serializer => _$CustomerSummarySerializer();
}

class _$CustomerSummarySerializer implements PrimitiveSerializer<CustomerSummary> {
  @override
  final Iterable<Type> types = const [CustomerSummary, _$CustomerSummary];

  @override
  final String wireName = r'CustomerSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'firstName';
    yield serializers.serialize(
      object.firstName,
      specifiedType: const FullType(String),
    );
    yield r'lastInitial';
    yield serializers.serialize(
      object.lastInitial,
      specifiedType: const FullType(String),
    );
    yield r'maskedEmployeeNumber';
    yield serializers.serialize(
      object.maskedEmployeeNumber,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CustomerSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'firstName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.firstName = valueDes;
          break;
        case r'lastInitial':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.lastInitial = valueDes;
          break;
        case r'maskedEmployeeNumber':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.maskedEmployeeNumber = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerSummaryBuilder();
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


