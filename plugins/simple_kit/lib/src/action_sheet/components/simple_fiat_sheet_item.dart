import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../simple_kit.dart';

/// Requires Icon with width target
class SFiatSheetItem extends StatelessWidget {
  const SFiatSheetItem({
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
    return InkWell(
      highlightColor: SColorsLight().grey5,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: SPaddingH24(
        child: SizedBox(
          height: 88.h,
          child: Column(
            children: [
              const SpaceH34(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  icon,
                  const SpaceW20(),
                  Expanded(
                    child: Row(
                      textBaseline: TextBaseline.alphabetic,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      children: [
                        SizedBox(
                          width: 150.w,
                          child: Baseline(
                            baseline: 15.8.h,
                            baselineType: TextBaseline.alphabetic,
                            child: Text(
                              name,
                              style: sSubtitle2Style,
                            ),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 120.w,
                          child: Text(
                            amount,
                            textAlign: TextAlign.end,
                            style: sSubtitle2Style,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              SDivider(
                width: 327.w,
              )
            ],
          ),
        ),
      ),
    );
  }
}
