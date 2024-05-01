// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stack_loader_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$StackLoaderStore on _StackLoaderStoreBase, Store {
  late final _$loadingAtom =
      Atom(name: '_StackLoaderStoreBase.loading', context: context);

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  late final _$_StackLoaderStoreBaseActionController =
      ActionController(name: '_StackLoaderStoreBase', context: context);

  @override
  dynamic setLoading(bool value) {
    final _$actionInfo = _$_StackLoaderStoreBaseActionController.startAction(
        name: '_StackLoaderStoreBase.setLoading');
    try {
      return super.setLoading(value);
    } finally {
      _$_StackLoaderStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void startLoadingImmediately() {
    final _$actionInfo = _$_StackLoaderStoreBaseActionController.startAction(
        name: '_StackLoaderStoreBase.startLoadingImmediately');
    try {
      return super.startLoadingImmediately();
    } finally {
      _$_StackLoaderStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void finishLoadingImmediately() {
    final _$actionInfo = _$_StackLoaderStoreBaseActionController.startAction(
        name: '_StackLoaderStoreBase.finishLoadingImmediately');
    try {
      return super.finishLoadingImmediately();
    } finally {
      _$_StackLoaderStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void startLoading() {
    final _$actionInfo = _$_StackLoaderStoreBaseActionController.startAction(
        name: '_StackLoaderStoreBase.startLoading');
    try {
      return super.startLoading();
    } finally {
      _$_StackLoaderStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void finishLoading({VoidCallback? onFinish}) {
    final _$actionInfo = _$_StackLoaderStoreBaseActionController.startAction(
        name: '_StackLoaderStoreBase.finishLoading');
    try {
      return super.finishLoading(onFinish: onFinish);
    } finally {
      _$_StackLoaderStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void dispose() {
    final _$actionInfo = _$_StackLoaderStoreBaseActionController.startAction(
        name: '_StackLoaderStoreBase.dispose');
    try {
      return super.dispose();
    } finally {
      _$_StackLoaderStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading}
    ''';
  }
}
