import 'dart:async' show StreamSink;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../model/candle_model.dart';
import '../model/candle_type_enum.dart';
import '../model/chart_info_model.dart';
import '../model/info_window_model.dart';
import '../model/resolution_string_enum.dart';
import 'base_chart_painter.dart';
import 'base_chart_renderer.dart';
import 'main_renderer.dart';

class ChartPainter extends BaseChartPainter {
  ChartPainter({
    required List<CandleModel> datas,
    required double scaleX,
    required double scrollX,
    required bool isLongPass,
    required double selectX,
    this.sink,
    required ChartType candleType,
    required String resolution,
    required double candleWidth,
    this.controller,
    this.opacity = 0.0,
    required this.onCandleSelected,
  }) : super(
          datas: datas,
          scaleX: scaleX,
          scrollX: scrollX,
          isLongPress: isLongPass,
          selectX: selectX,
          candleType: candleType,
          candleWidth: candleWidth,
          resolution: resolution,
        );

  static double get maxScrollX => BaseChartPainter.maxScrollX;
  BaseChartRenderer? mMainRenderer;
  StreamSink<InfoWindowModel?>? sink;
  AnimationController? controller;
  double opacity;
  final Function(ChartInfoModel) onCandleSelected;
  late Color chartColor;

  @override
  void initChartRenderer() {
    if (isLongPress) {
      chartColor = Colors.black;
    } else {
      chartColor = Colors.white;
      if (datas.isNotEmpty) {
        chartColor = datas.first.close > datas.last.close
            ? ChartColors.negativeChartColor
            : ChartColors.positiveChartColor;
      }
    }

    mMainRenderer ??= MainRenderer(
      mMainRect,
      mMainMaxValue,
      mMainMinValue,
      ChartStyle.topPadding,
      candleType,
      candleWidth,
      chartColor,
      scaleX,
    );
  }

  final Paint mBgPaint = Paint()..color = Colors.transparent;

  @override
  void drawBg(Canvas canvas, Size size) {
    if (mMainRect != null) {
      final mainRect = Rect.fromLTRB(
        0,
        0,
        mMainRect!.width,
        mMainRect!.height + ChartStyle.topPadding,
      );
      canvas.drawRect(mainRect, mBgPaint);
    }
    final dateRect = Rect.fromLTRB(
      0,
      size.height - ChartStyle.bottomDateHigh,
      size.width,
      size.height,
    );
    canvas.drawRect(dateRect, mBgPaint);
  }

  @override
  void drawGrid(Canvas canvas) {
    // mMainRenderer?.drawGrid(
    //     canvas, ChartStyle.gridRows, ChartStyle.gridColumns);
  }

  @override
  void drawChart(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(mTranslateX * scaleX, 0.0);
    canvas.scale(scaleX, 1.0);
    for (var i = mStartIndex; i <= mStopIndex; i++) {
      final curPoint = datas[i];
      //TODO(Vova): Check this line
      if (curPoint == null) continue;
      final lastPoint = i == 0 ? curPoint : datas[i - 1];
      final firstPoint = i == 0 ? curPoint : datas[i];
      final curX = getX(i);
      final lastX = i == 0 ? curX : getX(i - 1);

      mMainRenderer?.drawChart(
        lastPoint,
        curPoint,
        firstPoint,
        lastX,
        curX,
        size,
        canvas,
      );
    }

    if (isLongPress == true) drawCrossLine(canvas, size);
    canvas.restore();
  }

  @override
  void drawRightText(Canvas canvas) {
    // final textStyle = getTextStyle(ChartColors.yAxisTextColor);
    // mMainRenderer?.drawRightText(canvas, textStyle, ChartStyle.gridRows);
  }

  @override
  void drawDate(Canvas canvas, Size size) {
    // final columnSpace = size.width / ChartStyle.gridColumns;
    // final startX = getX(mStartIndex) - mPointWidth / 2;
    // final stopX = getX(mStopIndex) + mPointWidth / 2;
    // var y = 0.0;
    // for (var i = 0; i <= ChartStyle.gridColumns; ++i) {
    //   final translateX = xToTranslateX(columnSpace * i);
    //   if (translateX >= startX && translateX <= stopX) {
    //     final index = indexOfTranslateX(translateX);
    //     //TODO(Vova): check this line
    //     // if (datas[index] == null) continue;
    //     final tp = getTextPainter(getDate(datas[index].date),
    //         color: ChartColors.xAxisTextColor);
    //     y = size.height -
    //         (ChartStyle.bottomDateHigh - tp.height) / 2 -
    //         tp.height;
    //     tp.paint(canvas, Offset(columnSpace * i - tp.width / 2, y));
    //   }
    // }
  }

