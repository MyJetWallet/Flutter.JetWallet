import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/providers/service_providers.dart';

void showDepositDisclaimer({
  required BuildContext context,
  required String assetSymbol,
  required String screenTitle,
  required void Function()? onDismiss,
}) {
  final intl = context.read(intlPod);
  final action = screenTitle == 'Receive' ? screenTitle : intl.send;

  sShowAlertPopup(
    context,
    primaryText:
        '$action ${intl.only} '
            '$assetSymbol ${intl.showDepositDisclaimer_primatyText}',
    primaryButtonName: intl.gotIt,
    barrierDismissible: false,
    willPopScope: false,
    onPrimaryButtonTap: () {
      Navigator.pop(context);
      final storage = context.read(localStorageServicePod);
      storage.setString(assetSymbol, 'accepted');
      if (onDismiss != null) {
        onDismiss();
      }
    },
  );
}
