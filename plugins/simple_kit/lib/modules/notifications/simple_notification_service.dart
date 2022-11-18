import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:simple_kit/modules/notifications/model/notification_model.dart';
import 'package:simple_kit/modules/notifications/show_notification.dart';
import 'package:state_notifier/state_notifier.dart';

const _delay = Duration(milliseconds: 500);

/// If snackbar with id "x" is in the queue and you are trying
/// to show a second snackbar with the same id "x", it won't be
/// added to the queue until the first snackbar will finish displaying.
class SNotificationNotifier extends StateNotifier<Queue<NotificationModel>> {
  SNotificationNotifier(this.context) : super(Queue());

  late BuildContext context;

  NotificationModel? _currentNotification;

  void showError(
    String message, {
    int duration = 2,
    int? id,
    bool needFeedback = false,
  }) {
    _addToQueue(
      NotificationModel(
        id: id,
        show: () => showNotification(context, message, duration),
      ),
    );
  }

  void _addToQueue(NotificationModel notification) {
    if (notification.id != null) {
      for (final element in state) {
        if (element.id == notification.id) {
          return;
        }
      }
    }

    state.add(notification);
    state = Queue.from(state);

    if (_currentNotification == null) {
      _showSnackbar();
    }
  }

  void _removeFromQueue(NotificationModel notification) {
    state.remove(notification);
    state = Queue.from(state);
  }

  void _showSnackbar() {
    if (state.isNotEmpty) {
      _currentNotification = state.first;

      state.first.show().then((_) {
        _removeFromQueue(state.first);

        Future.delayed(_delay, _showSnackbar);
      });
    } else {
      _currentNotification = null;
    }
  }
}
