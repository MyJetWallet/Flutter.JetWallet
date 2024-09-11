import 'dart:async';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

part 'jar_update_store.g.dart';

@lazySingleton
class JarUpdateStore extends _JarUpdateStoreBase with _$JarUpdateStore {
  JarUpdateStore() : super();

  static _JarUpdateStoreBase of(BuildContext context) => Provider.of<JarUpdateStore>(context);
}

abstract class _JarUpdateStoreBase with Store {
  Timer? _timer;

  static const Duration _timerTime = Duration(seconds: 5);

  @observable
  bool started = false;

  @action
  void setStarted(bool value) => started = value;

  @action
  void start(Function() refresh) {
    if (!started) {
      setStarted(true);
      _timer = Timer.periodic(
        _timerTime,
        (timer) {
          refresh();
        },
      );
    }
  }

  @action
  void stop() {
    if (started) {
      setStarted(false);
      if (_timer != null) {
        _timer!.cancel();
      }
    }
  }
}
