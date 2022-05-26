import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../shared/providers/service_providers.dart';

void showContactsPermissionSettingsAlert({
  required BuildContext context,
  required Function() onGoToSettings,
}) {
  final intl = context.read(intlPod);

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
