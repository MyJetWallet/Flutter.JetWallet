import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import '../../../../simple_kit.dart';
import 'helper/set_circle_background_image.dart';

class SRewardBanner extends StatelessWidget {
  const SRewardBanner({
    super.key,
    this.secondaryText,
    this.imageUrl,
    this.primaryTextStyle,
    this.isActive = false,
    required this.color,
    required this.primaryText,
    required this.onTap,
  });

  final String? secondaryText;
  final String? imageUrl;
  final TextStyle? primaryTextStyle;
  final bool isActive;
  final Color color;
  final String primaryText;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(
          top: 12,
          bottom: 0,
          right: 24,
          left: isActive ? 8 : 24,
        ),
        color: color,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isActive) ...[
                  Column(
                    children: [
                      const SpaceH20(),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: sKit.colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SpaceW8(),
                ],
                CircleAvatar(
                  radius: 24.0,
                  backgroundImage: setCircleBackgroundImage(imageUrl),
                ),
                const SpaceW16(),
                Column(
                  mainAxisAlignment: (secondaryText != null) ? MainAxisAlignment.start : MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 116,
                      child: Text(
                        primaryText,
                        textAlign: TextAlign.start,
                        maxLines: 3,
                        style: primaryTextStyle ?? sSubtitle3Style,
                      ),
                    ),
                    const SpaceH4(),
                    if (secondaryText != null)
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 116,
                        child: Text(
                          secondaryText!,
                          textAlign: TextAlign.start,
                          maxLines: 3,
                          style: sBodyText2Style.copyWith(
                            color: SColorsLight().grey1,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SpaceH15(),
            Row(
              children: [
                if (isActive) const SpaceW16(),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 48,
                  child: const SDivider(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
