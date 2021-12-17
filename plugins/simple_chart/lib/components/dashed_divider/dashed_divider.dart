import 'package:flutter/material.dart';

import '../../chart_style.dart';

class DashedDivider extends StatelessWidget {
  const DashedDivider({
    Key? key,
    required this.topPadding,
  }) : super(key: key);

  final double topPadding;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth,
      padding: const EdgeInsets.only(left: 24),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final boxWidth = constraints.constrainWidth();
          const dashWidth = 5.0;
          final dashCount = (boxWidth / (2 * dashWidth)).floor();

          return Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.horizontal,
            children: List.generate(
              dashCount,
              (_) {
                return Padding(
                  padding: EdgeInsets.only(
                    top: topPadding,
                  ),
                  child: const SizedBox(
                    width: dashWidth,
                    height: 1,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: ChartColors.dashedLineColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
