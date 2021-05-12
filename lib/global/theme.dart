import 'package:flutter/material.dart';
import 'const.dart';

final globalSpotTheme = ThemeData(
  primaryColor: primColor,
  scaffoldBackgroundColor: backColor,
  brightness: Brightness.dark,
  buttonTheme: ButtonThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    ),
    buttonColor: primColor,
  ),
);
