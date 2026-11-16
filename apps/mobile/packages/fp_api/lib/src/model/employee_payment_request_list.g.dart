// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_payment_request_list.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EmployeePaymentRequestList extends EmployeePaymentRequestList {
  @override
  final BuiltList<EmployeePaymentRequest> data;

  factory _$EmployeePaymentRequestList([
    void Function(EmployeePaymentRequestListBuilder)? updates,
  ]) => (EmployeePaymentRequestListBuilder()..update(updates))._build();

  _$EmployeePaymentRequestList._({required this.data}) : super._();
  @override
  EmployeePaymentRequestList rebuild(
    void Function(EmployeePaymentRequestListBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  EmployeePaymentRequestListBuilder toBuilder() =>
      EmployeePaymentRequestListBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmployeePaymentRequestList && data == other.data;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'EmployeePaymentRequestList',
    )..add('data', data)).toString();
  }
}

class EmployeePaymentRequestListBuilder
    implements
        Builder<EmployeePaymentRequestList, EmployeePaymentRequestListBuilder> {
  _$EmployeePaymentRequestList? _$v;

  ListBuilder<EmployeePaymentRequest>? _data;
  ListBuilder<EmployeePaymentRequest> get data =>
      _$this._data ??= ListBuilder<EmployeePaymentRequest>();
  set data(ListBuilder<EmployeePaymentRequest>? data) => _$this._data = data;

  EmployeePaymentRequestListBuilder() {
    EmployeePaymentRequestList._defaults(this);
  }

  EmployeePaymentRequestListBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EmployeePaymentRequestList other) {
    _$v = other as _$EmployeePaymentRequestList;
  }

  @override
  void update(void Function(EmployeePaymentRequestListBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmployeePaymentRequestList build() => _build();

  _$EmployeePaymentRequestList _build() {
    _$EmployeePaymentRequestList _$result;
    try {
      _$result = _$v ?? _$EmployeePaymentRequestList._(data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'EmployeePaymentRequestList',
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
