import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../simple_kit.dart';

/// Requires Icon with width target
class SPaymentSelectAsset extends StatelessWidget {
  const SPaymentSelectAsset({
    Key? key,
    this.onTap,
    this.helper = '',
    this.amount = '',
    this.isCreditCard = false,
    required this.icon,
    required this.name,
    required this.description,
  }) : super(key: key);

  final Function()? onTap;
  final String helper;
  final String amount;
  final bool isCreditCard;
  final Widget icon;
  final String name;
  final String description;

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
              const SpaceH26(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SpaceW20(),
                  icon,
                  const SpaceW10(),
                  Expanded(
                    child: Column(
                      children: [
                        Baseline(
                          baseline: 15.h,
                          baselineType: TextBaseline.alphabetic,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: isCreditCard ? 150.w : 130.w,
                                child: Text(
                                  name,
                                  style: sSubtitle2Style,
                                ),
                              ),
                              const Spacer(),
                              SizedBox(
                                width: isCreditCard ? 90.w : 110.w,
                                child: Text(
                                  amount,
                                  textAlign: TextAlign.end,
                                  style: sSubtitle2Style,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Baseline(
                          baseline: 15.4.h,
                          baselineType: TextBaseline.alphabetic,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: isCreditCard ? 150.w : 130.w,
                                child: Text(
                                  description,
                                  style: sCaptionTextStyle.copyWith(
                                    color: SColorsLight().grey3,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              SizedBox(
                                width: isCreditCard ? 90.w : 110.w,
                                child: Text(
                                  helper,
                                  textAlign: TextAlign.end,
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
