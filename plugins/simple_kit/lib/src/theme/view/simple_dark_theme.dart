import 'package:flutter/cupertino.dart';

import '../../colors/view/simple_colors_dark.dart';

/// ! 1) For some reason scaffoldBackgroundColor doesn't set globally
/// ! 2) For some reason fontFamily doesn't set globally
/// ! INVESTIGATE
CupertinoThemeData sDarkTheme = CupertinoThemeData(
  scaffoldBackgroundColor: SColorsDark().grey5,
  textTheme: CupertinoTextThemeData(
    textStyle: TextStyle(
      color: SColorsDark().white,
      fontFamily: 'Gilroy',
    ),
  ),
);
