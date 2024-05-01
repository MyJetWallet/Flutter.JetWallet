import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/modules/news/components/simple_smile_icon.dart';

import '../../simple_kit.dart';

class SNewsCategory extends StatelessWidget {
  const SNewsCategory({
    super.key,
    this.height,
    required this.text1,
    required this.text2,
    required this.sentiment,
    required this.newsLabel,
    required this.newsText,
    required this.timestamp,
    required this.onTap,
  });

  final String text1;
  final String text2;
  final String newsLabel;
  final String newsText;
  final Color sentiment;
  final String timestamp;
  final Function() onTap;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SPaddingH24(
      child: Container(
        padding: const EdgeInsets.only(
          bottom: 15,
          top: 20,
        ),
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SSmileIcon(
                  sentiment: sentiment,
                ),
                const SpaceW10(),
                Expanded(
                  child: RichText(
                    overflow: TextOverflow.visible,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '$newsLabel - $timestamp',
                          style: sCaptionTextStyle.copyWith(
                            color: SColorsLight().grey1,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = onTap,
                        ),
                        TextSpan(
                          text: ' / $text1 ',
                          style: sCaptionTextStyle.copyWith(
                            color: SColorsLight().grey1,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = onTap,
                        ),
                        TextSpan(
                          text: text2,
                          style: sCaptionTextStyle.copyWith(
                            color: SColorsLight().grey1,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = onTap,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: onTap,
              highlightColor: SColorsLight().grey5,
              child: Baseline(
                baseline: 28,
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  newsText,
                  maxLines: 2,
                  style: sBodyText1Style,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
