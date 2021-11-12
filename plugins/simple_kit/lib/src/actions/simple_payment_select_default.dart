import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../simple_kit.dart';

/// Requires Icon with width target
class SPaymentSelectDefault extends StatelessWidget {
  const SPaymentSelectDefault({
    Key? key,
    required this.icon,
    required this.name,
    required this.onTap,
  }) : super(key: key);

  final Widget icon;
  final String name;
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
              const SpaceH32(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  icon,
                  const SpaceW10(),
                  Baseline(
                    baseline: 17.h,
                    baselineType: TextBaseline.alphabetic,
                    child: Text(
                      name,
                      style: sSubtitle2Style,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
