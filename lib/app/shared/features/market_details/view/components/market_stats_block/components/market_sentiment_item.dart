import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:simple_kit/simple_kit.dart';

class MarketSentimentItem extends HookWidget {
  const MarketSentimentItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 44.h,
          child: Baseline(
            baseline: 41.h,
            baselineType: TextBaseline.alphabetic,
            child: Text(
              'Santimentos (Buy/Sell)',
              style: sBodyText2Style.copyWith(color: colors.grey1),
            ),
          ),
        ),
        Row(
          children: [
            Text(
              '50%',
              style: sBodyText1Style,
            ),
            const Spacer(),
            Text(
              '50%',
              style: sBodyText1Style,
            ),
          ],
        ),
        LinearPercentIndicator(
          width: 164.w,
          lineHeight: 3.h,
          percent: 0.5,
          padding: EdgeInsets.zero,
          backgroundColor: colors.red,
          progressColor: colors.green,
        ),
        const SpaceH10(),
        const SDivider(),
      ],
    );
  }
}
