import 'package:flutter/material.dart';

import '../../../simple_kit.dart';
import '../../colors/view/simple_colors_light.dart';

void sShowAlertPopup(
  BuildContext context, {
  Function()? onWillPop,
  Function()? onSecondaryButtonTap,
  String? secondaryText,
  String? secondaryButtonName,
  Widget? image,
  Widget? topSpacer,
  Widget? child,
  bool willPopScope = true,
  bool barrierDismissible = true,
  bool activePrimaryButton = true,
  bool isNeedPrimaryButton = true,
  SButtonType primaryButtonType = SButtonType.primary1,
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
          onWillPop?.call();
          return Future.value(willPopScope);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Dialog(
              insetPadding: const EdgeInsets.all(24.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: Column(
                  children: [
                    topSpacer ?? const SpaceH40(),
                    if (image != null)
                      image
                    else
                      Image.asset(
                        ellipsisAsset,
                        height: 80,
                        width: 80,
                        package: 'simple_kit',
                      ),
                    Baseline(
                      baseline: 40.0,
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
                    const SpaceH7(),
                    if (secondaryText != null)
                      Text(
                        secondaryText,
                        maxLines: 6,
                        textAlign: TextAlign.center,
                        style: sBodyText1Style.copyWith(
                          color: SColorsLight().grey1,
                        ),
                      ),
                    const SpaceH36(),
                    if (child != null) child,
                    if (isNeedPrimaryButton) ...[
                      if (primaryButtonType == SButtonType.primary1)
                        SPrimaryButton1(
                          name: primaryButtonName,
                          active: activePrimaryButton,
                          onTap: () => onPrimaryButtonTap(),
                        )
                      else if (primaryButtonType == SButtonType.primary2)
                        SPrimaryButton2(
                          name: primaryButtonName,
                          active: activePrimaryButton,
                          onTap: () => onPrimaryButtonTap(),
                        )
                      else
                        SPrimaryButton3(
                          name: primaryButtonName,
                          active: activePrimaryButton,
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
                      const SpaceH20(),
                    ],
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
