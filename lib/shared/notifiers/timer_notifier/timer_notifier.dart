import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

class TimerNotifier extends StateNotifier<int> {
  TimerNotifier(this.initial) : super(initial.toInt()) {
    refreshTimer();
  }

  Timer? _timer;
  final double initial;

  void refreshTimer() {
    _timer?.cancel();
    state = initial.toInt();
    final initialTime = (DateTime.now().millisecondsSinceEpoch / 1000).round();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (state <= 0) {
          if (!mounted) return;
          timer.cancel();
        } else {
          final currentTime =
              (DateTime.now().millisecondsSinceEpoch / 1000).round();
          state = initialTime - currentTime + initial.toInt();
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
