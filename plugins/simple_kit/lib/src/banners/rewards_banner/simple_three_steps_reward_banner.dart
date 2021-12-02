import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../simple_kit.dart';

class SThreeStepsRewardBanner extends StatelessWidget {
  const SThreeStepsRewardBanner({
    Key? key,
    required this.primaryText,
    required this.timeToComplete,
    this.imageUrl,
  }) : super(key: key);

  final String primaryText;
  final String timeToComplete;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 357.h,
          margin: EdgeInsets.only(
            bottom: 20.h,
          ),
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
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                              width: 197.w,
                              child: Baseline(
                                baseline: 24.h,
                                baselineType: TextBaseline.alphabetic,
                                child: Text(
                                  primaryText,
                                  maxLines: 2,
                                  style: sTextH4Style,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 2,
                              right: 12,
                              child: SizedBox(
                                width: 24.w,
                                height: 24.w,
                                child: const SInfoPressedIcon(),
                              ),
                            ),
                          ],
                        ),
                        const SpaceW20(),
                        CircleAvatar(
                          radius: 34.r,
                          backgroundImage:
                              (imageUrl != null) ? NetworkImage(imageUrl!) : null,
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
                height: 209.h,
                child: Column(
                  children: [
                    const SpaceH32(),
                    SizedBox(
                      width: 287.w,
                      child: Row(
                        children: [
                          Expanded(
                            child: Baseline(
                              baselineType: TextBaseline.alphabetic,
                              baseline: 17.h,
                              child: const Text(
                                'Get \$5 for account verification',
                              ),
                            ),
                          ),
                          const SCompleteIcon(),
                        ],
                      ),
                    ),
                    const SpaceH16(),
                    SizedBox(
                      width: 287.w,
                      child: Row(
                        children: [
                          Expanded(
                            child: Baseline(
                              baselineType: TextBaseline.alphabetic,
                              baseline: 17.h,
                              child: const Text(
                                'Get \$10 after making first deposit',
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            height: 24.h,
                            width: 24.w,
                            child: SizedBox(
                              height: 14.h,
                              width: 8.5.w,
                              child: const SBlueRightArrowIcon(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SpaceH16(),
                    SizedBox(
                      width: 287.w,
                      child: Row(
                        children: [
                          Expanded(
                            child: Baseline(
                              baselineType: TextBaseline.alphabetic,
                              baseline: 17.h,
                              child: const Text(
                                '\$15 after trading \$100 (57/100)',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SpaceH36(),
                    SizedBox(
                      width: 287.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 240.w,
                            height: 16.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.r),
                              ),
                              color: SColorsLight().grey4,
                            ),
                          ),
                          Text(
                            '1/3',
                            style: sBodyText2Style,
                          ),
                        ],
                      ),
                    ),
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
