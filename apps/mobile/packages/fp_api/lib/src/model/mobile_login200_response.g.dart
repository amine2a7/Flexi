// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobile_login200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MobileLogin200ResponseNextStepEnum
_$mobileLogin200ResponseNextStepEnum_MFA_CHALLENGE =
    const MobileLogin200ResponseNextStepEnum._('MFA_CHALLENGE');

MobileLogin200ResponseNextStepEnum _$mobileLogin200ResponseNextStepEnumValueOf(
  String name,
) {
  switch (name) {
    case 'MFA_CHALLENGE':
      return _$mobileLogin200ResponseNextStepEnum_MFA_CHALLENGE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MobileLogin200ResponseNextStepEnum>
_$mobileLogin200ResponseNextStepEnumValues =
    BuiltSet<MobileLogin200ResponseNextStepEnum>(
      const <MobileLogin200ResponseNextStepEnum>[
        _$mobileLogin200ResponseNextStepEnum_MFA_CHALLENGE,
      ],
    );

Serializer<MobileLogin200ResponseNextStepEnum>
_$mobileLogin200ResponseNextStepEnumSerializer =
    _$MobileLogin200ResponseNextStepEnumSerializer();

class _$MobileLogin200ResponseNextStepEnumSerializer
    implements PrimitiveSerializer<MobileLogin200ResponseNextStepEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'MFA_CHALLENGE': 'MFA_CHALLENGE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'MFA_CHALLENGE': 'MFA_CHALLENGE',
  };

  @override
  final Iterable<Type> types = const <Type>[MobileLogin200ResponseNextStepEnum];
  @override
  final String wireName = 'MobileLogin200ResponseNextStepEnum';

  @override
  Object serialize(
    Serializers serializers,
    MobileLogin200ResponseNextStepEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MobileLogin200ResponseNextStepEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MobileLogin200ResponseNextStepEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MobileLogin200Response extends MobileLogin200Response {
  @override
  final OneOf oneOf;

  factory _$MobileLogin200Response([
    void Function(MobileLogin200ResponseBuilder)? updates,
  ]) => (MobileLogin200ResponseBuilder()..update(updates))._build();

  _$MobileLogin200Response._({required this.oneOf}) : super._();
  @override
  MobileLogin200Response rebuild(
    void Function(MobileLogin200ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MobileLogin200ResponseBuilder toBuilder() =>
      MobileLogin200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MobileLogin200Response && oneOf == other.oneOf;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, oneOf.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'MobileLogin200Response',
    )..add('oneOf', oneOf)).toString();
  }
}

class MobileLogin200ResponseBuilder
    implements Builder<MobileLogin200Response, MobileLogin200ResponseBuilder> {
  _$MobileLogin200Response? _$v;

  OneOf? _oneOf;
  OneOf? get oneOf => _$this._oneOf;
  set oneOf(OneOf? oneOf) => _$this._oneOf = oneOf;

  MobileLogin200ResponseBuilder() {
    MobileLogin200Response._defaults(this);
  }

  MobileLogin200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _oneOf = $v.oneOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MobileLogin200Response other) {
    _$v = other as _$MobileLogin200Response;
  }

  @override
  void update(void Function(MobileLogin200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MobileLogin200Response build() => _build();

  _$MobileLogin200Response _build() {
    final _$result =
        _$v ??
        _$MobileLogin200Response._(
          oneOf: BuiltValueNullFieldError.checkNotNull(
            oneOf,
            r'MobileLogin200Response',
            'oneOf',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
