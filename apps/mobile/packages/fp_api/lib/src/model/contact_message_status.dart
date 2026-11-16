//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'contact_message_status.g.dart';

class ContactMessageStatus extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NEW')
  static const ContactMessageStatus NEW = _$NEW;
  @BuiltValueEnumConst(wireName: r'HANDLED')
  static const ContactMessageStatus HANDLED = _$HANDLED;

  static Serializer<ContactMessageStatus> get serializer => _$contactMessageStatusSerializer;

  const ContactMessageStatus._(String name): super(name);

  static BuiltSet<ContactMessageStatus> get values => _$values;
  static ContactMessageStatus valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class ContactMessageStatusMixin = Object with _$ContactMessageStatusMixin;

