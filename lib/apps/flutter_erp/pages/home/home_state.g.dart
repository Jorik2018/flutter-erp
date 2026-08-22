// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$HomeState extends HomeState {
  @override
  final BuiltList<Contact> contacts;
  @override
  final bool isLoading;
  @override
  final Object? error;

  factory _$HomeState([void Function(HomeStateBuilder)? updates]) =>
      (HomeStateBuilder()..update(updates))._build();

  _$HomeState._({required this.contacts, required this.isLoading, this.error})
    : super._();
  @override
  HomeState rebuild(void Function(HomeStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  HomeStateBuilder toBuilder() => HomeStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is HomeState &&
        contacts == other.contacts &&
        isLoading == other.isLoading &&
        error == other.error;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, contacts.hashCode);
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jc(_$hash, error.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'HomeState')
          ..add('contacts', contacts)
          ..add('isLoading', isLoading)
          ..add('error', error))
        .toString();
  }
}

class HomeStateBuilder implements Builder<HomeState, HomeStateBuilder> {
  _$HomeState? _$v;

  ListBuilder<Contact>? _contacts;
  ListBuilder<Contact> get contacts =>
      _$this._contacts ??= ListBuilder<Contact>();
  set contacts(ListBuilder<Contact>? contacts) => _$this._contacts = contacts;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  Object? _error;
  Object? get error => _$this._error;
  set error(Object? error) => _$this._error = error;

  HomeStateBuilder();

  HomeStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _contacts = $v.contacts.toBuilder();
      _isLoading = $v.isLoading;
      _error = $v.error;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(HomeState other) {
    _$v = other as _$HomeState;
  }

  @override
  void update(void Function(HomeStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  HomeState build() => _build();

  _$HomeState _build() {
    _$HomeState _$result;
    try {
      _$result =
          _$v ??
          _$HomeState._(
            contacts: contacts.build(),
            isLoading: BuiltValueNullFieldError.checkNotNull(
              isLoading,
              r'HomeState',
              'isLoading',
            ),
            error: error,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'contacts';
        contacts.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'HomeState',
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
