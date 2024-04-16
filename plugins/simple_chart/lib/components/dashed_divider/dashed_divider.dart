import 'package:flutter/material.dart';

import '../../chart_style.dart';

class DashedDivider extends StatelessWidget {
  const DashedDivider({
    super.key,
    required this.topPadding,
    this.addLeftPadding = true,
  });

  final double topPadding;
  final bool addLeftPadding;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth,
      padding: EdgeInsets.only(left: addLeftPadding ? 24 : 0),
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
