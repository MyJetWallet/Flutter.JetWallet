import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../shared/constants.dart';
import '../model/disclaimer_model.dart';
import '../notifier/disclaimer_notipod.dart';
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
  final state = context.read(disclaimerNotipod);

  sShowDisclaimerPopup(
    context,
    image: imageAsset != null
        ? SizedBox(
            height: 80,
            width: 80,
            child: Image.network(
              imageAsset,
            ),
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
    activePrimaryButton: state.activeButton,
    questions: questions,
  );
}
