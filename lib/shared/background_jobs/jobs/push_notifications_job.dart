import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../service/services/notification/model/register_token_request_model.dart';
import '../../../service/services/notification/service/notification_service.dart';
import '../../../service_providers.dart';
import '../../logging/levels.dart';

final _logger = Logger('');

final pushNotificationSpod = StreamProvider<String>((ref) {
  return FirebaseMessaging.instance.onTokenRefresh;
}, name: 'pushNotificationSpod');

final pushNotificationPod = Provider<void>((ref) async {
  final notification = ref.watch(pushNotificationSpod);
  final service = ref.watch(notificationServicePod);

  if (!kIsWeb) {
    try {
      final token = await FirebaseMessaging.instance.getToken();

      try {
        await _registerToken(service, token);

        notification.whenData(
          (token) => _registerToken(service, token),
        );
      } catch (e) {
        _logger.log(pushNotifications, 'registerToken Failed', e);
      }
    } catch (e) {
      _logger.log(pushNotifications, 'getToken Failed', e);
    }
  }
}, name: 'pushNotificationPod');

Future<void> _registerToken(NotificationService service, String? token) async {
  if (token != null) {
    final model = RegisterTokenRequestModel(token: token, locale: 'en');

    await service.registerToken(model);
  }
}
