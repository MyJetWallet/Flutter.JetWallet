import 'dart:async';

import 'package:state_notifier/state_notifier.dart';

class TimerNotifier extends StateNotifier<int> {
  TimerNotifier(this.initial) : super(initial) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state == 0) {
        timer.cancel();
      } else {
        state--;
      }
    });
  }

  final int initial;

  late final Timer _timer;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
