import 'dart:math';

import 'package:flutter/material.dart' show Canvas, Color, CustomPainter, Rect, Size, TextStyle;

import '../chart_style.dart' show ChartStyle;
import '../model/candle_model.dart';
import '../model/candle_type_enum.dart';
import '../utils/number_util.dart';

export 'package:flutter/material.dart' show Canvas, Color, CustomPainter, Rect, Size, TextStyle, required;

abstract class BaseChartPainter extends CustomPainter {
  BaseChartPainter({
    required this.datas,
    required this.candleWidth,
    required this.scaleX,
    required this.scrollX,
    required this.isLongPress,
    required this.selectX,
    required this.candleType,
    required this.resolution,
    required this.prefix,
  }) {
    mItemCount = datas.length;
    mDataLen = mItemCount * candleWidth;
  }

  static double maxScrollX = 0.0;
  List<CandleModel> datas;
  double candleWidth;
  double scaleX = 1.0;
  double scrollX = 0.0;
  double selectX;
  bool isLongPress = false;
  ChartType candleType = ChartType.candle;
  String prefix;

  Rect? mMainRect;
  double mDisplayHeight = 0.0;
  double mWidth = 0.0;

  int mStartIndex = 0;
  int mStopIndex = 0;
  double mMainMaxValue = -double.maxFinite;
  double mMainMinValue = double.maxFinite;
  double mVolMaxValue = -double.maxFinite;
  double mVolMinValue = double.maxFinite;
  double mSecondaryMaxValue = -double.maxFinite;
  double mSecondaryMinValue = double.maxFinite;
  double mTranslateX = -double.maxFinite;
  int mMainMaxIndex = 0;
  int mMainMinIndex = 0;
  double? mMainHighMaxValue = -double.maxFinite;
  double? mMainLowMinValue = double.maxFinite;
  int mItemCount = 0;
  double mDataLen = 0.0; //Data occupies the total length of the screen
  double mMarginRight = 0.0;

  String resolution; //The distance vacated on the right side of the k line

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTRB(0, 0, size.width, size.height + 1));
    mDisplayHeight = size.height - ChartStyle.topPadding - ChartStyle.bottomDateHigh;
    mWidth = size.width + 10;
    initRect(size);
    calculateValue();
    initChartRenderer();

    canvas.save();
    canvas.scale(1, 1);
    drawBg(canvas, size);
    drawGrid(canvas);
    if (datas.isNotEmpty) {
      drawChart(canvas, size);
      drawRightText(canvas);
      drawRealTimePrice(canvas, size);
      drawDate(canvas, size);
      if (isLongPress == true) drawCrossLineText(canvas, size);
      drawText(canvas, datas.last, 5);
      drawMaxAndMin(canvas);
    }
    canvas.restore();
  }

  void initChartRenderer();

  void drawBg(Canvas canvas, Size size);

  void drawGrid(Canvas canvas);

  void drawChart(Canvas canvas, Size size);

  void drawRightText(Canvas canvas);

  void drawDate(Canvas canvas, Size size);

  void drawText(Canvas canvas, CandleModel data, double x);

  void drawMaxAndMin(Canvas canvas);

  void drawCrossLineText(Canvas canvas, Size size);

  void initRect(Size size) {
    final mainHeight = mDisplayHeight;

    mMainRect = Rect.fromLTRB(
      0,
      ChartStyle.topPadding,
      mWidth,
      ChartStyle.topPadding + mainHeight - 20,
    );
  }

  void calculateValue() {
    if (datas.isEmpty) return;
    maxScrollX = getMinTranslateX().abs();
    setTranslateXFromScrollX(scrollX);
    mStartIndex = indexOfTranslateX(xToTranslateX(0));
    mStopIndex = indexOfTranslateX(xToTranslateX(mWidth));
    for (var i = mStartIndex; i <= mStopIndex; i++) {
      final item = datas[i];
      getMainMaxMinValue(item, i);
    }
  }

  void getMainMaxMinValue(CandleModel item, int i) {
    switch (candleType) {
      case ChartType.area:
      case ChartType.line:
      // mMainMaxValue = max(mMainMaxValue, item.close!);
      // mMainMinValue = min(mMainMinValue, item.close!);
      // break;
      case ChartType.candle:
        mMainMaxValue = max(mMainMaxValue, item.close);
        mMainMinValue = min(mMainMinValue, item.close);

        if (mMainHighMaxValue! < item.close) {
          mMainHighMaxValue = item.close;
          mMainMaxIndex = i;
        }
        if (mMainLowMinValue! > item.close) {
          mMainLowMinValue = item.close;
          mMainMinIndex = i;
        }
      default:
    }
  }

  double xToTranslateX(double x) => -mTranslateX + x / scaleX;

  int indexOfTranslateX(double translateX) => _indexOfTranslateX(translateX, 0, mItemCount - 1);

  ///Binary search for the index of the current value
  int _indexOfTranslateX(double translateX, int start, int end) {
    if (end == start || end == -1) {
      return start;
    }
    if (end - start == 1) {
      final startValue = getX(start);
      final endValue = getX(end);
      return (translateX - startValue).abs() < (translateX - endValue).abs() ? start : end;
    }
    final mid = start + (end - start) ~/ 2;
    final midValue = getX(mid);
    if (translateX < midValue) {
      return _indexOfTranslateX(translateX, start, mid);
    } else if (translateX > midValue) {
      return _indexOfTranslateX(translateX, mid, end);
    } else {
      return mid;
    }
  }

  ///Get the x coordinate according to the index
  ///+ mPointWidth / 2  Prevent incomplete display of the first and last bar
  ///@param position Index value
  double getX(int position) => position * candleWidth + candleWidth / 2;

  Object getItem(int position) {
    return datas[position];
  }

  ///scrollX Convert to TranslateX
  void setTranslateXFromScrollX(double scrollX) => mTranslateX = scrollX + getMinTranslateX();

  ///Get the minimum value of translation
  double getMinTranslateX() {
    var x = -mDataLen + mWidth / scaleX - candleWidth / 2;
    x = x >= 0 ? 0.0 : x;
    //Less than one screen of data
    if (x >= 0) {
      if (mWidth / scaleX - getX(datas.length) < mMarginRight) {
        //After the data is filled, the remaining space is smaller
        //than mMarginRight, find the difference. x-= difference
        x -= mMarginRight - mWidth / scaleX + getX(datas.length);
      } else {
        //After data is filled, the remaining space is larger than Right
        mMarginRight = mWidth / scaleX - getX(datas.length);
      }
    } else if (x <= 0) {
      //More than one screen of data
      x -= mMarginRight;
    }
    return x >= 0 ? 0.0 : x;
  }

  ///Calculate the value of x after long press and convert it to index
  int calculateSelectedX(double selectX) {
    var mSelectedIndex = indexOfTranslateX(xToTranslateX(selectX));
    if (mSelectedIndex < mStartIndex) {
      mSelectedIndex = mStartIndex;
    }
    if (mSelectedIndex > mStopIndex) {
      mSelectedIndex = mStopIndex;
    }
    return mSelectedIndex;
  }

  ///translateX into x in view
  double translateXtoX(double translateX) => (translateX + mTranslateX) * scaleX;

  TextStyle getTextStyle(Color color) {
    return TextStyle(fontSize: ChartStyle.defaultTextSize, color: color);
  }

  void drawRealTimePrice(Canvas canvas, Size size);

  String format(double n) {
    return '$prefix${NumberUtil.format(n)}';
  }

  @override
  bool shouldRepaint(BaseChartPainter oldDelegate) {
    return true;
  }
}
