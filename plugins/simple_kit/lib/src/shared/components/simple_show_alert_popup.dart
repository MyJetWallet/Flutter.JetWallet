import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../simple_kit.dart';
import '../constants.dart';

void sShowAlertPopup(
  BuildContext context, {
  Function()? onSecondaryButtonTap,
  String? secondaryText,
  String? secondaryButtonName,
  Widget? image,
  bool willPopScope = true,
  bool barrierDismissible = true,
  required String primaryText,
  required String primaryButtonName,
  required Function() onPrimaryButtonTap,
}) {
  showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) {
      return WillPopScope(
        onWillPop: () {
          return Future.value(willPopScope);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Dialog(
              insetPadding: EdgeInsets.all(24.r),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                ),
                child: Column(
                  children: [
                    const SpaceH40(),
                    if (image != null)
                      image
                    else
                      Image.asset(
                        ellipsisAsset,
                      ),
                    Baseline(
                      baseline: 40.h,
                      baselineType: TextBaseline.alphabetic,
                      child: Text(
                        primaryText,
                        maxLines: (secondaryText != null) ? 5 : 12,
                        textAlign: TextAlign.center,
                        style: sTextH5Style.copyWith(
                          overflow: TextOverflow.visible,
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
                    const SpaceH40(),
                    SPrimaryButton1(
                      name: primaryButtonName,
                      active: true,
                      onTap: () => onPrimaryButtonTap(),
                    ),
                    if (onSecondaryButtonTap != null &&
                        secondaryButtonName != null) ...[
                      const SpaceH10(),
                      STextButton1(
                        name: secondaryButtonName,
                        active: true,
                        onTap: () => onSecondaryButtonTap(),
                      ),
                    ],
                    const SpaceH24(),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
