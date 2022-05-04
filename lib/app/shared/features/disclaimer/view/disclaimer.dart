import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../shared/constants.dart';
import '../model/disclaimer_model.dart';
import '../notifier/disclaimer_notipod.dart';
import 'components/disclaimer_popup.dart';

// void showsDisclaimer({
//   String? imageAsset,
//   String? secondaryButtonName,
//   Function()? onSecondaryButtonTap,
//   Widget? child,
//   bool activePrimaryButton = true,
//   required List<DisclaimerQuestionsModel> questions,
//   required BuildContext context,
//   required String primaryText,
//   required String secondaryText,
//   required String primaryButtonName,
//   required Widget button,
// }) {
//   final state = context.read(disclaimerNotipod);
//
//   sShowDisclaimerPopup(
//     context,
//     image: SizedBox(
//       height: 80,
//       width: 80,
//       child: imageAsset != null
//           ? Image.network(
//               imageAsset,
//             )
//           : Image.asset(
//               disclaimerAsset,
//             ),
//     ),
//     primaryText: primaryText,
//     secondaryText: secondaryText,
//     child: child,
//     primaryButtonName: primaryButtonName,
//     secondaryButtonName: secondaryButtonName,
//     onSecondaryButtonTap: onSecondaryButtonTap,
//     activePrimaryButton: state.activeButton,
//     questions: questions,
//     button: button,
//   );
// }


void showsDisclaimer({
  required Widget child,
  required BuildContext context,
}) {
  sShowDisclaimerPopup(
    context,
    child: child,
  );
}