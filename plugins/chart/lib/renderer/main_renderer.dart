import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../chart_style.dart';
import '../entity/candle_entity.dart';
import '../entity/candle_type_enum.dart';
import 'base_chart_renderer.dart';

class MainRenderer extends BaseChartRenderer<CandleEntity> {
  MainRenderer(
    Rect? mainRect,
    double maxValue,
    double minValue,
    double topPadding,
    this.candleType,
    this.candleWidth,
    this.chartColor,
    double scaleX,
  ) : super(
          chartRect: mainRect,
          maxValue: maxValue,
          minValue: minValue,
          topPadding: topPadding,
          scaleX: scaleX,
        ) {
    final diff = maxValue - minValue;
    final newScaleY = (chartRect!.height - _contentPadding) /
        diff; //Content area height/difference = new scale
    final newDiff =
        chartRect!.height / newScaleY; //High/new ratio = new difference
    final value = (newDiff - diff) /
        2; //New difference-difference / 2 = the value to be expanded on the y axis
    if (newDiff > diff) {
      scaleY = newScaleY;
      this.maxValue += value;
      this.minValue -= value;
    }
  }

  final ChartType? candleType;
  final double candleWidth;

  final double _contentPadding = 12.0;

  final Color chartColor;

  @override
  void drawText(Canvas canvas, CandleEntity data, double x) {
    switch (candleType) {
      case ChartType.area:
      case ChartType.line:
      case ChartType.candle:
        TextSpan? span;
        if (span == null) return;
        final tp = TextPainter(text: span, textDirection: TextDirection.ltr);
        tp.layout();
        tp.paint(canvas, Offset(x, chartRect!.top - topPadding));
        break;
      default:
    }
  }

  @override
  void drawChart(
    CandleEntity lastPoint,
    CandleEntity curPoint,
    CandleEntity firstPoint,
    double lastX,
    double curX,
    Size size,
    Canvas canvas,
  ) {
    switch (candleType) {
      case ChartType.candle:
        drawCandle(curPoint, canvas, curX);
        break;

      case ChartType.area:
        drawArea(lastPoint.close, curPoint.close, canvas, lastX, curX);
        break;

      case ChartType.line:
        drawLineChart(
          lastPoint.close,
          curPoint.close,
          firstPoint.close,
          canvas,
          lastX,
          curX,
        );
        break;

      default:
    }
  }

  void drawArea(
    double lastPrice,
    double curPrice,
    Canvas canvas,
    double lastX,
    double curX,
  ) {
    const mAreaLineStrokeWidth = 1.0;
    final mAreaPaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..color = ChartColors.kLineColor;
    final mAreaFillPaint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    final mAreaPath = Path();

    // ignore: parameter_assignments
    if (lastX == curX) lastX = 0; //Start position filling

    mAreaPath.moveTo(lastX, getY(lastPrice));
    mAreaPath.cubicTo(
      (lastX + curX) / 2,
      getY(lastPrice),
      (lastX + curX) / 2,
      getY(
        curPrice,
      ),
      curX,
      getY(curPrice),
    );

    //Draw shadows
    final mAreaFillShader = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: ChartColors.kLineShadowColor,
    ).createShader(
      Rect.fromLTRB(
        chartRect!.left,
        chartRect!.top,
        chartRect!.right,
        chartRect!.bottom,
      ),
    );
    mAreaFillPaint.shader = mAreaFillShader;

    final mAreaFillPath = Path();

    mAreaFillPath.moveTo(lastX, chartRect!.height + chartRect!.top);
    mAreaFillPath.lineTo(lastX, getY(lastPrice));
    mAreaFillPath.cubicTo(
      (lastX + curX) / 2,
      getY(lastPrice),
      (lastX + curX) / 2,
      getY(curPrice),
      curX,
      getY(curPrice),
    );
    mAreaFillPath.lineTo(curX, chartRect!.height + chartRect!.top);
    mAreaFillPath.close();

    canvas.drawPath(mAreaFillPath, mAreaFillPaint);
    mAreaFillPath.reset();

