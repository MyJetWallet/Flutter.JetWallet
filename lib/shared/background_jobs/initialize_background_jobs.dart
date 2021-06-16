import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'jobs/log_records_job.dart';

/// By watching we are initializing our jobs so they can start to work
final initializeBackgroundJobs = Provider<void>((ref) {
  ref.watch(logRecordsJob);
}, name: 'initializeBackgroundJobs');
