// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_declaration.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TransferDeclaration extends TransferDeclaration {
  @override
  final String transferReference;
  @override
  final Date transferDate;
  @override
  final int amountMillimes;
  @override
  final TransferProof proof;
  @override
  final DateTime declaredAt;

  factory _$TransferDeclaration([
    void Function(TransferDeclarationBuilder)? updates,
  ]) => (TransferDeclarationBuilder()..update(updates))._build();

  _$TransferDeclaration._({
    required this.transferReference,
    required this.transferDate,
    required this.amountMillimes,
    required this.proof,
    required this.declaredAt,
  }) : super._();
  @override
  TransferDeclaration rebuild(
    void Function(TransferDeclarationBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  TransferDeclarationBuilder toBuilder() =>
      TransferDeclarationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TransferDeclaration &&
        transferReference == other.transferReference &&
        transferDate == other.transferDate &&
        amountMillimes == other.amountMillimes &&
        proof == other.proof &&
        declaredAt == other.declaredAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, transferReference.hashCode);
    _$hash = $jc(_$hash, transferDate.hashCode);
    _$hash = $jc(_$hash, amountMillimes.hashCode);
    _$hash = $jc(_$hash, proof.hashCode);
    _$hash = $jc(_$hash, declaredAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TransferDeclaration')
          ..add('transferReference', transferReference)
          ..add('transferDate', transferDate)
          ..add('amountMillimes', amountMillimes)
          ..add('proof', proof)
          ..add('declaredAt', declaredAt))
        .toString();
  }
}

class TransferDeclarationBuilder
    implements Builder<TransferDeclaration, TransferDeclarationBuilder> {
  _$TransferDeclaration? _$v;

  String? _transferReference;
  String? get transferReference => _$this._transferReference;
  set transferReference(String? transferReference) =>
      _$this._transferReference = transferReference;

  Date? _transferDate;
  Date? get transferDate => _$this._transferDate;
  set transferDate(Date? transferDate) => _$this._transferDate = transferDate;

  int? _amountMillimes;
  int? get amountMillimes => _$this._amountMillimes;
  set amountMillimes(int? amountMillimes) =>
      _$this._amountMillimes = amountMillimes;

  TransferProofBuilder? _proof;
  TransferProofBuilder get proof => _$this._proof ??= TransferProofBuilder();
  set proof(TransferProofBuilder? proof) => _$this._proof = proof;

  DateTime? _declaredAt;
  DateTime? get declaredAt => _$this._declaredAt;
  set declaredAt(DateTime? declaredAt) => _$this._declaredAt = declaredAt;

  TransferDeclarationBuilder() {
    TransferDeclaration._defaults(this);
  }

  TransferDeclarationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _transferReference = $v.transferReference;
      _transferDate = $v.transferDate;
      _amountMillimes = $v.amountMillimes;
      _proof = $v.proof.toBuilder();
      _declaredAt = $v.declaredAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TransferDeclaration other) {
    _$v = other as _$TransferDeclaration;
  }

  @override
  void update(void Function(TransferDeclarationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TransferDeclaration build() => _build();

  _$TransferDeclaration _build() {
    _$TransferDeclaration _$result;
    try {
      _$result =
          _$v ??
          _$TransferDeclaration._(
            transferReference: BuiltValueNullFieldError.checkNotNull(
              transferReference,
              r'TransferDeclaration',
              'transferReference',
            ),
            transferDate: BuiltValueNullFieldError.checkNotNull(
              transferDate,
              r'TransferDeclaration',
              'transferDate',
            ),
            amountMillimes: BuiltValueNullFieldError.checkNotNull(
              amountMillimes,
              r'TransferDeclaration',
              'amountMillimes',
            ),
            proof: proof.build(),
            declaredAt: BuiltValueNullFieldError.checkNotNull(
              declaredAt,
              r'TransferDeclaration',
              'declaredAt',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'proof';
        proof.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'TransferDeclaration',
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
