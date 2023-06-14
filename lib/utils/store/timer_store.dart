import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

part 'timer_store.g.dart';

class TimerStore extends _TimerStoreBase with _$TimerStore {
  TimerStore(int initial) : super(initial);

  static TimerStore of(BuildContext context) =>
      Provider.of<TimerStore>(context, listen: false);
}

abstract class _TimerStoreBase with Store {
  _TimerStoreBase(this.initial) {
    refreshTimer();
  }

  @observable
  Timer? _timer;

  @observable
  int time = 0;

  @observable
  late int initial;

  @action
  void refreshTimer() {
    _timer?.cancel();

    final initialInt = initial;

    time = initialInt;
    final initialTime = (DateTime.now().millisecondsSinceEpoch / 1000).round();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (time <= 0) {
          timer.cancel();
        } else {
          final currentTime =
              (DateTime.now().millisecondsSinceEpoch / 1000).round();
          time = initialTime - currentTime + initialInt;

          //print(time);
        }
      },
    );
  }

  @action
  void dispose() {
    _timer?.cancel();
  }
}
