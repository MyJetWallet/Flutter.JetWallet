import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'timer_family.dart';
import 'timer_notifier.dart';

final timerNotipod =
    StateNotifierProvider.autoDispose.family<TimerNotifier, int, TimerFamily>(
  (ref, family) {
    return TimerNotifier(family.duration);
  },
);
