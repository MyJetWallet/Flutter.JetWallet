import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// ! 1) For some reason scaffoldBackgroundColor doesn't set globally
/// ! 2) For some reason fontFamily doesn't set globally
/// ! INVESTIGATE
CupertinoThemeData sLightTheme = const CupertinoThemeData(
  scaffoldBackgroundColor: Colors.white,
  textTheme: CupertinoTextThemeData(
    textStyle: TextStyle(
      color: Colors.black,
      fontFamily: 'Gilroy',
    ),
  ),
);
