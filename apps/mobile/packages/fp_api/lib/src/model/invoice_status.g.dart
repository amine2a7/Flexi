// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const InvoiceStatus _$PAID = const InvoiceStatus._('PAID');
const InvoiceStatus _$UNPAID = const InvoiceStatus._('UNPAID');
const InvoiceStatus _$CANCELLED = const InvoiceStatus._('CANCELLED');

InvoiceStatus _$valueOf(String name) {
  switch (name) {
    case 'PAID':
      return _$PAID;
    case 'UNPAID':
      return _$UNPAID;
    case 'CANCELLED':
      return _$CANCELLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<InvoiceStatus> _$values = BuiltSet<InvoiceStatus>(
  const <InvoiceStatus>[_$PAID, _$UNPAID, _$CANCELLED],
);

class _$InvoiceStatusMeta {
  const _$InvoiceStatusMeta();
  InvoiceStatus get PAID => _$PAID;
  InvoiceStatus get UNPAID => _$UNPAID;
  InvoiceStatus get CANCELLED => _$CANCELLED;
  InvoiceStatus valueOf(String name) => _$valueOf(name);
  BuiltSet<InvoiceStatus> get values => _$values;
}

mixin _$InvoiceStatusMixin {
  // ignore: non_constant_identifier_names
  _$InvoiceStatusMeta get InvoiceStatus => const _$InvoiceStatusMeta();
}

Serializer<InvoiceStatus> _$invoiceStatusSerializer =
    _$InvoiceStatusSerializer();

class _$InvoiceStatusSerializer implements PrimitiveSerializer<InvoiceStatus> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PAID': 'PAID',
    'UNPAID': 'UNPAID',
    'CANCELLED': 'CANCELLED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PAID': 'PAID',
    'UNPAID': 'UNPAID',
    'CANCELLED': 'CANCELLED',
  };

  @override
  final Iterable<Type> types = const <Type>[InvoiceStatus];
  @override
  final String wireName = 'InvoiceStatus';

  @override
  Object serialize(
    Serializers serializers,
    InvoiceStatus object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  InvoiceStatus deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => InvoiceStatus.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
