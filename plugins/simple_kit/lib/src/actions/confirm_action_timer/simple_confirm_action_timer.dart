import 'package:flutter/material.dart';

import '../../../simple_kit.dart';

class SConfirmActionTimer extends StatelessWidget {
  const SConfirmActionTimer({
    Key? key,
    required this.loading,
    required this.animation,
  }) : super(key: key);

  final bool loading;
  final AnimationController animation;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Container(
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
      );
    } else {
      return CustomPaint(
        size: const Size(16.0, 16.0),
        painter: SConfirmActionTimerPainter(
          animation: animation,
          fillColor: SColorsLight().green,
          backgroundColor: SColorsLight().green.withOpacity(0.2),
        ),
      );
    }
  }
}
