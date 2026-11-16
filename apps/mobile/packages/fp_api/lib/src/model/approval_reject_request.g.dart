// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'approval_reject_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApprovalRejectRequest extends ApprovalRejectRequest {
  @override
  final String reason;

  factory _$ApprovalRejectRequest([
    void Function(ApprovalRejectRequestBuilder)? updates,
  ]) => (ApprovalRejectRequestBuilder()..update(updates))._build();

  _$ApprovalRejectRequest._({required this.reason}) : super._();
  @override
  ApprovalRejectRequest rebuild(
    void Function(ApprovalRejectRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApprovalRejectRequestBuilder toBuilder() =>
      ApprovalRejectRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApprovalRejectRequest && reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'ApprovalRejectRequest',
    )..add('reason', reason)).toString();
  }
}

class ApprovalRejectRequestBuilder
    implements Builder<ApprovalRejectRequest, ApprovalRejectRequestBuilder> {
  _$ApprovalRejectRequest? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  ApprovalRejectRequestBuilder() {
    ApprovalRejectRequest._defaults(this);
  }

  ApprovalRejectRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApprovalRejectRequest other) {
    _$v = other as _$ApprovalRejectRequest;
  }

  @override
  void update(void Function(ApprovalRejectRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApprovalRejectRequest build() => _build();

  _$ApprovalRejectRequest _build() {
    final _$result =
        _$v ??
        _$ApprovalRejectRequest._(
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'ApprovalRejectRequest',
            'reason',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
