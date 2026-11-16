// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payout_request_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PayoutRequestCreate extends PayoutRequestCreate {
  @override
  final String quoteId;

  factory _$PayoutRequestCreate([
    void Function(PayoutRequestCreateBuilder)? updates,
  ]) => (PayoutRequestCreateBuilder()..update(updates))._build();

  _$PayoutRequestCreate._({required this.quoteId}) : super._();
  @override
  PayoutRequestCreate rebuild(
    void Function(PayoutRequestCreateBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  PayoutRequestCreateBuilder toBuilder() =>
      PayoutRequestCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PayoutRequestCreate && quoteId == other.quoteId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, quoteId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'PayoutRequestCreate',
    )..add('quoteId', quoteId)).toString();
  }
}

class PayoutRequestCreateBuilder
    implements Builder<PayoutRequestCreate, PayoutRequestCreateBuilder> {
  _$PayoutRequestCreate? _$v;

  String? _quoteId;
  String? get quoteId => _$this._quoteId;
  set quoteId(String? quoteId) => _$this._quoteId = quoteId;

  PayoutRequestCreateBuilder() {
    PayoutRequestCreate._defaults(this);
  }

  PayoutRequestCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _quoteId = $v.quoteId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PayoutRequestCreate other) {
    _$v = other as _$PayoutRequestCreate;
  }

  @override
  void update(void Function(PayoutRequestCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PayoutRequestCreate build() => _build();

  _$PayoutRequestCreate _build() {
    final _$result =
        _$v ??
        _$PayoutRequestCreate._(
          quoteId: BuiltValueNullFieldError.checkNotNull(
            quoteId,
            r'PayoutRequestCreate',
            'quoteId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
