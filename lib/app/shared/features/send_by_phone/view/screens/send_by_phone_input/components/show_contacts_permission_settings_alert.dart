import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

void showContactsPermissionSettingsAlert({
  required BuildContext context,
  required Function() onGoToSettings,
}) {
  sShowAlertPopup(
    context,
    // TODO placeholder widget (will be changed when design will be ready)
    image: Container(
      height: 204.0,
      color: Colors.grey[200],
    ),
    topSpacer: const SpaceH20(),
    primaryText: 'Give permission to allow to use Phonebook',
    primaryButtonName: 'Go to settings',
    secondaryButtonName: 'Enter manually',
    secondaryText: "It's easy to invite friends when choosing them from "
        'the address book on your phone. \n\n  '
        "Otherwise, you'll have to type contact info individually.",
    onPrimaryButtonTap: onGoToSettings,
    onSecondaryButtonTap: () {
      Navigator.pop(context);
    },
  );
}
