import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import '../../../../simple_kit.dart';
import '../rewards_banner/helper/set_circle_background_image.dart';

class SMarketBanner extends StatelessWidget {
  const SMarketBanner({
    super.key,
    this.secondaryText,
    this.imageUrl,
    this.onClose,
    this.primaryTextStyle,
    required this.color,
    required this.primaryText,
  });

  final Function()? onClose;
  final String? secondaryText;
  final String? imageUrl;
  final TextStyle? primaryTextStyle;
  final Color color;
  final String primaryText;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(
            left: 20.0,
            bottom: 20.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: color,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: CircleAvatar(
                  radius: 40.0,
                  backgroundImage: setCircleBackgroundImage(imageUrl),
                ),
              ),
              const SpaceW16(),
              Padding(
                padding: const EdgeInsets.only(top: 14),
                child: Column(
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
              ),
            ],
          ),
        ),
        if (onClose != null)
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: onClose,
              child: const SEraseMarketIcon(),
            ),
          ),
      ],
    );
  }
}
