import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// ! 1) For some reason scaffoldBackgroundColor doesn't set globally
/// ! 2) For some reason fontFamily doesn't set globally
/// ! INVESTIGATE
CupertinoThemeData sDarkTheme = const CupertinoThemeData(
  scaffoldBackgroundColor: Color(0xFFF1F4F8),
  textTheme: CupertinoTextThemeData(
    textStyle: TextStyle(
      color: Colors.white,
      fontFamily: 'Gilroy',
    ),
  ),
);
