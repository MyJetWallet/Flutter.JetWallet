import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

class TimerNotifier extends StateNotifier<int> {
  TimerNotifier(this.initial) : super(initial) {
    refreshTimer();
  }

  void refreshTimer() {
    state = initial;
    
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (state == 0) {
          timer.cancel();
        } else {
          state--;
        }
      },
    );
  }

  final int initial;

  late Timer _timer;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
