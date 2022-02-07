import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../shared/constants.dart';

void showUsePhonebookAlert({
  required BuildContext context,
  required Function() onUsePhonebook,
  required Function() onPopupQuit,
}) {
  sShowAlertPopup(
    context,
    // TODO placeholder widget (will be changed when design will be ready)
    image: Image.asset(
      usePhonebookImageAsset,
      height: 180,
      width: 180,
    ),
    onWillPop: onPopupQuit,
    primaryText: 'Use Phonebook?',
    primaryButtonName: 'Use Phonebook',
    secondaryButtonName: 'Enter manually',
    secondaryText: 'Inviting friends is simple when choosing them from '
        'the address book on your phone. \n\n  '
        "Otherwise, you'll have to type contact info individually.",
    onPrimaryButtonTap: onUsePhonebook,
    onSecondaryButtonTap: () {
      onPopupQuit();
      Navigator.pop(context);
    },
  );
}
