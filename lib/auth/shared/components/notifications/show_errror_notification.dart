import 'package:simple_kit/simple_kit.dart';

void showErrorNotification(
  SNotificationQueueNotifier notifier,
  String text,
) {
  notifier.addToQueue(
    SNotification(
      duration: 3,
      function: (context) {
        showSNotification(
          context: context,
          duration: 3,
          text: text,
        );
      },
    ),
  );
}
