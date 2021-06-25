import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../notifiers/timer_notifier.dart';

final timerNotipod =
    StateNotifierProvider.autoDispose.family<TimerNotifier, int, int>(
  (ref, initial) {
    return TimerNotifier(initial);
  },
);

