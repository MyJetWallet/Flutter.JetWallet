import 'dart:io';

import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

void sShowSlideAlertPopup(
  BuildContext context, {
  Function()? onWillPop,
  Function()? onSecondaryButtonTap,
  Function()? onSecondaryButtonTap1,
  Function()? onCancelButtonTap,
  Function()? onCancelButtonTap1,
  String? secondaryText,
  String? secondaryText1,
  String? secondaryButtonName,
  String? secondaryButtonName1,
  String? cancelText,
  String? cancelText1,
  Widget? image,
  Widget? image1,
  Widget? child,
  Widget? child1,
  bool willPopScope = true,
  bool barrierDismissible = true,
  bool activePrimaryButton = true,
  bool activePrimaryButton1 = true,
  bool isNeedPrimaryButton = true,
  bool isNeedPrimaryButton1 = true,
  bool isNeedCancelButton = false,
  bool isNeedCancelButton1 = false,
  required String primaryText,
  required String primaryText1,
  required String primaryButtonName,
  required String primaryButtonName1,
  required Function() onPrimaryButtonTap,
  required Function() onPrimaryButtonTap1,
  required PageController controller,
  required Widget slidesControllers,
}) {
  final alerts = [
    Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: SizedBox(
        height: 530,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Column(
            children: [
              if (Platform.isAndroid) const SpaceH32() else const SpaceH62(),
              if (image != null)
                image
              else
                Image.asset(
                  phoneChangeAsset,
                  height: 80,
                  width: 80,
                  package: 'simple_kit',
                ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                ),
                child: Baseline(
                  baseline: 40.0,
                  baselineType: TextBaseline.alphabetic,
                  child: Text(
                    primaryText,
                    maxLines: (secondaryText != null) ? 5 : 12,
                    textAlign: TextAlign.center,
                    style: STStyles.header6.copyWith(
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ),
              ),
              const SpaceH7(),
              if (secondaryText != null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                  ),
                  child: Text(
                    secondaryText,
                    maxLines: 6,
                    textAlign: TextAlign.center,
                    style: STStyles.body1Medium.copyWith(
                      color: SColorsLight().gray10,
                    ),
                  ),
                ),
              if (isNeedPrimaryButton) ...[
                const SpaceH36(),
              ] else ...[
                const SpaceH20(),
              ],
              if (child != null) child,
              const Spacer(),
              if (isNeedPrimaryButton) ...[
                SPrimaryButton1(
                  name: primaryButtonName,
                  active: activePrimaryButton,
                  onTap: () => onPrimaryButtonTap(),
                ),
                if (onSecondaryButtonTap != null && secondaryButtonName != null) ...[
                  const SpaceH10(),
                  SButton.text(
                    text: secondaryButtonName,
                    callback: () => onSecondaryButtonTap(),
                  ),
                ],
              ],
              if (isNeedCancelButton) ...[
                const SpaceH10(),
                SButton.text(
                  text: cancelText ?? '',
                  callback: () => onCancelButtonTap!(),
                ),
              ],
              const SpaceH20(),
            ],
          ),
        ),
      ),
    ),
    Dialog(
      insetPadding: (Platform.isAndroid)
          ? const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 24.0,
            )
          : const EdgeInsets.symmetric(horizontal: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
        ),
        child: Column(
          children: [
            if (Platform.isAndroid) const SpaceH32() else const SpaceH62(),
            if (image1 != null)
              image1
            else
              Image.asset(
                phoneChangeAsset,
                height: 80,
                width: 80,
                package: 'simple_kit',
              ),
            Baseline(
              baseline: 40.0,
              baselineType: TextBaseline.alphabetic,
              child: Text(
                primaryText1,
                maxLines: (secondaryText1 != null) ? 5 : 12,
                textAlign: TextAlign.center,
                style: STStyles.header6.copyWith(
                  overflow: TextOverflow.visible,
                ),
              ),
            ),
            const SpaceH7(),
            if (secondaryText1 != null)
              Text(
                secondaryText1,
                maxLines: 6,
                textAlign: TextAlign.center,
                style: STStyles.body1Medium.copyWith(
                  color: SColorsLight().gray10,
                ),
              ),
            if (isNeedPrimaryButton1) ...[
              const SpaceH22(),
            ] else ...[
              const SpaceH10(),
            ],
            if (child1 != null) child1,
            const Spacer(),
            if (onSecondaryButtonTap1 != null && secondaryButtonName1 != null) ...[
              SButton.text(
                text: secondaryButtonName1,
                callback: () => onSecondaryButtonTap1(),
              ),
              const SpaceH10(),
            ],
            if (isNeedPrimaryButton1) ...[
              SPrimaryButton1(
                name: primaryButtonName1,
                active: activePrimaryButton1,
                onTap: () => onPrimaryButtonTap1(),
              ),
            ],
            if (isNeedCancelButton1) ...[
              const SpaceH10(),
              SButton.text(
                text: cancelText1 ?? '',
                callback: () => onCancelButtonTap1!(),
              ),
            ],
            const SpaceH20(),
          ],
        ),
      ),
    ),
  ];

  showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) {
      return PopScope(
        canPop: willPopScope,
        onPopInvokedWithResult: (_, __) {
          onWillPop?.call();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 530,
                  child: PageView.builder(
                    controller: controller,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 2,
                    itemBuilder: (_, index) {
                      return Stack(
                        children: [
                          alerts[index],
                          Positioned.fill(
                            top: 20,
                            child: Align(
                              child: slidesControllers,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
