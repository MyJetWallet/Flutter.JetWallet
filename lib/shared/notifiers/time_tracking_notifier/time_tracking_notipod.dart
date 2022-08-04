import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'time_tracking_notifier.dart';
import 'time_tracking_state.dart';

final timeTrackingNotipod =
    StateNotifierProvider.autoDispose<TimeTrackingNotifier, TimeTrackingState>(
      (ref) {
    return TimeTrackingNotifier();
  },
  name: 'timeTrackingNotipod',
);
