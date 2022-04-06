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
  final action = screenTitle == 'Receive' ? screenTitle : 'Send';

  sShowAlertPopup(
    context,
    primaryText: '$action only $assetSymbol to this deposit address. '
        'Receiving any other coin or token to this address '
        'may result in loss of the transfer amount.',
    primaryButtonName: 'Got it',
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
