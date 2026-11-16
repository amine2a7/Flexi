// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerSummary extends CustomerSummary {
  @override
  final String firstName;
  @override
  final String lastInitial;
  @override
  final String maskedEmployeeNumber;

  factory _$CustomerSummary([void Function(CustomerSummaryBuilder)? updates]) =>
      (CustomerSummaryBuilder()..update(updates))._build();

  _$CustomerSummary._({
    required this.firstName,
    required this.lastInitial,
    required this.maskedEmployeeNumber,
  }) : super._();
  @override
  CustomerSummary rebuild(void Function(CustomerSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CustomerSummaryBuilder toBuilder() => CustomerSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerSummary &&
        firstName == other.firstName &&
        lastInitial == other.lastInitial &&
        maskedEmployeeNumber == other.maskedEmployeeNumber;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, firstName.hashCode);
    _$hash = $jc(_$hash, lastInitial.hashCode);
    _$hash = $jc(_$hash, maskedEmployeeNumber.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerSummary')
          ..add('firstName', firstName)
          ..add('lastInitial', lastInitial)
          ..add('maskedEmployeeNumber', maskedEmployeeNumber))
        .toString();
  }
}

class CustomerSummaryBuilder
    implements Builder<CustomerSummary, CustomerSummaryBuilder> {
  _$CustomerSummary? _$v;

  String? _firstName;
  String? get firstName => _$this._firstName;
  set firstName(String? firstName) => _$this._firstName = firstName;

  String? _lastInitial;
  String? get lastInitial => _$this._lastInitial;
  set lastInitial(String? lastInitial) => _$this._lastInitial = lastInitial;

  String? _maskedEmployeeNumber;
  String? get maskedEmployeeNumber => _$this._maskedEmployeeNumber;
  set maskedEmployeeNumber(String? maskedEmployeeNumber) =>
      _$this._maskedEmployeeNumber = maskedEmployeeNumber;

  CustomerSummaryBuilder() {
    CustomerSummary._defaults(this);
  }

  CustomerSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _firstName = $v.firstName;
      _lastInitial = $v.lastInitial;
      _maskedEmployeeNumber = $v.maskedEmployeeNumber;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerSummary other) {
    _$v = other as _$CustomerSummary;
  }

  @override
  void update(void Function(CustomerSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerSummary build() => _build();

  _$CustomerSummary _build() {
    final _$result =
        _$v ??
        _$CustomerSummary._(
          firstName: BuiltValueNullFieldError.checkNotNull(
            firstName,
            r'CustomerSummary',
            'firstName',
          ),
          lastInitial: BuiltValueNullFieldError.checkNotNull(
            lastInitial,
            r'CustomerSummary',
            'lastInitial',
          ),
          maskedEmployeeNumber: BuiltValueNullFieldError.checkNotNull(
            maskedEmployeeNumber,
            r'CustomerSummary',
            'maskedEmployeeNumber',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
