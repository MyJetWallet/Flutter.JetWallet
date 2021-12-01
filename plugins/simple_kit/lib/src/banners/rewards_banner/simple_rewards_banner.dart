import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../simple_kit.dart';

class SRewardBannerExample extends StatelessWidget {
  const SRewardBannerExample({
    Key? key,
    required this.bannerColor,
    required this.primaryText,
    this.secondaryText,
  }) : super(key: key);

  final Color bannerColor;
  final String primaryText;
  final String? secondaryText;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180.h,
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 20.w,
        bottom: 30.w,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: bannerColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 32.r,
          ),
          const SpaceW20(),
          Column(
            children: [
              SizedBox(
                width: 203.w,
                child: Baseline(
                  baseline: 24.h,
                  baselineType: TextBaseline.alphabetic,
                  child: Text(
                    primaryText,
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    style: sTextH4Style,
                  ),
                ),
              ),
              if (secondaryText != null)
                SizedBox(
                  width: 203.w,
                  child: Baseline(
                    baseline: 32.h,
                    baselineType: TextBaseline.alphabetic,
                    child: Text(
                      secondaryText!,
                      textAlign: TextAlign.start,
                      maxLines: 3,
                      style: sBodyText2Style.copyWith(
                        color: SColorsLight().grey1,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
