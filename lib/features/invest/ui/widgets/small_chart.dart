import 'dart:math';

import 'package:charts/model/candle_model.dart';
import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class SmallChart extends StatelessWidget {
  const SmallChart({
    super.key,
    required this.candles,
    this.height = 30.0,
    this.width = 100.0,
  });

  final List<CandleModel> candles;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    final sampledCandles = sampleCandles(candles);
    return CustomPaint(
      size: Size(width, height),
      painter: _ChartPainter(sampledCandles),
    );
  }

  List<CandleModel> sampleCandles(
    List<CandleModel> candles, {
    int maxCandles = 60,
  }) {
    if (candles.length <= maxCandles) {
      return candles;
    }
    final step = candles.length / maxCandles;
    return List.generate(maxCandles, (index) {
      final idx = (index * step).floor();
      return candles[idx];
    });
  }
}

class _ChartPainter extends CustomPainter {
  _ChartPainter(this.candles);
  final List<CandleModel> candles;

  @override
  void paint(Canvas canvas, Size size) {
    if (candles.isEmpty) {
      return;
    }

    final colors = sKit.colors;

    final maxPrice = candles.map((c) => c.high).reduce(max);
    final minPrice = candles.map((c) => c.low).reduce(min);

    final priceDiff = maxPrice - minPrice;
    final scale = size.height / priceDiff;

    final overallTrendColor = candles.last.close >= candles.first.open ? colors.red : colors.green;

    final linePaint = Paint()
      ..color = overallTrendColor
      ..strokeWidth = 1.0;

    for (var i = 0; i < candles.length - 1; i++) {
      final x1 = size.width - (size.width * i / candles.length);
      final y1 = size.height - (candles[i].close - minPrice) * scale;
      final x2 = size.width - (size.width * (i + 1) / candles.length);
      final y2 = size.height - (candles[i + 1].close - minPrice) * scale;

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
