import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../simple_kit.dart';

/// Requires Icon with width target
class SActionItem extends StatelessWidget {
  const SActionItem({
    Key? key,
    this.helperText = '',
    required this.icon,
    required this.name,
    required this.onTap,
    required this.description,
  }) : super(key: key);

  final String helperText;
  final Widget icon;
  final String name;
  final Function() onTap;
  final String description;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: SColorsLight().grey5,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: SPaddingH24(
        child: SizedBox(
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
                        Baseline(
                          baseline: 15.5.h,
                          baselineType: TextBaseline.alphabetic,
                          child: Text(
                            description,
                            style: sCaptionTextStyle.copyWith(
                              color: SColorsLight().grey3,
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
        ),
      ),
    );
  }
}
