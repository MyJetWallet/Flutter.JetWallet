import 'package:flutter/material.dart';

import '../../../../simple_kit.dart';
import '../../colors/view/simple_colors_light.dart';
import 'helper/set_circle_background_image.dart';

class SRewardBanner extends StatelessWidget {
  const SRewardBanner({
    Key? key,
    this.secondaryText,
    this.imageUrl,
    this.primaryTextStyle,
    required this.color,
    required this.primaryText,
  }) : super(key: key);

  final String? secondaryText;
  final String? imageUrl;
  final TextStyle? primaryTextStyle;
  final Color color;
  final String primaryText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 20.0,
        top: 20.0,
        bottom: 20.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: color,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 40.0,
            backgroundImage: setCircleBackgroundImage(imageUrl),
          ),
          const SpaceW16(),
          Column(
            mainAxisAlignment: (secondaryText != null)
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 177.0,
                child: Baseline(
                  baseline: 27.0,
                  baselineType: TextBaseline.alphabetic,
                  child: Text(
                    primaryText,
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    style: primaryTextStyle ?? sTextH4Style,
                  ),
                ),
              ),
              if (secondaryText != null)
                SizedBox(
                  width: 177.0,
                  child: Baseline(
                    baseline: 30.0,
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
