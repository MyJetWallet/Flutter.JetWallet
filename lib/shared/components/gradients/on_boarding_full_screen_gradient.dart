import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../auth/shared/components/styles/gradient_colors.dart';

class OnBoardingFullScreenGradient extends StatelessWidget {
  const OnBoardingFullScreenGradient({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: onBoardingGradientColors,
        ),
      ),
      child: child,
    );
  }
}
