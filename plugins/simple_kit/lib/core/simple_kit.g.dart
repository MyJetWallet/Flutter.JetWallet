// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simple_kit.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SimpleKit on _SimpleKitBase, Store {
  late final _$currentThemeAtom =
      Atom(name: '_SimpleKitBase.currentTheme', context: context);

  @override
  STheme get currentTheme {
    _$currentThemeAtom.reportRead();
    return super.currentTheme;
  }

  @override
  set currentTheme(STheme value) {
    _$currentThemeAtom.reportWrite(value, super.currentTheme, () {
      super.currentTheme = value;
    });
  }

  late final _$_SimpleKitBaseActionController =
      ActionController(name: '_SimpleKitBase', context: context);

  @override
  dynamic setCurrentTheme(STheme value) {
    final _$actionInfo = _$_SimpleKitBaseActionController.startAction(
        name: '_SimpleKitBase.setCurrentTheme');
    try {
      return super.setCurrentTheme(value);
    } finally {
      _$_SimpleKitBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentTheme: ${currentTheme}
    ''';
  }
}
