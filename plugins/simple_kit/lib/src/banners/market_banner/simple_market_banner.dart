import 'package:flutter/material.dart';

import '../../../../simple_kit.dart';
import '../../colors/view/simple_colors_light.dart';
import '../rewards_banner/helper/set_circle_background_image.dart';

class SMarketBanner extends StatelessWidget {
  const SMarketBanner({
    Key? key,
    this.secondaryText,
    this.imageUrl,
    this.onClose,
    this.primaryTextStyle,
    required this.color,
    required this.primaryText,
    required this.index,
    required this.bannersLength,
  }) : super(key: key);

  final Function()? onClose;
  final String? secondaryText;
  final String? imageUrl;
  final TextStyle? primaryTextStyle;
  final Color color;
  final String primaryText;
  final int index;
  final int bannersLength;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        /// It is necessary to align the banner in the center if it is 1, if the
        /// banner is the last then the indent is 24 otherwise the gap is 8
        /// between the banners
        right: (bannersLength != 1 && bannersLength == index + 1)
            ? 24
            : 8,
        left: (index == 0) ? 24 : 0,
      ),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            padding: const EdgeInsets.only(top: 20),
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
          if (onClose != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    right: 12,
                    top: 12,
                  ),
                  child: GestureDetector(
                    onTap: onClose,
                    child: const SEraseMarketIcon(),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
