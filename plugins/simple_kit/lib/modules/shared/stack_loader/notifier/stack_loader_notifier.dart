import 'dart:async';

import 'package:flutter/foundation.dart';

class StackLoaderNotifier extends ValueNotifier<bool> {
  StackLoaderNotifier() : super(false);

  late Timer _timer;

  void startLoadingImmediately() => value = true;
  void finishLoadingImmediately() => value = false;

  void startLoading() {
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (timer.tick == 2) {
        value = true;
        timer.cancel();
      }
    });
  }

  void finishLoading({VoidCallback? onFinish}) {
    if (_timer.tick >= 3) {
      _timer.cancel();
      value = false;
      onFinish?.call();
    } else {
      _timer.cancel();
      _timer = Timer(const Duration(milliseconds: 500), () {
        _timer.cancel();
        value = false;
        onFinish?.call();
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
