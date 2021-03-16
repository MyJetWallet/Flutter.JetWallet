import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:jetwallet/global/const.dart';

final globalSpotTheme = ThemeData(
    primaryColor: primColor,
    scaffoldBackgroundColor: backColor,
    brightness: Brightness.dark,

    /* TODO: Solve Google fonts conflict
    fontFamily: GoogleFonts.notoSans().fontFamily,
    textTheme: GoogleFonts.notoSansTextTheme(
      ThemeData(brightness: Brightness.dark).textTheme,
    ),*/
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
      buttonColor: primColor,
    ));
