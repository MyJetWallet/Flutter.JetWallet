import 'package:flutter/material.dart';

import '../chart_style.dart';
import '../utils/number_util.dart';

export '../chart_style.dart';

abstract class BaseChartRenderer<T> {
  BaseChartRenderer({
    required this.chartRect,
    required this.maxValue,
    required this.minValue,
    required this.topPadding,
    required this.scaleX,
  }) {
    if (maxValue == minValue) {
      maxValue += 0.5;
      minValue -= 0.5;
    }
    scaleY = chartRect!.height / (maxValue - minValue);
  }

  double maxValue;
  double minValue;
  double? scaleY;
  double? scaleX;
  double topPadding;
  Rect? chartRect;
  final Paint chartPaint = Paint()
    ..isAntiAlias = true
    ..filterQuality = FilterQuality.high
    ..strokeWidth = 1.0
    ..color = Colors.red;
  final Paint gridPaint = Paint()
    ..isAntiAlias = true
    ..filterQuality = FilterQuality.high
    ..strokeWidth = 0.5
    ..color = ChartColors.gridColor;

  double getY(double y) {
    return (maxValue - y) * scaleY! + chartRect!.top;
  }

  String format(double n) {
    return NumberUtil.format(n);
  }

  void drawGrid(Canvas canvas, int gridRows, int gridColumns);

  void drawText(Canvas canvas, T data, double x);

  void drawRightText(Canvas canvas, TextStyle textStyle, int gridRows);

  void drawChart(
    T lastPoint,
    T curPoint,
    T firstPoint,
    double lastX,
    double curX,
    Size size,
    Canvas canvas, {
    required bool isLast,
  });

  void drawLine(
    double lastPrice,
    double curPrice,
    Canvas canvas,
    double lastX,
    double curX,
    Color color,
  ) {
    final lastY = getY(lastPrice);
    final curY = getY(curPrice);
    canvas.drawLine(
      Offset(lastX, lastY),
      Offset(curX, curY),
      chartPaint..color = color,
    );
  }

  TextStyle getTextStyle(Color color) {
    return TextStyle(fontSize: ChartStyle.defaultTextSize, color: color);
  }
}
