import 'package:flutter/material.dart';

import '../../colors/view/simple_colors_light.dart';

ThemeData sLightTheme = ThemeData(
  scaffoldBackgroundColor: SColorsLight().white,
  textTheme: TextTheme(
    // default text style
    bodyText2: TextStyle(
      color: SColorsLight().black,
    ),
  ),
  fontFamily: 'Gilroy',
);
