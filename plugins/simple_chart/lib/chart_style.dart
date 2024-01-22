import 'package:flutter/material.dart' show Color, Colors;

class ChartColors {
  static const Color bgColor = Color(0xff272937);
  static const Color kLineColor = Color(0xff07fff2);
  static const Color gridColor = Color(0xff4f525e);
  static const List<Color> kLineShadowColor = [
    Color(0xff07FFF2),
    Color(0x1A07FFF2),
  ]; //gradient kline
  static const Color upColor = Color(0xff21b3a4);
  static const Color dnColor = Color(0xffec165c);

  static const Color yAxisTextColor = Color(0xff60738E);
  static const Color xAxisTextColor = Color(0xff60738E);

  static const Color maxMinTextColor = Colors.grey;

  static const Color markerBorderColor = Color(0xff6C7A86);

  static const Color markerBgColor = Color(0xff0D1722);

  static const Color realTimeBgColor = Color(0xffffffff);
  static const Color rightRealTimeTextColor = Color(0xff4C86CD);
  static const Color realTimeTextBorderColor = Color(0xffffffff);
  static const Color realTimeTextColor = Color(0xff272937);

  static const Color realTimeLineColor = Color(0xffffffff);
  static const Color realTimeLongLineColor = Color(0xff4C86CD);

  static const Color positiveChartColor = Color(0xFF0BCA1E);
  static const Color negativeChartColor = Color(0xFFF50537);
  static const Color equalChartColor = Color(0xFF000000);
  static const Color positiveChartBgColor = Color(0x80E8F9E8);
  static const Color negativeChartBgColor = Color(0x80FAF2EE);
  static const Color equalChartBgColor = Color(0x80F1F4F8);
  static const Color dashedLineColor = Color(0xFFE0E5EB);
  static const Color loadingBackgroundColor = Color(0xFFF1F4F8);
}

class ChartStyle {
  //Vertical cross line width
  static const double vCrossWidth = 1.0;

  //Horizontal cross line width
  static const double hCrossWidth = 0.5;

  static const int gridRows = 3;
  static const int gridColumns = 4;

  static const double topPadding = 20.0;
  static const double bottomDateHigh = 20.0;
  static const double childPadding = 0.0;

  static const double defaultTextSize = 10.0;
}
