// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'retry_after_details.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RetryAfterDetails extends RetryAfterDetails {
  @override
  final int retryAfterSeconds;

  factory _$RetryAfterDetails([
    void Function(RetryAfterDetailsBuilder)? updates,
  ]) => (RetryAfterDetailsBuilder()..update(updates))._build();

  _$RetryAfterDetails._({required this.retryAfterSeconds}) : super._();
  @override
  RetryAfterDetails rebuild(void Function(RetryAfterDetailsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RetryAfterDetailsBuilder toBuilder() =>
      RetryAfterDetailsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RetryAfterDetails &&
        retryAfterSeconds == other.retryAfterSeconds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, retryAfterSeconds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'RetryAfterDetails',
    )..add('retryAfterSeconds', retryAfterSeconds)).toString();
  }
}

class RetryAfterDetailsBuilder
    implements Builder<RetryAfterDetails, RetryAfterDetailsBuilder> {
  _$RetryAfterDetails? _$v;

  int? _retryAfterSeconds;
  int? get retryAfterSeconds => _$this._retryAfterSeconds;
  set retryAfterSeconds(int? retryAfterSeconds) =>
      _$this._retryAfterSeconds = retryAfterSeconds;

  RetryAfterDetailsBuilder() {
    RetryAfterDetails._defaults(this);
  }

  RetryAfterDetailsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _retryAfterSeconds = $v.retryAfterSeconds;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RetryAfterDetails other) {
    _$v = other as _$RetryAfterDetails;
  }

  @override
  void update(void Function(RetryAfterDetailsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RetryAfterDetails build() => _build();

  _$RetryAfterDetails _build() {
    final _$result =
        _$v ??
        _$RetryAfterDetails._(
          retryAfterSeconds: BuiltValueNullFieldError.checkNotNull(
            retryAfterSeconds,
            r'RetryAfterDetails',
            'retryAfterSeconds',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
