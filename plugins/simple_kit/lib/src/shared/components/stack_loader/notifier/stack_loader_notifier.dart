import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class StackLoaderNotifier extends ValueNotifier<bool> {
  StackLoaderNotifier() : super(false);

  Timer _timer = Timer(Duration.zero, () {});

  void startLoading() {
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (timer.tick == 2) {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        value = true;
        timer.cancel();
      }
    });
  }

  void finishLoading() {
    if (_timer.tick >= 3) {
      SystemChannels.textInput.invokeMethod('TextInput.show');
      _timer.cancel();
      value = false;
    } else {
      _timer.cancel();
      _timer = Timer(const Duration(milliseconds: 500), () {
        SystemChannels.textInput.invokeMethod('TextInput.show');
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
