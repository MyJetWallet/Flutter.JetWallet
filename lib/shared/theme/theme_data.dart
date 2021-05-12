import 'package:flutter/material.dart';

import '../constants/ui.dart';

final appTheme = ThemeData(
  primaryColor: primaryColor,
  scaffoldBackgroundColor: backgroundColor,
  brightness: Brightness.dark,
  buttonTheme: ButtonThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    ),
    buttonColor: primaryColor,
  ),
);
