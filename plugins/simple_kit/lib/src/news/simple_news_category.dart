import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  }): super(key: key);

  final String newsLabel;
  final String newsText;
  final Color sentiment;
  final String timestamp;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SPaddingH24(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          height: 110.h,
          child: Column(
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
                  style: sBodyText1Style,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
