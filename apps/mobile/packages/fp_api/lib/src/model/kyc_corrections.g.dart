// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kyc_corrections.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$KycCorrections extends KycCorrections {
  @override
  final BuiltList<KycCorrectionsCorrectionsInner> corrections;

  factory _$KycCorrections([void Function(KycCorrectionsBuilder)? updates]) =>
      (KycCorrectionsBuilder()..update(updates))._build();

  _$KycCorrections._({required this.corrections}) : super._();
  @override
  KycCorrections rebuild(void Function(KycCorrectionsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  KycCorrectionsBuilder toBuilder() => KycCorrectionsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is KycCorrections && corrections == other.corrections;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, corrections.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'KycCorrections',
    )..add('corrections', corrections)).toString();
  }
}

class KycCorrectionsBuilder
    implements Builder<KycCorrections, KycCorrectionsBuilder> {
  _$KycCorrections? _$v;

  ListBuilder<KycCorrectionsCorrectionsInner>? _corrections;
  ListBuilder<KycCorrectionsCorrectionsInner> get corrections =>
      _$this._corrections ??= ListBuilder<KycCorrectionsCorrectionsInner>();
  set corrections(ListBuilder<KycCorrectionsCorrectionsInner>? corrections) =>
      _$this._corrections = corrections;

  KycCorrectionsBuilder() {
    KycCorrections._defaults(this);
  }

  KycCorrectionsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _corrections = $v.corrections.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(KycCorrections other) {
    _$v = other as _$KycCorrections;
  }

  @override
  void update(void Function(KycCorrectionsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  KycCorrections build() => _build();

  _$KycCorrections _build() {
    _$KycCorrections _$result;
    try {
      _$result = _$v ?? _$KycCorrections._(corrections: corrections.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'corrections';
        corrections.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'KycCorrections',
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
