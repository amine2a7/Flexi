// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'limit_exceeded_problem_all_of_details.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LimitExceededProblemAllOfDetails
    extends LimitExceededProblemAllOfDetails {
  @override
  final LimitType limitType;
  @override
  final int remainingMillimes;

  factory _$LimitExceededProblemAllOfDetails([
    void Function(LimitExceededProblemAllOfDetailsBuilder)? updates,
  ]) => (LimitExceededProblemAllOfDetailsBuilder()..update(updates))._build();

  _$LimitExceededProblemAllOfDetails._({
    required this.limitType,
    required this.remainingMillimes,
  }) : super._();
  @override
  LimitExceededProblemAllOfDetails rebuild(
    void Function(LimitExceededProblemAllOfDetailsBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  LimitExceededProblemAllOfDetailsBuilder toBuilder() =>
      LimitExceededProblemAllOfDetailsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LimitExceededProblemAllOfDetails &&
        limitType == other.limitType &&
        remainingMillimes == other.remainingMillimes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, limitType.hashCode);
    _$hash = $jc(_$hash, remainingMillimes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LimitExceededProblemAllOfDetails')
          ..add('limitType', limitType)
          ..add('remainingMillimes', remainingMillimes))
        .toString();
  }
}

class LimitExceededProblemAllOfDetailsBuilder
    implements
        Builder<
          LimitExceededProblemAllOfDetails,
          LimitExceededProblemAllOfDetailsBuilder
        > {
  _$LimitExceededProblemAllOfDetails? _$v;

  LimitType? _limitType;
  LimitType? get limitType => _$this._limitType;
  set limitType(LimitType? limitType) => _$this._limitType = limitType;

  int? _remainingMillimes;
  int? get remainingMillimes => _$this._remainingMillimes;
  set remainingMillimes(int? remainingMillimes) =>
      _$this._remainingMillimes = remainingMillimes;

  LimitExceededProblemAllOfDetailsBuilder() {
    LimitExceededProblemAllOfDetails._defaults(this);
  }

  LimitExceededProblemAllOfDetailsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _limitType = $v.limitType;
      _remainingMillimes = $v.remainingMillimes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LimitExceededProblemAllOfDetails other) {
    _$v = other as _$LimitExceededProblemAllOfDetails;
  }

  @override
  void update(void Function(LimitExceededProblemAllOfDetailsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LimitExceededProblemAllOfDetails build() => _build();

  _$LimitExceededProblemAllOfDetails _build() {
    final _$result =
        _$v ??
        _$LimitExceededProblemAllOfDetails._(
          limitType: BuiltValueNullFieldError.checkNotNull(
            limitType,
            r'LimitExceededProblemAllOfDetails',
            'limitType',
          ),
          remainingMillimes: BuiltValueNullFieldError.checkNotNull(
            remainingMillimes,
            r'LimitExceededProblemAllOfDetails',
            'remainingMillimes',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
