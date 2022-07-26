import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../simple_kit.dart';

class SimpleNotificationsExample extends ConsumerWidget {
  const SimpleNotificationsExample({Key? key}) : super(key: key);

  static const routeName = '/simple_notifications_example';

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final notificationN = watch(sNotificationNotipod.notifier);

    return SPageFrameWithPadding(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ColoredBox(
            color: Colors.green[200]!,
            child: const SNotificationBox(
              text: 'Perhaps you missed “.” or “@” somewhere?”',
            ),
          ),
          const SNotificationBox(
            text: 'Single line Error',
          ),
          const SpaceH10(),
          TextButton(
            onPressed: () async {
              notificationN.showError(
                'Perhaps you missed “.” or “@” somewhere?”',
              );
            },
            child: const Text(
              'Show notification',
            ),
          ),
        ],
      ),
    );
  }
}
