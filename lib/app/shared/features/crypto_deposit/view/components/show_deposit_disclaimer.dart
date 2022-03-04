import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/providers/service_providers.dart';

void showDepositDisclaimer({
  required BuildContext context,
  required String assetSymbol,
  required void Function()? onDismiss,
}) {
  sShowAlertPopup(
    context,
    primaryText: 'Receive only $assetSymbol to this deposit address. '
        'Receiving any other coin or token to this address '
        'may result in loss of your deposit.',
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
