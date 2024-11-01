import 'dart:math' as math;

import 'package:flutter/material.dart';

@Deprecated('This is a widget from the old ui kit, please use the widget from the new ui kit')
class SConfirmActionTimerPainter extends CustomPainter {
  SConfirmActionTimerPainter({
    required this.animation,
    required this.fillColor,
    required this.backgroundColor,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color fillColor;
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = fillColor;
    final progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, progress, true, paint);
  }

  @override
  bool shouldRepaint(SConfirmActionTimerPainter oldDelegate) {
    return animation.value != oldDelegate.animation.value ||
        fillColor != oldDelegate.fillColor ||
        backgroundColor != oldDelegate.backgroundColor;
  }
}
