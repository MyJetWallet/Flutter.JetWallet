import 'package:flutter/cupertino.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/theme/simple_dark_theme.dart';
import 'package:simple_kit/modules/theme/simple_light_theme.dart';
import 'package:simple_kit/simple_kit.dart';

CupertinoThemeData sTheme() {
  return sKit.currentTheme == STheme.dark ? sDarkTheme : sLightTheme;
}
