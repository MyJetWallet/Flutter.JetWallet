import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../simple_kit.dart';

class SActionSheetItem extends StatelessWidget {
  const SActionSheetItem({
    Key? key,
    required this.icon,
    required this.name,
    required this.helperText,
    required this.description,
  }) : super(key: key);

  final Widget icon;
  final String name;
  final String helperText;
  final String description;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64.h,
      child: Column(
        children: [
          const SpaceH10(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              icon,
              const SpaceW10(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      textBaseline: TextBaseline.alphabetic,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      children: [
                        SizedBox(
                          width: 190.w,
                          child: Baseline(
                            baseline: 17.8.h,
                            baselineType: TextBaseline.alphabetic,
                            child: Text(
                              name,
                              style: sSubtitle2Style,
                            ),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 90.w,
                          child: Text(
                            helperText,
                            textAlign: TextAlign.end,
                            style: sCaptionTextStyle.copyWith(
                              color: SColorsLight().grey3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 190.w,
                      child: Baseline(
                        baseline: 15.5.h,
                        baselineType: TextBaseline.alphabetic,
                        child: Text(
                          description,
                          style: sCaptionTextStyle.copyWith(
                            color: SColorsLight().grey3,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
