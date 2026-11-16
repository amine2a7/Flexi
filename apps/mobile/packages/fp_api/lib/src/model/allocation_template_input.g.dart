// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'allocation_template_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AllocationTemplateInput extends AllocationTemplateInput {
  @override
  final int? autoMonthlyDay;
  @override
  final String name;
  @override
  final String? departmentId;
  @override
  final String? position;
  @override
  final BuiltList<AllocationTypeAmount> amounts;

  factory _$AllocationTemplateInput([
    void Function(AllocationTemplateInputBuilder)? updates,
  ]) => (AllocationTemplateInputBuilder()..update(updates))._build();

  _$AllocationTemplateInput._({
    this.autoMonthlyDay,
    required this.name,
    this.departmentId,
    this.position,
    required this.amounts,
  }) : super._();
  @override
  AllocationTemplateInput rebuild(
    void Function(AllocationTemplateInputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AllocationTemplateInputBuilder toBuilder() =>
      AllocationTemplateInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AllocationTemplateInput &&
        autoMonthlyDay == other.autoMonthlyDay &&
        name == other.name &&
        departmentId == other.departmentId &&
        position == other.position &&
        amounts == other.amounts;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, autoMonthlyDay.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, departmentId.hashCode);
    _$hash = $jc(_$hash, position.hashCode);
    _$hash = $jc(_$hash, amounts.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AllocationTemplateInput')
          ..add('autoMonthlyDay', autoMonthlyDay)
          ..add('name', name)
          ..add('departmentId', departmentId)
          ..add('position', position)
          ..add('amounts', amounts))
        .toString();
  }
}

class AllocationTemplateInputBuilder
    implements
        Builder<AllocationTemplateInput, AllocationTemplateInputBuilder> {
  _$AllocationTemplateInput? _$v;

  int? _autoMonthlyDay;
  int? get autoMonthlyDay => _$this._autoMonthlyDay;
  set autoMonthlyDay(int? autoMonthlyDay) =>
      _$this._autoMonthlyDay = autoMonthlyDay;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _departmentId;
  String? get departmentId => _$this._departmentId;
  set departmentId(String? departmentId) => _$this._departmentId = departmentId;

  String? _position;
  String? get position => _$this._position;
  set position(String? position) => _$this._position = position;

  ListBuilder<AllocationTypeAmount>? _amounts;
  ListBuilder<AllocationTypeAmount> get amounts =>
      _$this._amounts ??= ListBuilder<AllocationTypeAmount>();
  set amounts(ListBuilder<AllocationTypeAmount>? amounts) =>
      _$this._amounts = amounts;

  AllocationTemplateInputBuilder() {
    AllocationTemplateInput._defaults(this);
  }

  AllocationTemplateInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _autoMonthlyDay = $v.autoMonthlyDay;
      _name = $v.name;
      _departmentId = $v.departmentId;
      _position = $v.position;
      _amounts = $v.amounts.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AllocationTemplateInput other) {
    _$v = other as _$AllocationTemplateInput;
  }

  @override
  void update(void Function(AllocationTemplateInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AllocationTemplateInput build() => _build();

  _$AllocationTemplateInput _build() {
    _$AllocationTemplateInput _$result;
    try {
      _$result =
          _$v ??
          _$AllocationTemplateInput._(
            autoMonthlyDay: autoMonthlyDay,
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'AllocationTemplateInput',
              'name',
            ),
            departmentId: departmentId,
            position: position,
            amounts: amounts.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'amounts';
        amounts.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AllocationTemplateInput',
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
