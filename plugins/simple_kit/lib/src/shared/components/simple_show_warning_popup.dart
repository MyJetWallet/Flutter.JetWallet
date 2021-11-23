import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../simple_kit.dart';

void simpleShowWarningPopup(
    BuildContext context, {
      String? onTapCancelTitle,
      Function(BuildContext builderContext)? onTapCancel,
      String? subTitle,
      required String asset,
      required String title,
      required String onTapTitle,
      required Function(BuildContext builderContext) onTap,
    }) {
  showDialog(
    context: context,
    builder: (builderContext) {
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
                const SpaceH20(),
              ],
            ),
            content: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: sTextH5Style.copyWith(overflow: TextOverflow.visible),
                  ),
                  if (subTitle != null)
                    Baseline(
                      baseline: 32.h,
                      baselineType: TextBaseline.alphabetic,
                      child: Text(
                        subTitle,
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
                    name: onTapTitle,
                    active: true,
                    onTap: () => onTap(builderContext),
                  ),
                  const SpaceH10(),
                  if (onTapCancel != null && onTapCancelTitle != null)
                    STextButton1(
                      name: onTapCancelTitle,
                      active: true,
                      onTap: () => onTapCancel(builderContext),
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