  Paint selectPointPaint = Paint()
    ..isAntiAlias = true
    ..strokeWidth = 0.5
    ..color = ChartColors.markerBgColor;
  Paint selectorBorderPaint = Paint()
    ..isAntiAlias = true
    ..strokeWidth = 0.5
    ..style = PaintingStyle.stroke
    ..color = ChartColors.markerBorderColor;

  @override
  void drawCrossLineText(Canvas canvas, Size size) {
    final index = calculateSelectedX(selectX);
    final point = getItem(index) as CandleModel;

    onCandleSelected(
      ChartInfoModel(
        left: datas[0],
        right: datas[index],
        candleResolution: resolution,
      ),
    );

    final tp = getTextPainter(format(point.close));
    var textWidth = tp.width;

    const w1 = 5;
    var y = getMainY(point.close);
    double x;
    const isLeft = false;
    // if (translateXtoX(getX(index)) < mWidth / 2) {
    //   isLeft = false;
    //   x = 1;
    //   final path = Path();
    //   path.moveTo(x, y - r);
    //   path.lineTo(x, y + r);
    //   path.lineTo(textWidth + 2 * w1, y + r);
    //   path.lineTo(textWidth + 2 * w1 + w2, y);
    //   path.lineTo(textWidth + 2 * w1, y - r);
    //   path.close();
    //   canvas.drawPath(path, selectPointPaint);
    //   canvas.drawPath(path, selectorBorderPaint);
    //   tp.paint(canvas, Offset(x + w1, y - textHeight / 2));
    // } else {
    //   isLeft = true;
    //   x = mWidth - textWidth - 1 - 2 * w1 - w2;
    //   final path = Path();
    //   path.moveTo(x, y);
    //   path.lineTo(x + w2, y + r);
    //   path.lineTo(mWidth - 2, y + r);
    //   path.lineTo(mWidth - 2, y - r);
    //   path.lineTo(x + w2, y - r);
    //   path.close();
    //   canvas.drawPath(path, selectPointPaint);
    //   canvas.drawPath(path, selectorBorderPaint);
    //   tp.paint(canvas, Offset(x + w1 + w2, y - textHeight / 2));
    // }

    final dateTp = getTextPainter(getDate(point.date));
    textWidth = dateTp.width;
    x = translateXtoX(getX(index));
    y = 0 + ChartStyle.bottomDateHigh;

    if (x < textWidth + 2 * w1) {
      x = 1 + textWidth / 2 + w1;
    } else if (mWidth - x < textWidth + 2 * w1) {
      x = mWidth - 1 - textWidth / 2 - w1;
    }
    // canvas.drawRect(
    //   Rect.fromLTRB(
    //     x - textWidth / 2 - w1,
    //     y,
    //     x + textWidth / 2 + w1,
    //     y + baseLine + r,
    //   ),
    //   selectPointPaint,
    // );
    // canvas.drawRect(
    //   Rect.fromLTRB(
    //     x - textWidth / 2 - w1,
    //     y,
    //     x + textWidth / 2 + w1,
    //     y + baseLine + r,
    //   ),
    //   selectorBorderPaint,
    // );

    dateTp.paint(canvas, Offset(x - textWidth / 2, y));
    //Long press to show the details of this data
    sink?.add(InfoWindowModel(point, isLeft: isLeft));
  }

  @override
  void drawText(Canvas canvas, CandleModel data, double x) {
    //Long press to display the data being pressed
    if (isLongPress) {
      final index = calculateSelectedX(selectX);
      // ignore: parameter_assignments
      data = getItem(index) as CandleModel;
    }
    //Release to display the last data
    mMainRenderer?.drawText(canvas, data, x);
  }

