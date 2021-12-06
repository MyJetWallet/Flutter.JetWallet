import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashedDivider extends StatelessWidget {
  const DashedDivider({
    Key? key,
    required this.topPadding,
  }) : super(key: key);

  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      padding: EdgeInsets.only(left: 24.w),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final boxWidth = constraints.constrainWidth();
          final dashWidth = 5.w;
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
      ),
    );
  }
}
