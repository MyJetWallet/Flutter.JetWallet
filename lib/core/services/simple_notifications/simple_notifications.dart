import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/simple_notifications/model/simple_notification_model.dart';
import 'package:jetwallet/core/services/simple_notifications/view/show_notification.dart';

const _delay = Duration(milliseconds: 500);

/// If snackbar with id "x" is in the queue and you are trying
/// to show a second snackbar with the same id "x", it won't be
/// added to the queue until the first snackbar will finish displaying.
@lazySingleton
class SNotificationNotifier {
  SNotificationNotifier() : super() {
    context = getIt.get<AppRouter>().navigatorKey.currentContext!;
  }

  late BuildContext context;

  NotificationModel? _currentNotification;

  Queue<NotificationModel> queue = Queue();

  void showError(
    String message, {
    int duration = 2,
    int? id,
    bool needFeedback = false,
  }) {
    _addToQueue(
      NotificationModel(
        id: id,
        show: () => showNotification(context, message, duration, needFeedback),
      ),
    );
  }

  void _addToQueue(NotificationModel notification) {
    if (notification.id != null) {
      for (final element in queue) {
        if (element.id == notification.id) {
          return;
        }
      }
    }

    queue.add(notification);
    queue = Queue.from(queue);

    if (_currentNotification == null) {
      _showSnackbar();
    }
  }

  void _removeFromQueue(NotificationModel notification) {
    queue.remove(notification);
    queue = Queue.from(queue);
  }

  void _showSnackbar() {
    if (queue.isNotEmpty) {
      _currentNotification = queue.first;

      queue.first.show().then((_) {
        _removeFromQueue(queue.first);

        Future.delayed(_delay, _showSnackbar);
      });
    } else {
      _currentNotification = null;
    }
  }
}
