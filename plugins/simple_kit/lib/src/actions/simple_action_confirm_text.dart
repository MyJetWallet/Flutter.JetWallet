import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../simple_kit.dart';

class SActionConfirmText extends StatelessWidget {
  const SActionConfirmText({
    Key? key,
    this.valueColor,
    required this.name,
    required this.value,
  }) : super(key: key);

  final Color? valueColor;
  final String name;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Baseline(
              baseline: 40.h,
              baselineType: TextBaseline.alphabetic,
              child: Text(
                name,
                maxLines: 10,
                style: sBodyText2Style.copyWith(
                  color: SColorsLight().grey1,
                ),
              ),
            ),
          ),
          const SpaceW10(),
          Container(
            constraints: BoxConstraints(
              maxWidth: 180.w,
              minWidth: 100.w,
            ),
            child: Text(
              value,
              style: sSubtitle3Style.copyWith(
                color: valueColor ?? SColorsLight().black,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
