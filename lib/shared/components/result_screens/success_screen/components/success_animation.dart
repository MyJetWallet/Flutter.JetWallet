import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rive/rive.dart';

import '../../../../constants.dart';

class SuccessAnimation extends StatelessWidget {
  const SuccessAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: 320.r,
          height: 320.r,
          child: const RiveAnimation.asset(successAnimationAsset),
        ),
      ],
    );
  }
}
