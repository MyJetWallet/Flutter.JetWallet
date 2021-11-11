import 'dart:async';

import 'package:flutter/foundation.dart';

class StackLoaderNotifier extends ValueNotifier<bool> {
  StackLoaderNotifier() : super(false);

  Timer _timer = Timer(Duration.zero, () {});

  void startLoading() {
    _timer = Timer(const Duration(seconds: 1), () {
      value = true;
    });
  }

  void finishLoading() {
    if (_timer.tick > 0.5) {
      value = false;
    }
  }
}
