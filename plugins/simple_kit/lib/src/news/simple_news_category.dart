import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../simple_kit.dart';
import '../colors/view/simple_colors_light.dart';
import 'components/simple_smile_icon.dart';

class SNewsCategory extends StatelessWidget {
  const SNewsCategory({
    Key? key,
    this.height,
    required this.sentiment,
    required this.newsLabel,
    required this.newsText,
    required this.timestamp,
    required this.onTap,
    required this.padding,
  }) : super(key: key);

  final String newsLabel;
  final String newsText;
  final Color sentiment;
  final String timestamp;
  final Function() onTap;
  final double? height;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return SPaddingH24(
      child: Container(
        padding: padding,
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
                          text: ' / Discuss on ',
                          style: sCaptionTextStyle.copyWith(
                            color: SColorsLight().grey1,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = onTap,
                        ),
                        TextSpan(
                          text: 'CryptoPanic',
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
                baseline: 30,
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
