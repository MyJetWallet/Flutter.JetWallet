import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'timer_notifier.dart';

final timerNotipod =
    StateNotifierProvider.autoDispose.family<TimerNotifier, int, num>(
  (ref, initial) {
    return TimerNotifier(initial.toInt());
  },
);
