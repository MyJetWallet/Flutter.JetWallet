import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../simple_kit.dart';

void simpleShowWarningPopup(
  BuildContext context, {
  Function(BuildContext builderContext)? onSecondaryButtonTap,
  String? secondaryText,
  String? secondaryButtonName,
  required String asset,
  required String primaryText,
  required String primaryButtonName,
  required Function(BuildContext builderContext) onPrimaryButtonTap,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(24.r),
              ),
            ),
            buttonPadding: EdgeInsets.symmetric(horizontal: 20.w),
            insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
            contentPadding: EdgeInsets.zero,
            titlePadding: EdgeInsets.zero,
            title: Column(
              children: [
                Container(
                  width: 327.w,
                  margin: EdgeInsets.only(
                    top: 40.h,
                  ),
                  height: 80.h,
                  child: Image.asset(asset),
                ),
              ],
            ),
            content: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  SizedBox(
                    height: 40.h,
                    child: Baseline(
                      baseline: 40.h,
                      baselineType: TextBaseline.alphabetic,
                      child: Text(
                        primaryText,
                        maxLines: (secondaryText != null) ? 5 : 12,
                        textAlign: TextAlign.center,
                        style:
                        sTextH5Style.copyWith(overflow: TextOverflow.visible),
                      ),
                    ),
                  ),
                  if (secondaryText != null)
                    Baseline(
                      baseline: 32.h,
                      baselineType: TextBaseline.alphabetic,
                      child: Text(
                        secondaryText,
                        maxLines: 6,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: SColorsLight().grey1,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            actions: <Widget>[
              Column(
                children: [
                  const SpaceH34(),
                  SPrimaryButton1(
                    name: primaryButtonName,
                    active: true,
                    onTap: () => onPrimaryButtonTap(context),
                  ),
                  const SpaceH10(),
                  if (onSecondaryButtonTap != null &&
                      secondaryButtonName != null)
                    STextButton1(
                      name: secondaryButtonName,
                      active: true,
                      onTap: () => onSecondaryButtonTap(context),
                    ),
                  const SpaceH20(),
                ],
              ),
            ],
          ),
        ],
      );
    },
  );
}
