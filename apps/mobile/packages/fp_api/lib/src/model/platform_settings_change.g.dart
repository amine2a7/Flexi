// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_settings_change.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PlatformSettingsChange extends PlatformSettingsChange {
  @override
  final PlatformSettings settings;
  @override
  final String reason;

  factory _$PlatformSettingsChange([
    void Function(PlatformSettingsChangeBuilder)? updates,
  ]) => (PlatformSettingsChangeBuilder()..update(updates))._build();

  _$PlatformSettingsChange._({required this.settings, required this.reason})
    : super._();
  @override
  PlatformSettingsChange rebuild(
    void Function(PlatformSettingsChangeBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  PlatformSettingsChangeBuilder toBuilder() =>
      PlatformSettingsChangeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PlatformSettingsChange &&
        settings == other.settings &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, settings.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PlatformSettingsChange')
          ..add('settings', settings)
          ..add('reason', reason))
        .toString();
  }
}

class PlatformSettingsChangeBuilder
    implements Builder<PlatformSettingsChange, PlatformSettingsChangeBuilder> {
  _$PlatformSettingsChange? _$v;

  PlatformSettingsBuilder? _settings;
  PlatformSettingsBuilder get settings =>
      _$this._settings ??= PlatformSettingsBuilder();
  set settings(PlatformSettingsBuilder? settings) =>
      _$this._settings = settings;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  PlatformSettingsChangeBuilder() {
    PlatformSettingsChange._defaults(this);
  }

  PlatformSettingsChangeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _settings = $v.settings.toBuilder();
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PlatformSettingsChange other) {
    _$v = other as _$PlatformSettingsChange;
  }

  @override
  void update(void Function(PlatformSettingsChangeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PlatformSettingsChange build() => _build();

  _$PlatformSettingsChange _build() {
    _$PlatformSettingsChange _$result;
    try {
      _$result =
          _$v ??
          _$PlatformSettingsChange._(
            settings: settings.build(),
            reason: BuiltValueNullFieldError.checkNotNull(
              reason,
              r'PlatformSettingsChange',
              'reason',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'settings';
        settings.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'PlatformSettingsChange',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
