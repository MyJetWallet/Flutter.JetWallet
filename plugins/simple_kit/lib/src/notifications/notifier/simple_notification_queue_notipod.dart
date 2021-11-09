import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'simple_notification_queue_notifier.dart';

final sNotificationQueueNotipod = StateNotifierProvider(
  (ref) => SNotificationQueueNotifier(ref.read),
);
