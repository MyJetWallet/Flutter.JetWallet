import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../shared/constants.dart';
import '../../../../../../../../shared/providers/service_providers.dart';

void showUsePhonebookAlert({
  required BuildContext context,
  required Function() onUsePhonebook,
  required Function() onPopupQuit,
}) {
  final intl = context.read(intlPod);

  sShowAlertPopup(
    context,
    image: Image.asset(
      usePhonebookImageAsset,
      height: 180,
      width: 180,
    ),
    onWillPop: onPopupQuit,
    primaryText: '${intl.usePhonebook}?',
    primaryButtonName: intl.usePhonebook,
    secondaryButtonName: intl.enterManually,
    secondaryText: '${intl.showContactsPermission_secondaryText1}\n\n'
        '${intl.showContactsPermission_secondaryText2}.',
    onPrimaryButtonTap: onUsePhonebook,
    onSecondaryButtonTap: () {
      onPopupQuit();
      Navigator.pop(context);
    },
  );
}
