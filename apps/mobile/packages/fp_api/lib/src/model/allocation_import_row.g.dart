// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'allocation_import_row.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AllocationImportRowIssuesEnum
_$allocationImportRowIssuesEnum_UNKNOWN_EMPLOYEE =
    const AllocationImportRowIssuesEnum._('UNKNOWN_EMPLOYEE');
const AllocationImportRowIssuesEnum
_$allocationImportRowIssuesEnum_INVALID_AMOUNT =
    const AllocationImportRowIssuesEnum._('INVALID_AMOUNT');
const AllocationImportRowIssuesEnum _$allocationImportRowIssuesEnum_NO_AMOUNT =
    const AllocationImportRowIssuesEnum._('NO_AMOUNT');
const AllocationImportRowIssuesEnum
_$allocationImportRowIssuesEnum_TYPE_DISABLED =
    const AllocationImportRowIssuesEnum._('TYPE_DISABLED');

AllocationImportRowIssuesEnum _$allocationImportRowIssuesEnumValueOf(
  String name,
) {
  switch (name) {
    case 'UNKNOWN_EMPLOYEE':
      return _$allocationImportRowIssuesEnum_UNKNOWN_EMPLOYEE;
    case 'INVALID_AMOUNT':
      return _$allocationImportRowIssuesEnum_INVALID_AMOUNT;
    case 'NO_AMOUNT':
      return _$allocationImportRowIssuesEnum_NO_AMOUNT;
    case 'TYPE_DISABLED':
      return _$allocationImportRowIssuesEnum_TYPE_DISABLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AllocationImportRowIssuesEnum>
_$allocationImportRowIssuesEnumValues = BuiltSet<AllocationImportRowIssuesEnum>(
  const <AllocationImportRowIssuesEnum>[
    _$allocationImportRowIssuesEnum_UNKNOWN_EMPLOYEE,
    _$allocationImportRowIssuesEnum_INVALID_AMOUNT,
    _$allocationImportRowIssuesEnum_NO_AMOUNT,
    _$allocationImportRowIssuesEnum_TYPE_DISABLED,
  ],
);

Serializer<AllocationImportRowIssuesEnum>
_$allocationImportRowIssuesEnumSerializer =
    _$AllocationImportRowIssuesEnumSerializer();

class _$AllocationImportRowIssuesEnumSerializer
    implements PrimitiveSerializer<AllocationImportRowIssuesEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'UNKNOWN_EMPLOYEE': 'UNKNOWN_EMPLOYEE',
    'INVALID_AMOUNT': 'INVALID_AMOUNT',
    'NO_AMOUNT': 'NO_AMOUNT',
    'TYPE_DISABLED': 'TYPE_DISABLED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'UNKNOWN_EMPLOYEE': 'UNKNOWN_EMPLOYEE',
    'INVALID_AMOUNT': 'INVALID_AMOUNT',
    'NO_AMOUNT': 'NO_AMOUNT',
    'TYPE_DISABLED': 'TYPE_DISABLED',
  };

  @override
  final Iterable<Type> types = const <Type>[AllocationImportRowIssuesEnum];
  @override
  final String wireName = 'AllocationImportRowIssuesEnum';

  @override
  Object serialize(
    Serializers serializers,
    AllocationImportRowIssuesEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AllocationImportRowIssuesEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AllocationImportRowIssuesEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AllocationImportRow extends AllocationImportRow {
  @override
  final int line;
  @override
  final String employeeNumber;
  @override
  final String? employeeName;
  @override
  final BuiltList<CreditTypeAmount> amounts;
  @override
  final BuiltList<AllocationImportRowIssuesEnum> issues;

  factory _$AllocationImportRow([
    void Function(AllocationImportRowBuilder)? updates,
  ]) => (AllocationImportRowBuilder()..update(updates))._build();

  _$AllocationImportRow._({
    required this.line,
    required this.employeeNumber,
    this.employeeName,
    required this.amounts,
    required this.issues,
  }) : super._();
  @override
  AllocationImportRow rebuild(
    void Function(AllocationImportRowBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AllocationImportRowBuilder toBuilder() =>
      AllocationImportRowBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AllocationImportRow &&
        line == other.line &&
        employeeNumber == other.employeeNumber &&
        employeeName == other.employeeName &&
        amounts == other.amounts &&
        issues == other.issues;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, line.hashCode);
    _$hash = $jc(_$hash, employeeNumber.hashCode);
    _$hash = $jc(_$hash, employeeName.hashCode);
    _$hash = $jc(_$hash, amounts.hashCode);
    _$hash = $jc(_$hash, issues.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AllocationImportRow')
          ..add('line', line)
          ..add('employeeNumber', employeeNumber)
          ..add('employeeName', employeeName)
          ..add('amounts', amounts)
          ..add('issues', issues))
        .toString();
  }
}

class AllocationImportRowBuilder
    implements Builder<AllocationImportRow, AllocationImportRowBuilder> {
  _$AllocationImportRow? _$v;

  int? _line;
  int? get line => _$this._line;
  set line(int? line) => _$this._line = line;

  String? _employeeNumber;
  String? get employeeNumber => _$this._employeeNumber;
  set employeeNumber(String? employeeNumber) =>
      _$this._employeeNumber = employeeNumber;

  String? _employeeName;
  String? get employeeName => _$this._employeeName;
  set employeeName(String? employeeName) => _$this._employeeName = employeeName;

  ListBuilder<CreditTypeAmount>? _amounts;
  ListBuilder<CreditTypeAmount> get amounts =>
      _$this._amounts ??= ListBuilder<CreditTypeAmount>();
  set amounts(ListBuilder<CreditTypeAmount>? amounts) =>
      _$this._amounts = amounts;

  ListBuilder<AllocationImportRowIssuesEnum>? _issues;
  ListBuilder<AllocationImportRowIssuesEnum> get issues =>
      _$this._issues ??= ListBuilder<AllocationImportRowIssuesEnum>();
  set issues(ListBuilder<AllocationImportRowIssuesEnum>? issues) =>
      _$this._issues = issues;

  AllocationImportRowBuilder() {
    AllocationImportRow._defaults(this);
  }

  AllocationImportRowBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _line = $v.line;
      _employeeNumber = $v.employeeNumber;
      _employeeName = $v.employeeName;
      _amounts = $v.amounts.toBuilder();
      _issues = $v.issues.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AllocationImportRow other) {
    _$v = other as _$AllocationImportRow;
  }

  @override
  void update(void Function(AllocationImportRowBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AllocationImportRow build() => _build();

  _$AllocationImportRow _build() {
    _$AllocationImportRow _$result;
    try {
      _$result =
          _$v ??
          _$AllocationImportRow._(
            line: BuiltValueNullFieldError.checkNotNull(
              line,
              r'AllocationImportRow',
              'line',
            ),
            employeeNumber: BuiltValueNullFieldError.checkNotNull(
              employeeNumber,
              r'AllocationImportRow',
              'employeeNumber',
            ),
            employeeName: employeeName,
            amounts: amounts.build(),
            issues: issues.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'amounts';
        amounts.build();
        _$failedField = 'issues';
        issues.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AllocationImportRow',
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
