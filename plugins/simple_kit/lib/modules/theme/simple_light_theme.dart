import 'package:flutter/cupertino.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

/// ! 1) For some reason scaffoldBackgroundColor doesn't set globally
/// ! 2) For some reason fontFamily doesn't set globally
/// ! INVESTIGATE
CupertinoThemeData sLightTheme = CupertinoThemeData(
  scaffoldBackgroundColor: SColorsLight().white,
  textTheme: CupertinoTextThemeData(
    textStyle: TextStyle(
      color: SColorsLight().black,
      fontFamily: 'Gilroy',
    ),
  ),
);
