import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../shared/providers/service_providers.dart';

void showDepositDisclaimer(BuildContext context, String assetSymbol) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (builderContext) {
      return WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: AlertDialog(
          title: const Text(
            'Info',
          ),
          content: Text(
            'Send only $assetSymbol to this deposit address. '
            'Sending any other coin or token to this '
            'address may result in loss of your deposit.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(builderContext);
                final storage = context.read(localStorageServicePod);
                storage.setString(assetSymbol, 'accepted');
              },
              child: const Text(
                'Got it!',
              ),
            )
          ],
        ),
      );
    },
  );
}
