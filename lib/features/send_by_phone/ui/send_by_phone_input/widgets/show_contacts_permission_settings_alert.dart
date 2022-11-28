import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
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
    primaryText: intl.showContactPermission_primaryText,
    primaryButtonName: intl.showContactPermission_goToSettings,
    secondaryButtonName: intl.showContactPermission_enterManually,
    secondaryText: '${intl.showContactsPermission_secondaryText1}\n\n'
        '${intl.showContactsPermission_secondaryText2}.',
    onPrimaryButtonTap: onGoToSettings,
    onSecondaryButtonTap: () {
      Navigator.pop(context);
    },
  );
}
