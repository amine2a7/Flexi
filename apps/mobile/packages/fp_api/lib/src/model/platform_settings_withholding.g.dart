// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_settings_withholding.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PlatformSettingsWithholding extends PlatformSettingsWithholding {
  @override
  final int thresholdMillimes;
  @override
  final int ppCinBps;
  @override
  final int ppMfBps;
  @override
  final int pmMfBps;

  factory _$PlatformSettingsWithholding([
    void Function(PlatformSettingsWithholdingBuilder)? updates,
  ]) => (PlatformSettingsWithholdingBuilder()..update(updates))._build();

  _$PlatformSettingsWithholding._({
    required this.thresholdMillimes,
    required this.ppCinBps,
    required this.ppMfBps,
    required this.pmMfBps,
  }) : super._();
  @override
  PlatformSettingsWithholding rebuild(
    void Function(PlatformSettingsWithholdingBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  PlatformSettingsWithholdingBuilder toBuilder() =>
      PlatformSettingsWithholdingBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PlatformSettingsWithholding &&
        thresholdMillimes == other.thresholdMillimes &&
        ppCinBps == other.ppCinBps &&
        ppMfBps == other.ppMfBps &&
        pmMfBps == other.pmMfBps;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, thresholdMillimes.hashCode);
    _$hash = $jc(_$hash, ppCinBps.hashCode);
    _$hash = $jc(_$hash, ppMfBps.hashCode);
    _$hash = $jc(_$hash, pmMfBps.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PlatformSettingsWithholding')
          ..add('thresholdMillimes', thresholdMillimes)
          ..add('ppCinBps', ppCinBps)
          ..add('ppMfBps', ppMfBps)
          ..add('pmMfBps', pmMfBps))
        .toString();
  }
}

class PlatformSettingsWithholdingBuilder
    implements
        Builder<
          PlatformSettingsWithholding,
          PlatformSettingsWithholdingBuilder
        > {
  _$PlatformSettingsWithholding? _$v;

  int? _thresholdMillimes;
  int? get thresholdMillimes => _$this._thresholdMillimes;
  set thresholdMillimes(int? thresholdMillimes) =>
      _$this._thresholdMillimes = thresholdMillimes;

  int? _ppCinBps;
  int? get ppCinBps => _$this._ppCinBps;
  set ppCinBps(int? ppCinBps) => _$this._ppCinBps = ppCinBps;

  int? _ppMfBps;
  int? get ppMfBps => _$this._ppMfBps;
  set ppMfBps(int? ppMfBps) => _$this._ppMfBps = ppMfBps;

  int? _pmMfBps;
  int? get pmMfBps => _$this._pmMfBps;
  set pmMfBps(int? pmMfBps) => _$this._pmMfBps = pmMfBps;

  PlatformSettingsWithholdingBuilder() {
    PlatformSettingsWithholding._defaults(this);
  }

  PlatformSettingsWithholdingBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _thresholdMillimes = $v.thresholdMillimes;
      _ppCinBps = $v.ppCinBps;
      _ppMfBps = $v.ppMfBps;
      _pmMfBps = $v.pmMfBps;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PlatformSettingsWithholding other) {
    _$v = other as _$PlatformSettingsWithholding;
  }

  @override
  void update(void Function(PlatformSettingsWithholdingBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PlatformSettingsWithholding build() => _build();

  _$PlatformSettingsWithholding _build() {
    final _$result =
        _$v ??
        _$PlatformSettingsWithholding._(
          thresholdMillimes: BuiltValueNullFieldError.checkNotNull(
            thresholdMillimes,
            r'PlatformSettingsWithholding',
            'thresholdMillimes',
          ),
          ppCinBps: BuiltValueNullFieldError.checkNotNull(
            ppCinBps,
            r'PlatformSettingsWithholding',
            'ppCinBps',
          ),
          ppMfBps: BuiltValueNullFieldError.checkNotNull(
            ppMfBps,
            r'PlatformSettingsWithholding',
            'ppMfBps',
          ),
          pmMfBps: BuiltValueNullFieldError.checkNotNull(
            pmMfBps,
            r'PlatformSettingsWithholding',
            'pmMfBps',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
