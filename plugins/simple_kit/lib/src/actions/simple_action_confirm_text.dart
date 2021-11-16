import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../simple_kit.dart';

class SActionConfirmText extends StatelessWidget {
  const SActionConfirmText({
    Key? key,
    this.valueColor,
    this.animation,
    this.loading = false,
    required this.name,
    required this.value,
  }) : super(key: key);

  final Color? valueColor;
  final AnimationController? animation;
  final bool loading;
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
              maxWidth: animation != null ? 200.w : 180.w,
              minWidth: 100.w,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    value,
                    style: sSubtitle3Style.copyWith(
                      color: valueColor ?? SColorsLight().black,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
                if (animation != null) ...[
                  const SpaceW10(),
                  Baseline(
                    baseline: 17.h,
                    baselineType: TextBaseline.alphabetic,
                    child: SConfirmActionTimer(
                      animation: animation!,
                      loading: loading,
                    ),
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}
