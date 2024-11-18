import 'package:flutter/cupertino.dart';
import 'package:simple_kit/modules/colors/simple_colors_dark.dart';

/// ! 1) For some reason scaffoldBackgroundColor doesn't set globally
/// ! 2) For some reason fontFamily doesn't set globally
/// ! INVESTIGATE
CupertinoThemeData sDarkTheme = CupertinoThemeData(
  scaffoldBackgroundColor: SColorsDark().gray2,
  textTheme: CupertinoTextThemeData(
    textStyle: TextStyle(
      color: SColorsDark().white,
      fontFamily: 'Gilroy',
    ),
  ),
);
