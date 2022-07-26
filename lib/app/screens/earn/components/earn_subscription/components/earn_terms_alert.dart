import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/features/high_yield_disclaimer/notifier/high_yield_disclaimer_notipod.dart';

void sShowEarnTermsAlertPopup(
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
      return EarnTermsAlert(
        onWillPop: onWillPop,
        onSecondaryButtonTap: onSecondaryButtonTap,
        secondaryText: secondaryText,
        secondaryButtonName: secondaryButtonName,
        image: image,
        topSpacer: topSpacer,
        willPopScope: willPopScope,
        barrierDismissible: barrierDismissible,
        isNeedPrimaryButton: isNeedPrimaryButton,
        primaryText: primaryText,
        primaryButtonName: primaryButtonName,
        onPrimaryButtonTap: onPrimaryButtonTap,
        child: child,
      );
    },
  );
}

class EarnTermsAlert extends HookWidget {
  const EarnTermsAlert({
    Key? key,
    this.onWillPop,
    this.onSecondaryButtonTap,
    this.secondaryText,
    this.secondaryButtonName,
    this.image,
    this.topSpacer,
    this.child,
    this.willPopScope = true,
    this.barrierDismissible = true,
    this.activePrimaryButton = true,
    this.isNeedPrimaryButton = true,
    this.primaryButtonType = SButtonType.primary1,
    required this.primaryText,
    required this.primaryButtonName,
    required this.onPrimaryButtonTap,
  }) : super(key: key);

  final Function()? onWillPop;
  final Function()? onSecondaryButtonTap;
  final String? secondaryText;
  final String? secondaryButtonName;
  final Widget? image;
  final Widget? topSpacer;
  final Widget? child;
  final bool willPopScope;
  final bool barrierDismissible;
  final bool activePrimaryButton;
  final bool isNeedPrimaryButton;
  final SButtonType primaryButtonType;
  final String primaryText;
  final String primaryButtonName;
  final Function() onPrimaryButtonTap;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final disclaimer = useProvider(highYieldDisclaimerNotipod);

    return WillPopScope(
      onWillPop: () {
        onWillPop?.call();
        return Future.value(willPopScope);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Dialog(
            insetPadding: (Platform.isAndroid)
                ? const EdgeInsets.all(24.0)
                : const EdgeInsets.symmetric(horizontal: 24.0),
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
                    image ?? const SizedBox.shrink()
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
                      secondaryText ?? '',
                      maxLines: 6,
                      textAlign: TextAlign.center,
                      style: sBodyText1Style.copyWith(
                        color: colors.grey1,
                      ),
                    ),
                  if (isNeedPrimaryButton) ...[
                    const SpaceH36(),
                  ] else ...[
                    const SpaceH20(),
                  ],
                  if (child != null) child!,
                  if (isNeedPrimaryButton) ...[
                    if (primaryButtonType == SButtonType.primary1)
                      SPrimaryButton1(
                        name: primaryButtonName,
                        active: disclaimer.activeButton,
                        onTap: () => onPrimaryButtonTap(),
                      )
                    else if (primaryButtonType == SButtonType.primary2)
                      SPrimaryButton2(
                        name: primaryButtonName,
                        active: disclaimer.activeButton,
                        onTap: () => onPrimaryButtonTap(),
                      )
                    else
                      SPrimaryButton3(
                        name: primaryButtonName,
                        active: disclaimer.activeButton,
                        onTap: () => onPrimaryButtonTap(),
                      ),
                    if (onSecondaryButtonTap != null &&
                        secondaryButtonName != null) ...[
                      const SpaceH10(),
                      STextButton1(
                        name: secondaryButtonName ?? '',
                        active: true,
                        onTap: () => onSecondaryButtonTap!(),
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
  }
}
