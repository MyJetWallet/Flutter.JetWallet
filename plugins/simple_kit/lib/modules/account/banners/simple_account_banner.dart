import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:simple_kit/modules/buttons/simple_icon_button.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/modules/icons/24x24/public/erase/simple_erase_pressed_icon.dart';
import 'package:simple_kit/modules/shared/simple_spacers.dart';
import 'package:simple_kit/modules/texts/simple_text_styles.dart';

import '../../icons/24x24/public/erase/simple_erase_market_icon.dart';

class SimpleAccountBanner extends StatelessWidget {
  const SimpleAccountBanner({
    super.key,
    this.canClose = false,
    this.onClose,
    required this.imageUrl,
    required this.header,
    required this.description,
    required this.color,
    required this.onTap,
  });

  final bool canClose;
  final Function()? onClose;
  final String imageUrl;
  final String header;
  final String description;
  final Color color;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 20, left: 20, bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: color,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        imageUrl,
                        package: 'simple_kit',
                      ),
                    ),
                  ),
                ),
                const SpaceW16(),
                SizedBox(
                  width: 177,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 14,
                        ),
                        child: SizedBox(
                          width: 207,
                          child: Baseline(
                            baseline: 20,
                            baselineType: TextBaseline.alphabetic,
                            child: Text(
                              header,
                              maxLines: 2,
                              style: sTextH5Style,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Flexible(
                        child: AutoSizeText(
                          description,
                          textAlign: TextAlign.start,
                          minFontSize: 4.0,
                          maxLines: 4,
                          strutStyle: StrutStyle(
                            fontSize: sBodyText2Style.fontSize,
                            height: 0.9,
                            fontFamily: sBodyText2Style.fontFamily,
                          ),
                          style: sBodyText1Style.copyWith(
                            color: SColorsLight().grey1,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (canClose)
            Positioned(
              top: 10.0,
              right: 10.0,
              child: SIconButton(
                onTap: () {
                  onClose?.call();
                },
                defaultIcon: const SEraseMarketIcon(),
                pressedIcon: const SErasePressedIcon(),
              ),
            ),
        ],
      ),
    );
  }
}
