import 'package:flutter/material.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

Future<void> sShowAlertPopup(
  BuildContext context, {
  Function()? onWillPop,
  Function()? onSecondaryButtonTap,
  Function()? onCancelButtonTap,
  String? secondaryText,
  String? secondaryButtonName,
  String? cancelText,
  Widget? image,
  Widget? child,
  bool willPopScope = true,
  bool barrierDismissible = true,
  bool activePrimaryButton = true,
  bool isNeedPrimaryButton = true,
  bool isNeedCancelButton = false,
  bool isPrimaryButtonRed = false,
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
                    const SizedBox(height: 40),
                    if (image != null)
                      image
                    else
                      Assets.svg.brand.small.infoBlue.simpleSvg(
                        height: 80,
                        width: 80,
                      ),
                    if (primaryText.isNotEmpty) ...[
                      Baseline(
                        baseline: 40.0,
                        baselineType: TextBaseline.alphabetic,
                        child: Text(
                          primaryText,
                          maxLines: (secondaryText != null) ? 5 : 12,
                          textAlign: textAlign,
                          style: STStyles.header6.copyWith(
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ),
                      const SizedBox(height: 7),
                    ] else ...[
                      const SizedBox(height: 20),
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
                          style: STStyles.body1Medium.copyWith(
                            color: SColorsLight().gray10,
                          ),
                        ),
                      ),
                    if (isNeedPrimaryButton) ...[
                      const SizedBox(height: 36),
                    ] else ...[
                      const SizedBox(height: 20),
                    ],
                    if (child != null) child,
                    if (isNeedPrimaryButton) ...[
                      if (isPrimaryButtonRed)
                        SButton.red(
                          text: primaryButtonName,
                          callback: activePrimaryButton ? () => onPrimaryButtonTap() : null,
                        )
                      else
                        SButton.black(
                          text: primaryButtonName,
                          callback: activePrimaryButton ? () => onPrimaryButtonTap() : null,
                        ),
                      if (onSecondaryButtonTap != null && secondaryButtonName != null) ...[
                        const SizedBox(height: 10),
                        SButton.text(
                          text: secondaryButtonName,
                          callback: () => onSecondaryButtonTap(),
                        ),
                      ],
                    ],
                    if (isNeedCancelButton) ...[
                      const SizedBox(height: 10),
                      SButton.text(
                        text: cancelText ?? '',
                        callback: () => onCancelButtonTap!(),
                      ),
                    ],
                    const SizedBox(height: 20),
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
