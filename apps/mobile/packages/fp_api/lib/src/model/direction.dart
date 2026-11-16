//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'direction.g.dart';

/// Sens d'un mouvement (les montants ne sont jamais négatifs).
class Direction extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DEBIT')
  static const Direction DEBIT = _$DEBIT;
  @BuiltValueEnumConst(wireName: r'CREDIT')
  static const Direction CREDIT = _$CREDIT;

  static Serializer<Direction> get serializer => _$directionSerializer;

  const Direction._(String name): super(name);

  static BuiltSet<Direction> get values => _$values;
  static Direction valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class DirectionMixin = Object with _$DirectionMixin;

