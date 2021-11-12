import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rive/rive.dart';

import '../../../../../../simple_kit.dart';
import '../constants.dart';

class LoaderContainer extends StatelessWidget {
  const LoaderContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 97.w,
      right: 98.w,
      top: 320.h,
      child: Container(
        width: 180.w,
        height: 88.h,
        decoration: BoxDecoration(
          color: SColorsLight().white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        padding: EdgeInsets.symmetric(
          vertical: 20.h,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 24.r,
              height: 24.r,
              child: const RiveAnimation.asset(loadingAnimationAsset),
            ),
            Baseline(
              baseline: 20.6.h,
              baselineType: TextBaseline.alphabetic,
              child: Text(
                'Please wait ...',
                style: sBodyText2Style,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
