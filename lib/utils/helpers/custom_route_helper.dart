import 'package:flutter/material.dart';

class CustomMaterialPageRoute extends MaterialPageRoute {
  CustomMaterialPageRoute({
    required super.builder,
    required RouteSettings super.settings,
    super.maintainState,
    super.fullscreenDialog,
  });

  @override
  @protected
  bool get hasScopedWillPopCallback {
    return false;
  }
}