  @override
  void drawMaxAndMin(Canvas canvas) {
    if (!isLongPress) {
      //Plot the maximum and minimum values
      const x = 0.0;
      var y = getMainY(mMainLowMinValue!) + 20.h;
      if (x < mWidth / 2) {
        //Draw right
        final tp = getTextPainter(
          format(mMainLowMinValue!),
          color: ChartColors.maxMinTextColor,
        );
        tp.paint(canvas, Offset(x, y - tp.height / 2));
      } else {
        final tp = getTextPainter(
          format(mMainLowMinValue!),
          color: ChartColors.maxMinTextColor,
        );
        tp.paint(canvas, Offset(x - tp.width, y - tp.height / 2));
      }
      y = getMainY(mMainHighMaxValue!) - 20.h;
      if (x < mWidth / 2) {
        //Draw right
        final tp = getTextPainter(
          format(mMainHighMaxValue!),
          color: ChartColors.maxMinTextColor,
        );
        tp.paint(canvas, Offset(x, y - tp.height / 2));
      } else {
        final tp = getTextPainter(
          format(mMainHighMaxValue!),
          color: ChartColors.maxMinTextColor,
        );
        tp.paint(canvas, Offset(x - tp.width, y - tp.height / 2));
      }
    }
  }

  void drawCrossLine(Canvas canvas, Size size) {
    final index = calculateSelectedX(selectX);
    final point = getItem(index) as CandleModel;
    final paintY = Paint()
      ..color = const Color(0xFFA8B0BA)
      ..strokeWidth = ChartStyle.vCrossWidth
      ..isAntiAlias = true;
    final x = getX(index);
    final y = getMainY(point.close);
    // k-line graph vertical line
    canvas.drawLine(
      Offset(x, 40.h),
      Offset(x, size.height - ChartStyle.bottomDateHigh),
      paintY,
    );

    final paintX = Paint()
      ..color = Colors.black
      ..strokeWidth = ChartStyle.hCrossWidth
      ..isAntiAlias = true;
    // k-line graph horizontal line
    // canvas.drawLine(Offset(-mTranslateX, y),
    //     Offset(-mTranslateX + mWidth / scaleX, y), paintX);
    canvas.drawCircle(Offset(x, y), 3.r, paintX);
    // canvas.drawOval(
    //   Rect.fromCenter(
    //     center: Offset(x, y),
    //     height: 2.0 * scaleX,
    //     width: 2.0,
    //   ),
    //   paintX,
    // );
  }

  final Paint realTimePaint = Paint()
    ..strokeWidth = 1.0
    ..isAntiAlias = true;
  final Paint pointPaint = Paint();

