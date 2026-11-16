// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iban_change_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$IbanChangeRequest extends IbanChangeRequest {
  @override
  final String iban;
  @override
  final String reason;

  factory _$IbanChangeRequest([
    void Function(IbanChangeRequestBuilder)? updates,
  ]) => (IbanChangeRequestBuilder()..update(updates))._build();

  _$IbanChangeRequest._({required this.iban, required this.reason}) : super._();
  @override
  IbanChangeRequest rebuild(void Function(IbanChangeRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  IbanChangeRequestBuilder toBuilder() =>
      IbanChangeRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is IbanChangeRequest &&
        iban == other.iban &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, iban.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'IbanChangeRequest')
          ..add('iban', iban)
          ..add('reason', reason))
        .toString();
  }
}

class IbanChangeRequestBuilder
    implements Builder<IbanChangeRequest, IbanChangeRequestBuilder> {
  _$IbanChangeRequest? _$v;

  String? _iban;
  String? get iban => _$this._iban;
  set iban(String? iban) => _$this._iban = iban;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  IbanChangeRequestBuilder() {
    IbanChangeRequest._defaults(this);
  }

  IbanChangeRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _iban = $v.iban;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(IbanChangeRequest other) {
    _$v = other as _$IbanChangeRequest;
  }

  @override
  void update(void Function(IbanChangeRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  IbanChangeRequest build() => _build();

  _$IbanChangeRequest _build() {
    final _$result =
        _$v ??
        _$IbanChangeRequest._(
          iban: BuiltValueNullFieldError.checkNotNull(
            iban,
            r'IbanChangeRequest',
            'iban',
          ),
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'IbanChangeRequest',
            'reason',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
