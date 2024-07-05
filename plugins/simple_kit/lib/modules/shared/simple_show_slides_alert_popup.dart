import 'dart:io';

import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import '../../../simple_kit.dart';

// ignore: long-method
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
  Widget? topSpacer,
  Widget? topSpacer1,
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
  SButtonType primaryButtonType = SButtonType.primary1,
  SButtonType primaryButtonType1 = SButtonType.primary1,
  required String primaryText,
  required String primaryText1,
  required String primaryButtonName,
  required String primaryButtonName1,
  required Function() onPrimaryButtonTap,
  required Function() onPrimaryButtonTap1,
  required PageController controller,
  required Widget slidesControllers,
  required SWidgetSize size,
}) {
  final widgetSizeSmall = size == SWidgetSize.small;
  final useSmallSizes = Platform.isAndroid || widgetSizeSmall;
  final alerts = [
    Dialog(
      insetPadding: useSmallSizes
          ? const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 24.0,
            )
          : const EdgeInsets.symmetric(horizontal: 6),
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
              topSpacer1 ??
                  (widgetSizeSmall
                      ? const SpaceH18()
                      : Platform.isAndroid
                          ? const SpaceH32()
                          : const SpaceH62()),
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
                    style: sTextH5Style.copyWith(
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
                    style: sBodyText1Style.copyWith(
                      color: SColorsLight().grey1,
                    ),
                  ),
                ),
              if (isNeedPrimaryButton) ...[
                if (useSmallSizes) const SpaceH22() else const SpaceH36(),
              ] else ...[
                if (useSmallSizes) const SpaceH10() else const SpaceH20(),
              ],
              if (child != null) child,
              const Spacer(),
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
    ),
    Dialog(
      insetPadding: (Platform.isAndroid || size == SWidgetSize.small)
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
            topSpacer1 ??
                (widgetSizeSmall
                    ? const SpaceH18()
                    : Platform.isAndroid
                        ? const SpaceH32()
                        : const SpaceH62()),
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
                style: sTextH5Style.copyWith(
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
                style: sBodyText1Style.copyWith(
                  color: SColorsLight().grey1,
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
              STextButton1(
                name: secondaryButtonName1,
                active: true,
                onTap: () => onSecondaryButtonTap1(),
              ),
              const SpaceH10(),
            ],
            if (isNeedPrimaryButton1) ...[
              if (primaryButtonType1 == SButtonType.primary1)
                SPrimaryButton1(
                  name: primaryButtonName1,
                  active: activePrimaryButton1,
                  onTap: () => onPrimaryButtonTap1(),
                )
              else if (primaryButtonType1 == SButtonType.primary2)
                SPrimaryButton2(
                  name: primaryButtonName1,
                  active: activePrimaryButton1,
                  onTap: () => onPrimaryButtonTap1(),
                )
              else
                SPrimaryButton3(
                  name: primaryButtonName1,
                  active: activePrimaryButton1,
                  onTap: () => onPrimaryButtonTap1(),
                ),
            ],
            if (isNeedCancelButton1) ...[
              const SpaceH10(),
              STextButton1(
                active: true,
                name: cancelText1 ?? '',
                onTap: () => onCancelButtonTap1!(),
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
        onPopInvoked: (_) {
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
