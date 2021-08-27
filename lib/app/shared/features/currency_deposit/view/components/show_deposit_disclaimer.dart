import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../shared/providers/service_providers.dart';
import '../../../../../../shared/services/local_storage_service.dart';

void showDepositDisclaimer(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: AlertDialog(
          title: const Text(
            'Info',
          ),
          content: const Text(
            'Send only BTC to this deposit address. '
            'Sending any other coin or token to this '
            'address may result in loss of your deposit.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                final storage = context.read(localStorageServicePod);
                storage.setString(depositDisclaimer, 'accepted');
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
