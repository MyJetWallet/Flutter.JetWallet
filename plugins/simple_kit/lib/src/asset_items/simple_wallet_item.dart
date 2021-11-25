import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../simple_kit.dart';

/// Requires Icon with width target (24.w)
class SWalletItem extends StatelessWidget {
  const SWalletItem({
    Key? key,
    this.amount,
    this.decline,
    this.removeDivider = false,
    required this.icon,
    required this.primaryText,
    required this.secondaryText,
    required this.onTap,
  }) : super(key: key);

  final bool? decline;
  final String? amount;
  final bool removeDivider;
  final Widget icon;
  final String primaryText;
  final String secondaryText;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    var textColor = SColorsLight().green;
    var borderColor = SColorsLight().greenLight;

    if (decline ?? false) {
      textColor = SColorsLight().red;
      borderColor = SColorsLight().redLight;
    }

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
                  const SpaceW10(),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Baseline(
                          baseline: 17.8.h,
                          baselineType: TextBaseline.alphabetic,
                          child: Text(
                            primaryText,
                            style: sSubtitle2Style,
                          ),
                        ),
                        Baseline(
                          baseline: 19.4.h,
                          baselineType: TextBaseline.alphabetic,
                          child: Text(
                            secondaryText,
                            style: sBodyText2Style.copyWith(
                              color: SColorsLight().grey3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (amount != null) ...[
                    const SpaceW10(),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: 157.w,
                      ),
                      height: 44.h,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: borderColor,
                          width: 1.w,
                        ),
                        borderRadius: BorderRadius.circular(22.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            amount!,
                            style: sSubtitle2Style.copyWith(
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    )
                  ]
                ],
              ),
              const Spacer(),
              if (!removeDivider)
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
