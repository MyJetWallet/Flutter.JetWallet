import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashedDivider extends StatelessWidget {
  const DashedDivider({
    this.topPadding = 1,
  });

  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
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
                padding: EdgeInsets.only(top: topPadding),
                child: SizedBox(
                  width: dashWidth,
                  height: 1.h,
                  child: const DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color(0xFFE0E5EB),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
