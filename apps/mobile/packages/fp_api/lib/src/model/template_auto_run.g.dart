// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_auto_run.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const TemplateAutoRunStatusEnum _$templateAutoRunStatusEnum_DONE =
    const TemplateAutoRunStatusEnum._('DONE');
const TemplateAutoRunStatusEnum _$templateAutoRunStatusEnum_INSUFFICIENT_FUNDS =
    const TemplateAutoRunStatusEnum._('INSUFFICIENT_FUNDS');
const TemplateAutoRunStatusEnum _$templateAutoRunStatusEnum_NO_EMPLOYEE =
    const TemplateAutoRunStatusEnum._('NO_EMPLOYEE');
const TemplateAutoRunStatusEnum _$templateAutoRunStatusEnum_AUTHOR_UNAVAILABLE =
    const TemplateAutoRunStatusEnum._('AUTHOR_UNAVAILABLE');
const TemplateAutoRunStatusEnum _$templateAutoRunStatusEnum_FAILED =
    const TemplateAutoRunStatusEnum._('FAILED');

TemplateAutoRunStatusEnum _$templateAutoRunStatusEnumValueOf(String name) {
  switch (name) {
    case 'DONE':
      return _$templateAutoRunStatusEnum_DONE;
    case 'INSUFFICIENT_FUNDS':
      return _$templateAutoRunStatusEnum_INSUFFICIENT_FUNDS;
    case 'NO_EMPLOYEE':
      return _$templateAutoRunStatusEnum_NO_EMPLOYEE;
    case 'AUTHOR_UNAVAILABLE':
      return _$templateAutoRunStatusEnum_AUTHOR_UNAVAILABLE;
    case 'FAILED':
      return _$templateAutoRunStatusEnum_FAILED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TemplateAutoRunStatusEnum> _$templateAutoRunStatusEnumValues =
    BuiltSet<TemplateAutoRunStatusEnum>(const <TemplateAutoRunStatusEnum>[
      _$templateAutoRunStatusEnum_DONE,
      _$templateAutoRunStatusEnum_INSUFFICIENT_FUNDS,
      _$templateAutoRunStatusEnum_NO_EMPLOYEE,
      _$templateAutoRunStatusEnum_AUTHOR_UNAVAILABLE,
      _$templateAutoRunStatusEnum_FAILED,
    ]);

Serializer<TemplateAutoRunStatusEnum> _$templateAutoRunStatusEnumSerializer =
    _$TemplateAutoRunStatusEnumSerializer();

class _$TemplateAutoRunStatusEnumSerializer
    implements PrimitiveSerializer<TemplateAutoRunStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DONE': 'DONE',
    'INSUFFICIENT_FUNDS': 'INSUFFICIENT_FUNDS',
    'NO_EMPLOYEE': 'NO_EMPLOYEE',
    'AUTHOR_UNAVAILABLE': 'AUTHOR_UNAVAILABLE',
    'FAILED': 'FAILED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DONE': 'DONE',
    'INSUFFICIENT_FUNDS': 'INSUFFICIENT_FUNDS',
    'NO_EMPLOYEE': 'NO_EMPLOYEE',
    'AUTHOR_UNAVAILABLE': 'AUTHOR_UNAVAILABLE',
    'FAILED': 'FAILED',
  };

  @override
  final Iterable<Type> types = const <Type>[TemplateAutoRunStatusEnum];
  @override
  final String wireName = 'TemplateAutoRunStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    TemplateAutoRunStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  TemplateAutoRunStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => TemplateAutoRunStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$TemplateAutoRun extends TemplateAutoRun {
  @override
  final String month;
  @override
  final TemplateAutoRunStatusEnum status;

  factory _$TemplateAutoRun([void Function(TemplateAutoRunBuilder)? updates]) =>
      (TemplateAutoRunBuilder()..update(updates))._build();

  _$TemplateAutoRun._({required this.month, required this.status}) : super._();
  @override
  TemplateAutoRun rebuild(void Function(TemplateAutoRunBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TemplateAutoRunBuilder toBuilder() => TemplateAutoRunBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TemplateAutoRun &&
        month == other.month &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, month.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TemplateAutoRun')
          ..add('month', month)
          ..add('status', status))
        .toString();
  }
}

class TemplateAutoRunBuilder
    implements Builder<TemplateAutoRun, TemplateAutoRunBuilder> {
  _$TemplateAutoRun? _$v;

  String? _month;
  String? get month => _$this._month;
  set month(String? month) => _$this._month = month;

  TemplateAutoRunStatusEnum? _status;
  TemplateAutoRunStatusEnum? get status => _$this._status;
  set status(TemplateAutoRunStatusEnum? status) => _$this._status = status;

  TemplateAutoRunBuilder() {
    TemplateAutoRun._defaults(this);
  }

  TemplateAutoRunBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _month = $v.month;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TemplateAutoRun other) {
    _$v = other as _$TemplateAutoRun;
  }

  @override
  void update(void Function(TemplateAutoRunBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TemplateAutoRun build() => _build();

  _$TemplateAutoRun _build() {
    final _$result =
        _$v ??
        _$TemplateAutoRun._(
          month: BuiltValueNullFieldError.checkNotNull(
            month,
            r'TemplateAutoRun',
            'month',
          ),
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'TemplateAutoRun',
            'status',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
