import 'package:flutter/material.dart';

import '../../../../simple_kit.dart';
import '../../colors/view/simple_colors_light.dart';
import 'helper/set_circle_background_image.dart';

class SRewardBanner extends StatelessWidget {
  const SRewardBanner({
    Key? key,
    this.secondaryText,
    this.imageUrl,
    this.onClose,
    this.primaryTextStyle,
    this.indentRight = false,
    required this.color,
    required this.primaryText,
  }) : super(key: key);

  final Function()? onClose;
  final String? secondaryText;
  final String? imageUrl;
  final TextStyle? primaryTextStyle;
  final Color color;
  final String primaryText;
  final bool indentRight;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const SpaceW24(),
        Container(
          margin: indentRight
              ? EdgeInsets.zero
              : const EdgeInsets.only(
                  right: 10,
                ),
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
        ),
        if (onClose != null)
          Positioned(
            top: 12.0,
            right: 22.0,
            child: GestureDetector(
              onTap: onClose,
              child: const SEraseMarketIcon(),
            ),
          ),
      ],
    );
  }
}
