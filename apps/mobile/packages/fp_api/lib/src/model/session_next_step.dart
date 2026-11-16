//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'session_next_step.g.dart';

/// Étape suivante d'une session ouverte (§10). `NONE` : session complète. `PASSWORD_CHANGE` : mot de passe temporaire à changer. `MFA_ENROLL` : MFA à enrôler. Liste extensible (valeur inconnue : renvoyer vers la connexion). 
class SessionNextStep extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NONE')
  static const SessionNextStep NONE = _$NONE;
  @BuiltValueEnumConst(wireName: r'PASSWORD_CHANGE')
  static const SessionNextStep PASSWORD_CHANGE = _$PASSWORD_CHANGE;
  @BuiltValueEnumConst(wireName: r'MFA_ENROLL')
  static const SessionNextStep MFA_ENROLL = _$MFA_ENROLL;

  static Serializer<SessionNextStep> get serializer => _$sessionNextStepSerializer;

  const SessionNextStep._(String name): super(name);

  static BuiltSet<SessionNextStep> get values => _$values;
  static SessionNextStep valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class SessionNextStepMixin = Object with _$SessionNextStepMixin;

