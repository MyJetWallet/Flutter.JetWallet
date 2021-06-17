import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'jobs/log_records_job.dart';
import 'jobs/push_notifications_job.dart';

/// By [reading] we are initializing our jobs so they can start to work
/// We are not interested in [ref.watch()] since we will have an infinte loop
final initializeBackgroundJobs = Provider<void>((ref) {
  ref.read(logRecordsNotipod);
  ref.read(pushNotificationPod);
}, name: 'initializeBackgroundJobs');