    canvas.drawPath(
      mAreaPath,
      mAreaPaint
        ..strokeWidth = (mAreaLineStrokeWidth / scaleX!).clamp(0.3, 1.0),
    );
    mAreaPath.reset();
  }

  void drawLineChart(
    double lastPrice,
    double curPrice,
    double firstPrice,
    Canvas canvas,
    double lastX,
    double curX,
  ) {
    final mLinePaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke;
    final mLineFillPaint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    final mLinePath = Path();

    // ignore: parameter_assignments
    if (lastX == curX) lastX = 0; //Start position filling

    mLinePath.moveTo(lastX, getY(lastPrice));
    mLinePath.cubicTo(
      (lastX + curX) / 2,
      getY(lastPrice),
      (lastX + curX) / 2,
      getY(curPrice),
      curX,
      getY(curPrice),
    );

    final mLineFillPath = Path();

    mLineFillPath.moveTo(lastX, chartRect!.height + chartRect!.top);

    mLineFillPath.lineTo(curX, chartRect!.height + chartRect!.top);
    mLineFillPath.close();

    canvas.drawPath(mLineFillPath, mLineFillPaint);
    mLineFillPath.reset();

    canvas.drawPath(
      mLinePath,
      mLinePaint
        ..strokeWidth = 2.w
        ..color = chartColor,
    );
    mLinePath.reset();
  }

  void drawCandle(CandleEntity curPoint, Canvas canvas, double curX) {
    final high = getY(curPoint.high);
    final low = getY(curPoint.low);
    var open = getY(curPoint.open);
    var close = getY(curPoint.close);
    final r = candleWidth / 2;
    final lineR = candleWidth / 2;

    //Prevent the line from being too thin and force the thinnest 1px
    if ((open - close).abs() < 1) {
      if (open > close) {
        open += 0.5;
        close -= 0.5;
      } else {
        open -= 0.5;
        close += 0.5;
      }
    }
    if (open > close) {
      chartPaint.color = ChartColors.upColor;
      canvas.drawRect(
        Rect.fromLTRB(curX - r, close, curX + r, open),
        chartPaint,
      );
      canvas.drawRect(
        Rect.fromLTRB(curX - lineR, high, curX + lineR, low),
        chartPaint,
      );
    } else {
      chartPaint.color = ChartColors.dnColor;
      canvas.drawRect(
        Rect.fromLTRB(curX - r, open, curX + r, close),
        chartPaint,
      );
      canvas.drawRect(
        Rect.fromLTRB(curX - lineR, high, curX + lineR, low),
        chartPaint,
      );
    }
  }

  @override
  void drawRightText(Canvas canvas, TextStyle textStyle, int gridRows) {
    // final rowSpace = chartRect!.height / gridRows;
    // for (var i = 0; i <= gridRows; ++i) {
    //   var position = 0.0;
    //   if (i == 0) {
    //     position = (gridRows - i) * rowSpace - _contentPadding / 2;
    //   } else if (i == gridRows) {
    //     position = (gridRows - i) * rowSpace + _contentPadding / 2;
    //   } else {
    //     position = (gridRows - i) * rowSpace;
    //   }
    //   final value = position / scaleY! + minValue;
    //   final span = TextSpan(text: format(value), style: textStyle);
    //   final tp = TextPainter(text: span, textDirection: TextDirection.ltr);
    //   tp.layout();
    //   double y;
    //   if (i == 0 || i == gridRows) {
    //     y = getY(value) - tp.height / 2;
    //   } else {
    //     y = getY(value) - tp.height;
    //   }
    //   tp.paint(canvas, Offset(chartRect!.width - tp.width, y));
    // }
  }

  @override
  void drawGrid(Canvas canvas, int gridRows, int gridColumns) {
    final rowSpace = chartRect!.height / gridRows;
    for (var i = 0; i <= gridRows; i++) {
      canvas.drawLine(
        Offset(0, rowSpace * i + topPadding),
        Offset(chartRect!.width, rowSpace * i + topPadding),
        gridPaint,
      );
    }
    final columnSpace = chartRect!.width / gridColumns;
    for (var i = 0; i <= columnSpace; i++) {
      canvas.drawLine(
        Offset(columnSpace * i, topPadding / 3),
        Offset(columnSpace * i, chartRect!.bottom),
        gridPaint,
      );
    }
  }
}
