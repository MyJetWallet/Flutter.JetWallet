import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../simple_kit.dart';

class SRewardBannerExample extends StatelessWidget {
  const SRewardBannerExample({
    Key? key,
    required this.bannerColor,
    required this.primaryText,
  }) : super(key: key);

  static const routeName = '/simple_rewards_banner_example';

  final Color bannerColor;
  final String primaryText;

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
            backgroundColor: Colors.green,
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
              SizedBox(
                width: 203.w,
                child: Baseline(
                  baseline: 32.h,
                  baselineType: TextBaseline.alphabetic,
                  child: Text(
                    'Get a random coin with every trade over \$50',
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
