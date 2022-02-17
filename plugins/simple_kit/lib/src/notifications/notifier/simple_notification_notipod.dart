import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'simple_notification_notifier.dart';

final sNotificationNotipod = StateNotifierProvider(
  (ref) => SNotificationNotifier(ref.read),
);
