// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'legal_form.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const LegalForm _$PP_CIN = const LegalForm._('PP_CIN');
const LegalForm _$PP_MF = const LegalForm._('PP_MF');
const LegalForm _$PM_MF = const LegalForm._('PM_MF');

LegalForm _$valueOf(String name) {
  switch (name) {
    case 'PP_CIN':
      return _$PP_CIN;
    case 'PP_MF':
      return _$PP_MF;
    case 'PM_MF':
      return _$PM_MF;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<LegalForm> _$values = BuiltSet<LegalForm>(const <LegalForm>[
  _$PP_CIN,
  _$PP_MF,
  _$PM_MF,
]);

class _$LegalFormMeta {
  const _$LegalFormMeta();
  LegalForm get PP_CIN => _$PP_CIN;
  LegalForm get PP_MF => _$PP_MF;
  LegalForm get PM_MF => _$PM_MF;
  LegalForm valueOf(String name) => _$valueOf(name);
  BuiltSet<LegalForm> get values => _$values;
}

mixin _$LegalFormMixin {
  // ignore: non_constant_identifier_names
  _$LegalFormMeta get LegalForm => const _$LegalFormMeta();
}

Serializer<LegalForm> _$legalFormSerializer = _$LegalFormSerializer();

class _$LegalFormSerializer implements PrimitiveSerializer<LegalForm> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PP_CIN': 'PP_CIN',
    'PP_MF': 'PP_MF',
    'PM_MF': 'PM_MF',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PP_CIN': 'PP_CIN',
    'PP_MF': 'PP_MF',
    'PM_MF': 'PM_MF',
  };

  @override
  final Iterable<Type> types = const <Type>[LegalForm];
  @override
  final String wireName = 'LegalForm';

  @override
  Object serialize(
    Serializers serializers,
    LegalForm object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  LegalForm deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => LegalForm.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
