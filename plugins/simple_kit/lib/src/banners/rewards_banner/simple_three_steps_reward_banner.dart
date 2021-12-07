import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../simple_kit.dart';

class SThreeStepsRewardBanner extends StatelessWidget {
  const SThreeStepsRewardBanner({
    Key? key,
    this.imageUrl,
    this.circleAvatarColor,
    this.rewardIndicatorComplete,
    required this.rewardDetail,
    required this.primaryText,
    required this.timeToComplete,
  }) : super(key: key);

  final String primaryText;
  final String timeToComplete;
  final String? imageUrl;
  final Color? circleAvatarColor;
  final List<Widget> rewardDetail;
  final Widget? rewardIndicatorComplete;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              width: 3.w,
              color: SColorsLight().grey4,
            ),
          ),
          child: Column(
            children: [
              Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.only(
                  top: 17.w,
                  left: 17.w,
                  bottom: 17.w,
                ),
                height: 141.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 197.w,
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: primaryText,
                                  style: sTextH4Style.copyWith(
                                    color: SColorsLight().black,
                                  ),
                                ),
                                const WidgetSpan(
                                  child: SInfoPressedIcon(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SpaceW20(),
                        CircleAvatar(
                          radius: 34.r,
                          backgroundColor: circleAvatarColor,
                          backgroundImage: (imageUrl != null)
                              ? NetworkImage(imageUrl!)
                              : null,
                        ),
                      ],
                    ),
                    const SpaceH10(),
                    Container(
                      alignment: Alignment.center,
                      width: 131.w,
                      height: 26.h,
                      decoration: BoxDecoration(
                        color: SColorsLight().grey5,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Text(
                        timeToComplete,
                        style: sCaptionTextStyle.copyWith(
                          color: SColorsLight().grey1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SDivider(),
              SizedBox(
                child: Column(
                  children: [
                    const SpaceH32(),
                    ...rewardDetail,
                    if (rewardIndicatorComplete != null) ...[
                      const SpaceH24(),
                      rewardIndicatorComplete!,
                      const SpaceH30(),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        const SpaceH20(),
      ],
    );
  }
}
