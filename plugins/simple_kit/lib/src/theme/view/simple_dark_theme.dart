import 'package:flutter/material.dart';

import '../../colors/view/simple_colors_dark.dart';

ThemeData sDarkTheme = ThemeData(
  scaffoldBackgroundColor: SColorsDark().grey5,
  textTheme: TextTheme(
    // default text style
    bodyText2: TextStyle(
      color: SColorsDark().white,
    ),
  ),
  fontFamily: 'Gilroy',
);
