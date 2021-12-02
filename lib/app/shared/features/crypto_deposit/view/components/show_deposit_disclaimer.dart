import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

void showDepositDisclaimer(BuildContext context, String assetSymbol) {
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
    },
  );
}
