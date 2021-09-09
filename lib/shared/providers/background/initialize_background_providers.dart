import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'dynamic_link_pod.dart';
import 'log_records_notipod.dart';
import 'push_notification_pods.dart';

/// By [reading] we are initializing our jobs so they can start to work
/// We are not interested in [ref.watch()] since we will have an infinte loop
final initializeBackgroundProviders = Provider<void>(
  (ref) {
    ref.read(logRecordsNotipod);
    ref.read(pushNotificationGetTokenFpod);
    ref.read(pushNotificationOnTokenRefreshSpod);
    ref.read(dynamicLinkPod);
  },
  name: 'initializeBackgroundJobs',
);
