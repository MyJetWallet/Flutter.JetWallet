import 'package:flutter/material.dart';

import '../../../simple_kit.dart';
import 'helper/set_circle_background_image.dart';

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

  final String? imageUrl;
  final Color? circleAvatarColor;
  final Widget? rewardIndicatorComplete;
  final String primaryText;
  final String timeToComplete;
  final List<Widget> rewardDetail;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              width: 3.0,
              color: SColorsLight().grey4,
            ),
          ),
          child: Column(
            children: [
              Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.only(
                  top: 17.0,
                  left: 17.0,
                  bottom: 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 197.0,
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: primaryText,
                                  style: sTextH4Style.copyWith(
                                    color: SColorsLight().black,
                                  ),
                                ),
                                WidgetSpan(
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                      left: 8,
                                    ),
                                    child: const SInfoPressedIcon(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SpaceW20(),
                        Container(
                          padding: const EdgeInsets.only(
                            right: 17,
                          ),
                          child: CircleAvatar(
                            radius: 32.0,
                            backgroundColor: circleAvatarColor,
                            backgroundImage: setCircleBackgroundImage(imageUrl),
                          ),
                        ),
                      ],
                    ),
                    const SpaceH10(),
                    Container(
                      alignment: Alignment.center,
                      width: 131.0,
                      height: 26.0,
                      decoration: BoxDecoration(
                        color: SColorsLight().grey5,
                        borderRadius: BorderRadius.circular(16.0),
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
