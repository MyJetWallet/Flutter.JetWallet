import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../simple_kit.dart';

class SNotificationQueueNotifier extends StateNotifier<Queue<SNotification>> {
  SNotificationQueueNotifier(this.read) : super(Queue()) {
    navigatorKey = read(sNavigatorKeyPod);
  }

  final Reader read;

  late GlobalKey<NavigatorState> navigatorKey;
  Timer? _timer;
  bool showingNotifications = false;

  void addToQueue(SNotification notification) {
    state.add(notification);
    state = Queue.from(state);
    if (!showingNotifications) _showNotification();
  }

  void _removeFromQueue(SNotification notification) {
    state.remove(notification);
    state = Queue.from(state);
  }

  Future<void> _showNotification() async {
    if (state.isNotEmpty) {
      showingNotifications = true;
      _refreshTimer(state.first.duration);
      state.first.function(navigatorKey.currentContext!);
      _removeFromQueue(state.first);
    } else {
      showingNotifications = false;
    }
  }

  void _refreshTimer(int timerStep) {
    _timer?.cancel();
    var currentTime = timerStep;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (currentTime == 0) {
          _timer?.cancel();
          _showNotification();
        } else {
          currentTime--;
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
