import 'package:flutter/material.dart';

import '../../simple_kit.dart';
import 'components/simple_smile_icon.dart';

class SNewsCategory extends StatelessWidget {
  const SNewsCategory({
    Key? key,
    required this.sentiment,
    required this.newsLabel,
    required this.newsText,
    required this.timestamp,
    required this.onTap,
  }) : super(key: key);

  final String newsLabel;
  final String newsText;
  final Color sentiment;
  final String timestamp;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: SColorsLight().grey5,
      onTap: onTap,
      child: SPaddingH24(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SSmileIcon(
                    sentiment: sentiment,
                  ),
                  const SpaceW10(),
                  Baseline(
                    baseline: 13,
                    baselineType: TextBaseline.alphabetic,
                    child: Text(
                      '$newsLabel - $timestamp',
                      style: sCaptionTextStyle.copyWith(
                        color: SColorsLight().grey1,
                      ),
                    ),
                  ),
                ],
              ),
              Baseline(
                baseline: 30,
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  newsText,
                  maxLines: 2,
                  style: sBodyText1Style.copyWith(
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
