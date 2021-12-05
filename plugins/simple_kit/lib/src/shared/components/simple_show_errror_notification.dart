import '../../../simple_kit.dart';

void sShowErrorNotification(
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
