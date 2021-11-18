import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../simple_kit.dart';
import 'simple_confirm_action_timer_painter.dart';

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
        width: 16.w,
        height: 16.w,
        padding: EdgeInsets.all(1.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: SColorsLight().green.withOpacity(0.2),
        ),
        child: CircularProgressIndicator(
          strokeWidth: 2.w,
          color: SColorsLight().green,
        ),
      );
    } else {
      return CustomPaint(
        size: Size(16.w, 16.w),
        painter: SConfirmActionTimerPainter(
          animation: animation,
          fillColor: SColorsLight().green,
          backgroundColor: SColorsLight().green.withOpacity(0.2),
        ),
      );
    }
  }
}
