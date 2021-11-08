import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../auth/shared/components/styles/gradient_colors.dart';

class SuccessImage extends StatelessWidget {
  const SuccessImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 260.r,
          height: 260.r,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              center: Alignment.topLeft,
              radius: 1.5,
              colors: successGradientColors,
            ),
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 25.0.r,
            sigmaY: 25.0.r,
          ),
          child: SizedBox(
            width: 260.r,
            height: 260.r,
          ),
        ),
        Positioned(
          left: 50.r,
          top: 50.r,
          right: 50.r,
          bottom: 50.r,
          child: Container(
            width: 160.r,
            height: 160.r,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: Alignment.bottomLeft,
                radius: 1.5,
                colors: successGradientColors,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
