// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'allocation_template.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AllocationTemplate extends AllocationTemplate {
  @override
  final int? autoMonthlyDay;
  @override
  final TemplateAutoRun? lastAutoRun;
  @override
  final String id;
  @override
  final String name;
  @override
  final String? departmentId;
  @override
  final String? departmentName;
  @override
  final String? position;
  @override
  final BuiltList<AllocationTypeAmount> amounts;
  @override
  final DateTime? lastRunAt;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  factory _$AllocationTemplate([
    void Function(AllocationTemplateBuilder)? updates,
  ]) => (AllocationTemplateBuilder()..update(updates))._build();

  _$AllocationTemplate._({
    this.autoMonthlyDay,
    this.lastAutoRun,
    required this.id,
    required this.name,
    this.departmentId,
    this.departmentName,
    this.position,
    required this.amounts,
    this.lastRunAt,
    required this.createdAt,
    required this.updatedAt,
  }) : super._();
  @override
  AllocationTemplate rebuild(
    void Function(AllocationTemplateBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AllocationTemplateBuilder toBuilder() =>
      AllocationTemplateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AllocationTemplate &&
        autoMonthlyDay == other.autoMonthlyDay &&
        lastAutoRun == other.lastAutoRun &&
        id == other.id &&
        name == other.name &&
        departmentId == other.departmentId &&
        departmentName == other.departmentName &&
        position == other.position &&
        amounts == other.amounts &&
        lastRunAt == other.lastRunAt &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, autoMonthlyDay.hashCode);
    _$hash = $jc(_$hash, lastAutoRun.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, departmentId.hashCode);
    _$hash = $jc(_$hash, departmentName.hashCode);
    _$hash = $jc(_$hash, position.hashCode);
    _$hash = $jc(_$hash, amounts.hashCode);
    _$hash = $jc(_$hash, lastRunAt.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AllocationTemplate')
          ..add('autoMonthlyDay', autoMonthlyDay)
          ..add('lastAutoRun', lastAutoRun)
          ..add('id', id)
          ..add('name', name)
          ..add('departmentId', departmentId)
          ..add('departmentName', departmentName)
          ..add('position', position)
          ..add('amounts', amounts)
          ..add('lastRunAt', lastRunAt)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class AllocationTemplateBuilder
    implements Builder<AllocationTemplate, AllocationTemplateBuilder> {
  _$AllocationTemplate? _$v;

  int? _autoMonthlyDay;
  int? get autoMonthlyDay => _$this._autoMonthlyDay;
  set autoMonthlyDay(int? autoMonthlyDay) =>
      _$this._autoMonthlyDay = autoMonthlyDay;

  TemplateAutoRunBuilder? _lastAutoRun;
  TemplateAutoRunBuilder get lastAutoRun =>
      _$this._lastAutoRun ??= TemplateAutoRunBuilder();
  set lastAutoRun(TemplateAutoRunBuilder? lastAutoRun) =>
      _$this._lastAutoRun = lastAutoRun;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _departmentId;
  String? get departmentId => _$this._departmentId;
  set departmentId(String? departmentId) => _$this._departmentId = departmentId;

  String? _departmentName;
  String? get departmentName => _$this._departmentName;
  set departmentName(String? departmentName) =>
      _$this._departmentName = departmentName;

  String? _position;
  String? get position => _$this._position;
  set position(String? position) => _$this._position = position;

  ListBuilder<AllocationTypeAmount>? _amounts;
  ListBuilder<AllocationTypeAmount> get amounts =>
      _$this._amounts ??= ListBuilder<AllocationTypeAmount>();
  set amounts(ListBuilder<AllocationTypeAmount>? amounts) =>
      _$this._amounts = amounts;

  DateTime? _lastRunAt;
  DateTime? get lastRunAt => _$this._lastRunAt;
  set lastRunAt(DateTime? lastRunAt) => _$this._lastRunAt = lastRunAt;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  AllocationTemplateBuilder() {
    AllocationTemplate._defaults(this);
  }

  AllocationTemplateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _autoMonthlyDay = $v.autoMonthlyDay;
      _lastAutoRun = $v.lastAutoRun?.toBuilder();
      _id = $v.id;
      _name = $v.name;
      _departmentId = $v.departmentId;
      _departmentName = $v.departmentName;
      _position = $v.position;
      _amounts = $v.amounts.toBuilder();
      _lastRunAt = $v.lastRunAt;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AllocationTemplate other) {
    _$v = other as _$AllocationTemplate;
  }

  @override
  void update(void Function(AllocationTemplateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AllocationTemplate build() => _build();

  _$AllocationTemplate _build() {
    _$AllocationTemplate _$result;
    try {
      _$result =
          _$v ??
          _$AllocationTemplate._(
            autoMonthlyDay: autoMonthlyDay,
            lastAutoRun: _lastAutoRun?.build(),
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AllocationTemplate',
              'id',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'AllocationTemplate',
              'name',
            ),
            departmentId: departmentId,
            departmentName: departmentName,
            position: position,
            amounts: amounts.build(),
            lastRunAt: lastRunAt,
            createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'AllocationTemplate',
              'createdAt',
            ),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt,
              r'AllocationTemplate',
              'updatedAt',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lastAutoRun';
        _lastAutoRun?.build();

        _$failedField = 'amounts';
        amounts.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AllocationTemplate',
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
