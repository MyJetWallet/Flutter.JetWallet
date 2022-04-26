import 'package:flutter/material.dart';

import '../../../../../shared/constants.dart';
import '../model/disclaimer_model.dart';
import 'components/disclaimer_popup.dart';

void showsDisclaimer({
  String? imageAsset,
  String? secondaryButtonName,
  Function()? onSecondaryButtonTap,
  Widget? child,
  bool activePrimaryButton = true,
  required List<DisclaimerQuestionsModel> questions,
  required BuildContext context,
  required String primaryText,
  required String secondaryText,
  required String primaryButtonName,
  required Function() onPrimaryButtonTap,
}) {
  sShowDisclaimerPopup(
    context,
    image: imageAsset != null
        ? Image.network(
            imageAsset,
          )
        : SizedBox(
            height: 80,
            width: 80,
            child: Image.asset(
              disclaimerAsset,
            ),
          ),
    primaryText: primaryText,
    secondaryText: secondaryText,
    child: child,
    primaryButtonName: primaryButtonName,
    secondaryButtonName: secondaryButtonName,
    onPrimaryButtonTap: onPrimaryButtonTap,
    onSecondaryButtonTap: onSecondaryButtonTap,
    activePrimaryButton: activePrimaryButton,
    questions: questions,
  );
}
