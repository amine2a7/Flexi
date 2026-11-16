// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_bulk_status_result_results_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const EmployeeBulkStatusResultResultsInnerOutcomeEnum
_$employeeBulkStatusResultResultsInnerOutcomeEnum_DONE =
    const EmployeeBulkStatusResultResultsInnerOutcomeEnum._('DONE');
const EmployeeBulkStatusResultResultsInnerOutcomeEnum
_$employeeBulkStatusResultResultsInnerOutcomeEnum_SKIPPED =
    const EmployeeBulkStatusResultResultsInnerOutcomeEnum._('SKIPPED');

EmployeeBulkStatusResultResultsInnerOutcomeEnum
_$employeeBulkStatusResultResultsInnerOutcomeEnumValueOf(String name) {
  switch (name) {
    case 'DONE':
      return _$employeeBulkStatusResultResultsInnerOutcomeEnum_DONE;
    case 'SKIPPED':
      return _$employeeBulkStatusResultResultsInnerOutcomeEnum_SKIPPED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<EmployeeBulkStatusResultResultsInnerOutcomeEnum>
_$employeeBulkStatusResultResultsInnerOutcomeEnumValues =
    BuiltSet<EmployeeBulkStatusResultResultsInnerOutcomeEnum>(
      const <EmployeeBulkStatusResultResultsInnerOutcomeEnum>[
        _$employeeBulkStatusResultResultsInnerOutcomeEnum_DONE,
        _$employeeBulkStatusResultResultsInnerOutcomeEnum_SKIPPED,
      ],
    );

Serializer<EmployeeBulkStatusResultResultsInnerOutcomeEnum>
_$employeeBulkStatusResultResultsInnerOutcomeEnumSerializer =
    _$EmployeeBulkStatusResultResultsInnerOutcomeEnumSerializer();

class _$EmployeeBulkStatusResultResultsInnerOutcomeEnumSerializer
    implements
        PrimitiveSerializer<EmployeeBulkStatusResultResultsInnerOutcomeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DONE': 'DONE',
    'SKIPPED': 'SKIPPED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DONE': 'DONE',
    'SKIPPED': 'SKIPPED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    EmployeeBulkStatusResultResultsInnerOutcomeEnum,
  ];
  @override
  final String wireName = 'EmployeeBulkStatusResultResultsInnerOutcomeEnum';

  @override
  Object serialize(
    Serializers serializers,
    EmployeeBulkStatusResultResultsInnerOutcomeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  EmployeeBulkStatusResultResultsInnerOutcomeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => EmployeeBulkStatusResultResultsInnerOutcomeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$EmployeeBulkStatusResultResultsInner
    extends EmployeeBulkStatusResultResultsInner {
  @override
  final String employeeId;
  @override
  final EmployeeBulkStatusResultResultsInnerOutcomeEnum outcome;

  factory _$EmployeeBulkStatusResultResultsInner([
    void Function(EmployeeBulkStatusResultResultsInnerBuilder)? updates,
  ]) =>
      (EmployeeBulkStatusResultResultsInnerBuilder()..update(updates))._build();

  _$EmployeeBulkStatusResultResultsInner._({
    required this.employeeId,
    required this.outcome,
  }) : super._();
  @override
  EmployeeBulkStatusResultResultsInner rebuild(
    void Function(EmployeeBulkStatusResultResultsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  EmployeeBulkStatusResultResultsInnerBuilder toBuilder() =>
      EmployeeBulkStatusResultResultsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmployeeBulkStatusResultResultsInner &&
        employeeId == other.employeeId &&
        outcome == other.outcome;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, employeeId.hashCode);
    _$hash = $jc(_$hash, outcome.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EmployeeBulkStatusResultResultsInner')
          ..add('employeeId', employeeId)
          ..add('outcome', outcome))
        .toString();
  }
}

class EmployeeBulkStatusResultResultsInnerBuilder
    implements
        Builder<
          EmployeeBulkStatusResultResultsInner,
          EmployeeBulkStatusResultResultsInnerBuilder
        > {
  _$EmployeeBulkStatusResultResultsInner? _$v;

  String? _employeeId;
  String? get employeeId => _$this._employeeId;
  set employeeId(String? employeeId) => _$this._employeeId = employeeId;

  EmployeeBulkStatusResultResultsInnerOutcomeEnum? _outcome;
  EmployeeBulkStatusResultResultsInnerOutcomeEnum? get outcome =>
      _$this._outcome;
  set outcome(EmployeeBulkStatusResultResultsInnerOutcomeEnum? outcome) =>
      _$this._outcome = outcome;

  EmployeeBulkStatusResultResultsInnerBuilder() {
    EmployeeBulkStatusResultResultsInner._defaults(this);
  }

  EmployeeBulkStatusResultResultsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _employeeId = $v.employeeId;
      _outcome = $v.outcome;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EmployeeBulkStatusResultResultsInner other) {
    _$v = other as _$EmployeeBulkStatusResultResultsInner;
  }

  @override
  void update(
    void Function(EmployeeBulkStatusResultResultsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  EmployeeBulkStatusResultResultsInner build() => _build();

  _$EmployeeBulkStatusResultResultsInner _build() {
    final _$result =
        _$v ??
        _$EmployeeBulkStatusResultResultsInner._(
          employeeId: BuiltValueNullFieldError.checkNotNull(
            employeeId,
            r'EmployeeBulkStatusResultResultsInner',
            'employeeId',
          ),
          outcome: BuiltValueNullFieldError.checkNotNull(
            outcome,
            r'EmployeeBulkStatusResultResultsInner',
            'outcome',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
