// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_document.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantDocument extends MerchantDocument {
  @override
  final String id;
  @override
  final MerchantDocumentType type;
  @override
  final String period;
  @override
  final DateTime issuedAt;

  factory _$MerchantDocument([
    void Function(MerchantDocumentBuilder)? updates,
  ]) => (MerchantDocumentBuilder()..update(updates))._build();

  _$MerchantDocument._({
    required this.id,
    required this.type,
    required this.period,
    required this.issuedAt,
  }) : super._();
  @override
  MerchantDocument rebuild(void Function(MerchantDocumentBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MerchantDocumentBuilder toBuilder() =>
      MerchantDocumentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantDocument &&
        id == other.id &&
        type == other.type &&
        period == other.period &&
        issuedAt == other.issuedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, period.hashCode);
    _$hash = $jc(_$hash, issuedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantDocument')
          ..add('id', id)
          ..add('type', type)
          ..add('period', period)
          ..add('issuedAt', issuedAt))
        .toString();
  }
}

class MerchantDocumentBuilder
    implements Builder<MerchantDocument, MerchantDocumentBuilder> {
  _$MerchantDocument? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  MerchantDocumentType? _type;
  MerchantDocumentType? get type => _$this._type;
  set type(MerchantDocumentType? type) => _$this._type = type;

  String? _period;
  String? get period => _$this._period;
  set period(String? period) => _$this._period = period;

  DateTime? _issuedAt;
  DateTime? get issuedAt => _$this._issuedAt;
  set issuedAt(DateTime? issuedAt) => _$this._issuedAt = issuedAt;

  MerchantDocumentBuilder() {
    MerchantDocument._defaults(this);
  }

  MerchantDocumentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _type = $v.type;
      _period = $v.period;
      _issuedAt = $v.issuedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantDocument other) {
    _$v = other as _$MerchantDocument;
  }

  @override
  void update(void Function(MerchantDocumentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantDocument build() => _build();

  _$MerchantDocument _build() {
    final _$result =
        _$v ??
        _$MerchantDocument._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'MerchantDocument',
            'id',
          ),
          type: BuiltValueNullFieldError.checkNotNull(
            type,
            r'MerchantDocument',
            'type',
          ),
          period: BuiltValueNullFieldError.checkNotNull(
            period,
            r'MerchantDocument',
            'period',
          ),
          issuedAt: BuiltValueNullFieldError.checkNotNull(
            issuedAt,
            r'MerchantDocument',
            'issuedAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
