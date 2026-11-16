// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pin_refused_problem_all_of_details.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PinRefusedProblemAllOfDetails extends PinRefusedProblemAllOfDetails {
  @override
  final int? retryAfterSeconds;
  @override
  final bool? reauthenticationRequired;

  factory _$PinRefusedProblemAllOfDetails([
    void Function(PinRefusedProblemAllOfDetailsBuilder)? updates,
  ]) => (PinRefusedProblemAllOfDetailsBuilder()..update(updates))._build();

  _$PinRefusedProblemAllOfDetails._({
    this.retryAfterSeconds,
    this.reauthenticationRequired,
  }) : super._();
  @override
  PinRefusedProblemAllOfDetails rebuild(
    void Function(PinRefusedProblemAllOfDetailsBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  PinRefusedProblemAllOfDetailsBuilder toBuilder() =>
      PinRefusedProblemAllOfDetailsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PinRefusedProblemAllOfDetails &&
        retryAfterSeconds == other.retryAfterSeconds &&
        reauthenticationRequired == other.reauthenticationRequired;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, retryAfterSeconds.hashCode);
    _$hash = $jc(_$hash, reauthenticationRequired.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PinRefusedProblemAllOfDetails')
          ..add('retryAfterSeconds', retryAfterSeconds)
          ..add('reauthenticationRequired', reauthenticationRequired))
        .toString();
  }
}

class PinRefusedProblemAllOfDetailsBuilder
    implements
        Builder<
          PinRefusedProblemAllOfDetails,
          PinRefusedProblemAllOfDetailsBuilder
        > {
  _$PinRefusedProblemAllOfDetails? _$v;

  int? _retryAfterSeconds;
  int? get retryAfterSeconds => _$this._retryAfterSeconds;
  set retryAfterSeconds(int? retryAfterSeconds) =>
      _$this._retryAfterSeconds = retryAfterSeconds;

  bool? _reauthenticationRequired;
  bool? get reauthenticationRequired => _$this._reauthenticationRequired;
  set reauthenticationRequired(bool? reauthenticationRequired) =>
      _$this._reauthenticationRequired = reauthenticationRequired;

  PinRefusedProblemAllOfDetailsBuilder() {
    PinRefusedProblemAllOfDetails._defaults(this);
  }

  PinRefusedProblemAllOfDetailsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _retryAfterSeconds = $v.retryAfterSeconds;
      _reauthenticationRequired = $v.reauthenticationRequired;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PinRefusedProblemAllOfDetails other) {
    _$v = other as _$PinRefusedProblemAllOfDetails;
  }

  @override
  void update(void Function(PinRefusedProblemAllOfDetailsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PinRefusedProblemAllOfDetails build() => _build();

  _$PinRefusedProblemAllOfDetails _build() {
    final _$result =
        _$v ??
        _$PinRefusedProblemAllOfDetails._(
          retryAfterSeconds: retryAfterSeconds,
          reauthenticationRequired: reauthenticationRequired,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
