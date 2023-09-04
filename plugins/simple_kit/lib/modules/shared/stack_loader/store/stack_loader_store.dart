import 'dart:async';
import 'package:mobx/mobx.dart';
import 'package:flutter/foundation.dart';

part 'stack_loader_store.g.dart';

// ignore: library_private_types_in_public_api
class StackLoaderStore = _StackLoaderStoreBase with _$StackLoaderStore;

abstract class _StackLoaderStoreBase with Store {
  @observable
  bool loading = false;
  @action
  setLoading(bool value) => loading = value;

  // ignore: no-empty-block
  Timer _timer = Timer(Duration.zero, () {});

  @action
  void startLoadingImmediately() => loading = true;

  @action
  void finishLoadingImmediately() => loading = false;

  @action
  void startLoading() {
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (timer.tick == 2) {
        loading = true;
        timer.cancel();
      }
    });
  }

  @action
  void finishLoading({VoidCallback? onFinish}) {
    if (_timer.tick >= 3) {
      _timer.cancel();
      loading = false;
      onFinish?.call();
    } else {
      _timer.cancel();
      _timer = Timer(const Duration(milliseconds: 500), () {
        _timer.cancel();
        loading = false;
        onFinish?.call();
      });
    }
  }

  @action
  void dispose() {
    _timer.cancel();
  }
}
