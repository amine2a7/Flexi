// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'confirm_payment_request403_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ConfirmPaymentRequest403Response
    extends ConfirmPaymentRequest403Response {
  @override
  final OneOf oneOf;

  factory _$ConfirmPaymentRequest403Response([
    void Function(ConfirmPaymentRequest403ResponseBuilder)? updates,
  ]) => (ConfirmPaymentRequest403ResponseBuilder()..update(updates))._build();

  _$ConfirmPaymentRequest403Response._({required this.oneOf}) : super._();
  @override
  ConfirmPaymentRequest403Response rebuild(
    void Function(ConfirmPaymentRequest403ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ConfirmPaymentRequest403ResponseBuilder toBuilder() =>
      ConfirmPaymentRequest403ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ConfirmPaymentRequest403Response && oneOf == other.oneOf;
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
      r'ConfirmPaymentRequest403Response',
    )..add('oneOf', oneOf)).toString();
  }
}

class ConfirmPaymentRequest403ResponseBuilder
    implements
        Builder<
          ConfirmPaymentRequest403Response,
          ConfirmPaymentRequest403ResponseBuilder
        > {
  _$ConfirmPaymentRequest403Response? _$v;

  OneOf? _oneOf;
  OneOf? get oneOf => _$this._oneOf;
  set oneOf(OneOf? oneOf) => _$this._oneOf = oneOf;

  ConfirmPaymentRequest403ResponseBuilder() {
    ConfirmPaymentRequest403Response._defaults(this);
  }

  ConfirmPaymentRequest403ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _oneOf = $v.oneOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ConfirmPaymentRequest403Response other) {
    _$v = other as _$ConfirmPaymentRequest403Response;
  }

  @override
  void update(void Function(ConfirmPaymentRequest403ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ConfirmPaymentRequest403Response build() => _build();

  _$ConfirmPaymentRequest403Response _build() {
    final _$result =
        _$v ??
        _$ConfirmPaymentRequest403Response._(
          oneOf: BuiltValueNullFieldError.checkNotNull(
            oneOf,
            r'ConfirmPaymentRequest403Response',
            'oneOf',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
