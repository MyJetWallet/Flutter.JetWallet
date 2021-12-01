import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../simple_kit.dart';

/// Requires Icon with width target
class SPaymentSelectFiat extends StatelessWidget {
  const SPaymentSelectFiat({
    Key? key,
    required this.icon,
    required this.name,
    required this.amount,
    required this.onTap,
  }) : super(key: key);

  final Widget icon;
  final String name;
  final String amount;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return SPaddingH24(
      child: InkWell(
        highlightColor: SColorsLight().grey4,
        splashColor: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        onTap: onTap,
        child: Ink(
          height: 88.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              width: 1.r,
              color: SColorsLight().grey4,
            ),
          ),
          child: Column(
            children: [
              const SpaceH30(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SpaceW20(),
                  icon,
                  const SpaceW10(),
                  Expanded(
                    child: Row(
                      textBaseline: TextBaseline.alphabetic,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      children: [
                        SizedBox(
                          width: 130.w,
                          child: Baseline(
                            baseline: 17.h,
                            baselineType: TextBaseline.alphabetic,
                            child: Text(
                              name,
                              style: sSubtitle2Style,
                            ),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 110.w,
                          child: Text(
                            amount,
                            textAlign: TextAlign.end,
                            style: sSubtitle2Style,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SpaceW20(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
