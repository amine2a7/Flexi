// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_bulk_status_change.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const EmployeeBulkStatusChangeActionEnum
_$employeeBulkStatusChangeActionEnum_SUSPEND =
    const EmployeeBulkStatusChangeActionEnum._('SUSPEND');
const EmployeeBulkStatusChangeActionEnum
_$employeeBulkStatusChangeActionEnum_REACTIVATE =
    const EmployeeBulkStatusChangeActionEnum._('REACTIVATE');

EmployeeBulkStatusChangeActionEnum _$employeeBulkStatusChangeActionEnumValueOf(
  String name,
) {
  switch (name) {
    case 'SUSPEND':
      return _$employeeBulkStatusChangeActionEnum_SUSPEND;
    case 'REACTIVATE':
      return _$employeeBulkStatusChangeActionEnum_REACTIVATE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<EmployeeBulkStatusChangeActionEnum>
_$employeeBulkStatusChangeActionEnumValues =
    BuiltSet<EmployeeBulkStatusChangeActionEnum>(
      const <EmployeeBulkStatusChangeActionEnum>[
        _$employeeBulkStatusChangeActionEnum_SUSPEND,
        _$employeeBulkStatusChangeActionEnum_REACTIVATE,
      ],
    );

Serializer<EmployeeBulkStatusChangeActionEnum>
_$employeeBulkStatusChangeActionEnumSerializer =
    _$EmployeeBulkStatusChangeActionEnumSerializer();

class _$EmployeeBulkStatusChangeActionEnumSerializer
    implements PrimitiveSerializer<EmployeeBulkStatusChangeActionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'SUSPEND': 'SUSPEND',
    'REACTIVATE': 'REACTIVATE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'SUSPEND': 'SUSPEND',
    'REACTIVATE': 'REACTIVATE',
  };

  @override
  final Iterable<Type> types = const <Type>[EmployeeBulkStatusChangeActionEnum];
  @override
  final String wireName = 'EmployeeBulkStatusChangeActionEnum';

  @override
  Object serialize(
    Serializers serializers,
    EmployeeBulkStatusChangeActionEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  EmployeeBulkStatusChangeActionEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => EmployeeBulkStatusChangeActionEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$EmployeeBulkStatusChange extends EmployeeBulkStatusChange {
  @override
  final EmployeeBulkStatusChangeActionEnum action;
  @override
  final BuiltSet<String> employeeIds;
  @override
  final String reason;

  factory _$EmployeeBulkStatusChange([
    void Function(EmployeeBulkStatusChangeBuilder)? updates,
  ]) => (EmployeeBulkStatusChangeBuilder()..update(updates))._build();

  _$EmployeeBulkStatusChange._({
    required this.action,
    required this.employeeIds,
    required this.reason,
  }) : super._();
  @override
  EmployeeBulkStatusChange rebuild(
    void Function(EmployeeBulkStatusChangeBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  EmployeeBulkStatusChangeBuilder toBuilder() =>
      EmployeeBulkStatusChangeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmployeeBulkStatusChange &&
        action == other.action &&
        employeeIds == other.employeeIds &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, action.hashCode);
    _$hash = $jc(_$hash, employeeIds.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EmployeeBulkStatusChange')
          ..add('action', action)
          ..add('employeeIds', employeeIds)
          ..add('reason', reason))
        .toString();
  }
}

class EmployeeBulkStatusChangeBuilder
    implements
        Builder<EmployeeBulkStatusChange, EmployeeBulkStatusChangeBuilder> {
  _$EmployeeBulkStatusChange? _$v;

  EmployeeBulkStatusChangeActionEnum? _action;
  EmployeeBulkStatusChangeActionEnum? get action => _$this._action;
  set action(EmployeeBulkStatusChangeActionEnum? action) =>
      _$this._action = action;

  SetBuilder<String>? _employeeIds;
  SetBuilder<String> get employeeIds =>
      _$this._employeeIds ??= SetBuilder<String>();
  set employeeIds(SetBuilder<String>? employeeIds) =>
      _$this._employeeIds = employeeIds;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  EmployeeBulkStatusChangeBuilder() {
    EmployeeBulkStatusChange._defaults(this);
  }

  EmployeeBulkStatusChangeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _action = $v.action;
      _employeeIds = $v.employeeIds.toBuilder();
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EmployeeBulkStatusChange other) {
    _$v = other as _$EmployeeBulkStatusChange;
  }

  @override
  void update(void Function(EmployeeBulkStatusChangeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmployeeBulkStatusChange build() => _build();

  _$EmployeeBulkStatusChange _build() {
    _$EmployeeBulkStatusChange _$result;
    try {
      _$result =
          _$v ??
          _$EmployeeBulkStatusChange._(
            action: BuiltValueNullFieldError.checkNotNull(
              action,
              r'EmployeeBulkStatusChange',
              'action',
            ),
            employeeIds: employeeIds.build(),
            reason: BuiltValueNullFieldError.checkNotNull(
              reason,
              r'EmployeeBulkStatusChange',
              'reason',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'employeeIds';
        employeeIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'EmployeeBulkStatusChange',
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
