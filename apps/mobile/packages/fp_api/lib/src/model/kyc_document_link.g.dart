// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kyc_document_link.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$KycDocumentLink extends KycDocumentLink {
  @override
  final String url;
  @override
  final int expires;
  @override
  final String signature;
  @override
  final DateTime expiresAt;

  factory _$KycDocumentLink([void Function(KycDocumentLinkBuilder)? updates]) =>
      (KycDocumentLinkBuilder()..update(updates))._build();

  _$KycDocumentLink._({
    required this.url,
    required this.expires,
    required this.signature,
    required this.expiresAt,
  }) : super._();
  @override
  KycDocumentLink rebuild(void Function(KycDocumentLinkBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  KycDocumentLinkBuilder toBuilder() => KycDocumentLinkBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is KycDocumentLink &&
        url == other.url &&
        expires == other.expires &&
        signature == other.signature &&
        expiresAt == other.expiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, expires.hashCode);
    _$hash = $jc(_$hash, signature.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'KycDocumentLink')
          ..add('url', url)
          ..add('expires', expires)
          ..add('signature', signature)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class KycDocumentLinkBuilder
    implements Builder<KycDocumentLink, KycDocumentLinkBuilder> {
  _$KycDocumentLink? _$v;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  int? _expires;
  int? get expires => _$this._expires;
  set expires(int? expires) => _$this._expires = expires;

  String? _signature;
  String? get signature => _$this._signature;
  set signature(String? signature) => _$this._signature = signature;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  KycDocumentLinkBuilder() {
    KycDocumentLink._defaults(this);
  }

  KycDocumentLinkBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _url = $v.url;
      _expires = $v.expires;
      _signature = $v.signature;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(KycDocumentLink other) {
    _$v = other as _$KycDocumentLink;
  }

  @override
  void update(void Function(KycDocumentLinkBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  KycDocumentLink build() => _build();

  _$KycDocumentLink _build() {
    final _$result =
        _$v ??
        _$KycDocumentLink._(
          url: BuiltValueNullFieldError.checkNotNull(
            url,
            r'KycDocumentLink',
            'url',
          ),
          expires: BuiltValueNullFieldError.checkNotNull(
            expires,
            r'KycDocumentLink',
            'expires',
          ),
          signature: BuiltValueNullFieldError.checkNotNull(
            signature,
            r'KycDocumentLink',
            'signature',
          ),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
            expiresAt,
            r'KycDocumentLink',
            'expiresAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
