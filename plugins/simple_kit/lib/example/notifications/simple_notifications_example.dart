import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../simple_kit.dart';

class SimpleNotificationsExample extends ConsumerWidget {
  const SimpleNotificationsExample({Key? key}) : super(key: key);

  static const routeName = '/simple_notifications_example';

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final notificationQueueN = watch(sNotificationQueueNotipod.notifier);

    return SPageFrame(
      child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: Colors.green[200],
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
                notificationQueueN.addToQueue(
                  SNotification(
                    duration: 2,
                    function: (context) {
                      showSNotification(
                        context: context,
                        duration: 2,
                        text: 'Perhaps you missed “.” or “@” somewhere?”',
                      );
                    },
                  ),
                );
              },
              child: const Text(
                'Show notification',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
