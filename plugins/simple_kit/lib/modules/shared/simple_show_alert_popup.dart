import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import '../../../simple_kit.dart';

// ignore: long-method
Future<void> sShowAlertPopup(
  BuildContext context, {
  Function()? onWillPop,
  Function()? onSecondaryButtonTap,
  Function()? onCancelButtonTap,
  String? secondaryText,
  String? secondaryButtonName,
  String? cancelText,
  Widget? image,
  Widget? topSpacer,
  Widget? child,
  bool willPopScope = true,
  bool barrierDismissible = true,
  bool activePrimaryButton = true,
  bool isNeedPrimaryButton = true,
  bool isNeedCancelButton = false,
  SButtonType primaryButtonType = SButtonType.primary1,
  SWidgetSize size = SWidgetSize.medium,
  TextAlign? textAlign = TextAlign.center,
  required String primaryText,
  required String primaryButtonName,
  required Function() onPrimaryButtonTap,
}) async {
  await showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    useSafeArea: false,
    builder: (context) {
      return PopScope(
        canPop: willPopScope,
        onPopInvokedWithResult: (_, __) {
          onWillPop?.call();
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
                    if (primaryText.isNotEmpty) ...[
                      Baseline(
                        baseline: 40.0,
                        baselineType: TextBaseline.alphabetic,
                        child: Text(
                          primaryText,
                          maxLines: (secondaryText != null) ? 5 : 12,
                          textAlign: textAlign,
                          style: sTextH5Style.copyWith(
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ),
                      const SpaceH7(),
                    ] else ...[
                      const SpaceH20(),
                    ],
                    if (secondaryText != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                        ),
                        child: Text(
                          secondaryText,
                          maxLines: 12,
                          textAlign: textAlign,
                          style: sBodyText1Style.copyWith(
                            color: SColorsLight().grey1,
                          ),
                        ),
                      ),
                    if (isNeedPrimaryButton) ...[
                      const SpaceH36(),
                    ] else ...[
                      const SpaceH20(),
                    ],
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
                      if (onSecondaryButtonTap != null && secondaryButtonName != null) ...[
                        const SpaceH10(),
                        STextButton1(
                          name: secondaryButtonName,
                          active: true,
                          onTap: () => onSecondaryButtonTap(),
                        ),
                      ],
                    ],
                    if (isNeedCancelButton) ...[
                      const SpaceH10(),
                      STextButton1(
                        active: true,
                        name: cancelText ?? '',
                        onTap: () => onCancelButtonTap!(),
                      ),
                    ],
                    const SpaceH20(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}