  @override
  void drawRealTimePrice(Canvas canvas, Size size) {
    if (mMarginRight == 0 || datas.isEmpty == true) return;
    final point = datas.last;
    // var tp = getTextPainter(format(point.close!),
    //     color: ChartColors.rightRealTimeTextColor);
    final y = getMainY(point.close);
    // //The more the max slides to the right, the smaller the value
    final max =
        (mTranslateX.abs() + mMarginRight - getMinTranslateX().abs() + 2.r) *
            scaleX;
    final x = mWidth - max;
    // if (candleType == ChartType.candle) x += mPointWidth / 2;
    // const dashWidth = 10;
    // const dashSpace = 5;
    // var startX = 0.0;
    // const space = dashSpace + dashWidth;
    // if (tp.width < max) {
    //   while (startX < max) {
    //     canvas.drawLine(
    //         Offset(x + startX, y),
    //         Offset(x + startX + dashWidth, y),
    //         realTimePaint..color = ChartColors.realTimeLineColor);
    //     startX += space;
    //   }
    // Flash and flash point last price
    if (candleType == ChartType.area || candleType == ChartType.line) {
      // startAnimation();
      // final Gradient pointGradient = RadialGradient(
      //     colors: [Colors.white.withOpacity(opacity), Colors.transparent]);
      // pointPaint.shader = pointGradient
      //     .createShader(Rect.fromCircle(center: Offset(x, y), radius: 14.0));
      // canvas.drawCircle(Offset(x, y), 14.0, pointPaint);
      canvas.drawCircle(Offset(x, y), 3.r, realTimePaint..color = chartColor);
    } else {
      // stopAnimation(); //Stop flashing
    }
    //   final left = mWidth - tp.width;
    //   final top = y - tp.height / 2;
    //   canvas.drawRect(
    //       Rect.fromLTRB(left, top, left + tp.width, top + tp.height),
    //       realTimePaint..color = ChartColors.realTimeBgColor);
    //   // tp.paint(canvas, Offset(left, top));
    // } else {
    //   stopAnimation(); //Stop flashing
    //   startX = 0;
    //
    //   // TODO: autofitting to window
    //   if (point.close! > mMainMaxValue) {
    //     y = getMainY(mMainMaxValue);
    //   } else if (point.close! < mMainMinValue) {
    //     y = getMainY(mMainMinValue);
    //   }
    //
    //   while (startX < mWidth) {
    //     canvas.drawLine(Offset(startX, y), Offset(startX + dashWidth, y),
    //         realTimePaint..color = ChartColors.realTimeLongLineColor);
    //     startX += space;
    //   }
    //
    //   const padding = 3.0;
    //   const triangleHeight = 8.0;
    //   const triangleWidth = 5.0;
    //
    //   final left =
    //       mWidth - mWidth / ChartStyle.gridColumns - tp.width / 2 - padding * 2;
    //   final top = y - tp.height / 2 - padding;
    //   //Plus the width of the triangle and padding
    //   final right = left + tp.width + padding * 2 + triangleWidth + padding;
    //   final bottom = top + tp.height + padding * 2;
    //   final radius = (bottom - top) / 2;
    //   //Draw an ellipse background
    //   final rectBg1 =
    //       RRect.fromLTRBR(left, top, right, bottom, Radius.circular(radius));
    // final rectBg2 = RRect.fromLTRBR(
    //   left - 1,
    //   top - 1,
    //   right + 1,
    //   bottom + 1,
    //   Radius.circular(radius + 2),
    // );
    // canvas.drawRRect(
    //   rectBg2,
    //   realTimePaint..color = ChartColors.realTimeTextBorderColor,
    // );
    //   canvas.drawRRect(
    //       rectBg1, realTimePaint..color = ChartColors.realTimeBgColor);
    //   tp = getTextPainter(format(point.close!),
    //       color: ChartColors.realTimeTextColor);
    //   final textOffset = Offset(left + padding, y - tp.height / 2);
    //   // tp.paint(canvas, textOffset);
    //   //Draw a triangle
    //   final path = Path();
    //   final dx = tp.width + textOffset.dx + padding;
    //   final dy = top + (bottom - top - triangleHeight) / 2;
    //   path.moveTo(dx, dy);
    //   path.lineTo(dx + triangleWidth, dy + triangleHeight / 2);
    //   path.lineTo(dx, dy + triangleHeight);
    //   path.close();
    //   canvas.drawPath(
    //       path,
    //       realTimePaint
    //         ..color = ChartColors.realTimeTextColor
    //         ..shader = null);
    // }
  }

  TextPainter getTextPainter(String text, {Color color = Colors.white}) {
    final span = TextSpan(
      text: text,
      style: TextStyle(
        color: const Color(0xFFA8B0BA),
        fontWeight: FontWeight.w500,
        fontSize: 12.sp,
      ),
    );
    final tp = TextPainter(text: span, textDirection: ui.TextDirection.ltr);
    tp.layout();
    return tp;
  }

  String getDate(int? date) {
    final localDate = DateTime.fromMillisecondsSinceEpoch(
      date!,
      isUtc: true,
    ).toLocal();

    switch (resolution) {
      case Period.day:
        return DateFormat.Hm().format(localDate);

      case Period.week:
        return '${DateFormat.yMMMd().format(localDate)}'
            ', ${DateFormat.Hm().format(localDate)}';

      case Period.month:
        return '${DateFormat.yMMMd().format(localDate)}'
            ', ${DateFormat.Hm().format(localDate)}';

      case Period.year:
        return '${DateFormat.yMMMd().format(localDate)}'
            ', ${DateFormat.Hm().format(localDate)}';

      case Period.all:
        return '${DateFormat.yMMMd().format(localDate)}'
            ', ${DateFormat.Hm().format(localDate)}';

      default:
        return '';
    }
  }

  String isoWeekNumber(DateTime date) {
    final daysToAdd = DateTime.thursday - date.weekday;
    final thursdayDate = daysToAdd > 0
        ? date.add(Duration(days: daysToAdd))
        : date.subtract(Duration(days: daysToAdd.abs()));
    final dayOfYearThursday = dayOfYear(thursdayDate);
    return '${1 + ((dayOfYearThursday - 1) / 7).floor()}';
  }

  int dayOfYear(DateTime date) {
    return date.difference(DateTime(date.year)).inDays;
  }

  double getMainY(double y) => mMainRenderer?.getY(y) ?? 0.0;

  void startAnimation() {
    if (controller?.isAnimating != true) controller?.repeat(reverse: true);
  }

  void stopAnimation() {
    if (controller?.isAnimating == true) controller?.stop();
  }
}
