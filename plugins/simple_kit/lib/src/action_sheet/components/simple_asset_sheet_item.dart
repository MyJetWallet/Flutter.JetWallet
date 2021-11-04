import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../simple_kit.dart';

/// Requires Icon with width target
class SAssetSheetItem extends StatelessWidget {
  const SAssetSheetItem({
    Key? key,
    this.helperText = '',
    this.isCreditCard = false,
    required this.icon,
    required this.name,
    required this.amount,
    required this.description,
    required this.onTap,
  }) : super(key: key);

  final String helperText;
  final bool isCreditCard;
  final Widget icon;
  final String name;
  final String amount;
  final String description;
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
              const SpaceH22(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  icon,
                  const SpaceW20(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          textBaseline: TextBaseline.alphabetic,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          children: [
                            SizedBox(
                              width: isCreditCard ? 180.w : 150.w,
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
                              width: isCreditCard ? 90.w : 120.w,
                              child: Text(
                                amount,
                                textAlign: TextAlign.end,
                                style: sSubtitle2Style,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          textBaseline: TextBaseline.alphabetic,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          children: [
                            SizedBox(
                              width: isCreditCard ? 180.w : 150.w,
                              child: Baseline(
                                baseline: 15.4.h,
                                baselineType: TextBaseline.alphabetic,
                                child: Text(
                                  description,
                                  style: sCaptionTextStyle.copyWith(
                                    color: SColorsLight().grey3,
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            if (isCreditCard)
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
