import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:simple_kit/simple_kit.dart';

void showUsePhonebookAlert({
  required BuildContext context,
  required Function() onUsePhonebook,
  required Function() onPopupQuit,
}) {
  sShowAlertPopup(
    context,
    image: Image.asset(
      usePhonebookImageAsset,
      height: 180,
      width: 180,
    ),
    onWillPop: onPopupQuit,
    primaryText: '${intl.showUsePhonebookAlert_usePhonebook}?',
    primaryButtonName: intl.showUsePhonebookAlert_usePhonebook,
    secondaryButtonName: intl.showUsePhonebookAlert_enterManually,
    secondaryText: '${intl.showContactsPermission_secondaryText1}\n\n'
        '${intl.showContactsPermission_secondaryText2}.',
    onPrimaryButtonTap: onUsePhonebook,
    onSecondaryButtonTap: () {
      onPopupQuit();
      Navigator.pop(context);
    },
  );
}
