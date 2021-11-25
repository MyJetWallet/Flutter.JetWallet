import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rive/rive.dart';

import '../../../../constants.dart';

class FailureAnimation extends StatelessWidget {
  const FailureAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320.r,
      height: 320.r,
      child: const RiveAnimation.asset(
        failureAnimationAsset,
      ),
    );
  }
}
