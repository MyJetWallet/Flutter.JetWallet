import 'package:flutter/material.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'simple_confirm_action_timer_painter.dart';

class SConfirmActionTimer extends StatelessWidget {
  const SConfirmActionTimer({
    super.key,
    required this.loading,
    required this.animation,
  });

  final bool loading;
  final AnimationController animation;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Container(
            width: 16.0,
            height: 16.0,
            padding: const EdgeInsets.all(1.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: SColorsLight().green.withOpacity(0.2),
            ),
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              color: SColorsLight().green,
            ),
          )
        : CustomPaint(
            size: const Size(16.0, 16.0),
            painter: SConfirmActionTimerPainter(
              animation: animation,
              fillColor: SColorsLight().green,
              backgroundColor: SColorsLight().green.withOpacity(0.2),
            ),
          );
  }
}
