import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/disclaimer/disclaimers_response_model.dart';

void sShowDisclaimerPopup(
  BuildContext context, {
  Function()? onWillPop,
  Function()? onSecondaryButtonTap,
  String? secondaryText,
  String? secondaryButtonName,
  Widget? topSpacer,
  Widget? child,
  bool willPopScope = true,
  bool activePrimaryButton = true,
  SButtonType primaryButtonType = SButtonType.primary1,
  required List<DisclaimerQuestionsModel> questions,
  required Widget image,
  required String primaryText,
  required String primaryButtonName,
}) {
  final colors = sKit.colors;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return PopScope(
        canPop: false,
        onPopInvoked: (_) {
          Future.value(false);
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
                    image,
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
                          color: colors.grey1,
                        ),
                      ),
                    const SpaceH40(),
                    const SDivider(),
                    if (child != null) child,
                    const SpaceH20(),
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
