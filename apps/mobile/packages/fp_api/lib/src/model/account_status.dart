//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'account_status.g.dart';

/// Compte (cahier §8) — En attente KYC, Validé, Rejeté, Suspendu. Un compte reste **inactif** (aucune opération métier) tant que son dossier KYC n'est pas validé (`APPROVED`). 
class AccountStatus extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PENDING_KYC')
  static const AccountStatus PENDING_KYC = _$PENDING_KYC;
  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const AccountStatus APPROVED = _$APPROVED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const AccountStatus REJECTED = _$REJECTED;
  @BuiltValueEnumConst(wireName: r'SUSPENDED')
  static const AccountStatus SUSPENDED = _$SUSPENDED;

  static Serializer<AccountStatus> get serializer => _$accountStatusSerializer;

  const AccountStatus._(String name): super(name);

  static BuiltSet<AccountStatus> get values => _$values;
  static AccountStatus valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class AccountStatusMixin = Object with _$AccountStatusMixin;

