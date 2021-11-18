import 'dart:async';

import 'package:flutter/foundation.dart';

class StackLoaderNotifier extends ValueNotifier<bool> {
  StackLoaderNotifier() : super(false);

  Timer _timer = Timer(Duration.zero, () {});

  void startLoading() {
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (timer.tick == 2) {
        value = true;
        timer.cancel();
      }
    });
  }

  void finishLoading() {
    if (_timer.tick >= 3) {
      _timer.cancel();
      value = false;
    } else {
      _timer.cancel();
      _timer = Timer(const Duration(milliseconds: 500), () {
        _timer.cancel();
        value = false;
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
