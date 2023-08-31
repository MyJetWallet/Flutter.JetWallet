import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

// TODO: Add santiment when backend will be ready
class MarketSentimentItem extends StatelessWidget {
  const MarketSentimentItem({super.key});

  @override
  Widget build(BuildContext context) {
    // final colors = useProvider(sColorPod);

    return Column(
      children: const [
        SizedBox(
          height: 60,
        ),
        SDivider(),
      ],
    );

    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     SizedBox(
    //       height: 44,
    //       child: Baseline(
    //         baseline: 41,
    //         baselineType: TextBaseline.alphabetic,
    //         child: Text(
    //           'Santimentos (Buy/Sell)',
    //           style: sBodyText2Style.copyWith(color: colors.grey1),
    //         ),
    //       ),
    //     ),
    //     SizedBox(
    //       height: 24,
    //       child: Row(
    //         children: [
    //           Baseline(
    //             baseline: 19,
    //             baselineType: TextBaseline.alphabetic,
    //             child: Text(
    //               '50%',
    //               style: sBodyText1Style,
    //             ),
    //           ),
    //           const Spacer(),
    //           Baseline(
    //             baseline: 19,
    //             baselineType: TextBaseline.alphabetic,
    //             child: Text(
    //               '50%',
    //               style: sBodyText1Style,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //     LinearPercentIndicator(
    //       width: 164,
    //       lineHeight: 3,
    //       percent: 0.5,
    //       padding: EdgeInsets.zero,
    //       backgroundColor: colors.red,
    //       progressColor: colors.green,
    //     ),
    //     const SpaceH9(),
    //     const SDivider(),
    //   ],
    // );
  }
}
