import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../service/services/notification/model/register_token_request_model.dart';
import '../../../service/services/notification/service/notification_service.dart';
import '../../../service_providers.dart';
import '../../logging/levels.dart';

final _logger = Logger('');

final pushNotificationGetTokenFpod = FutureProvider<String?>((ref) {
  if (!kIsWeb) {
    try {
      return FirebaseMessaging.instance.getToken();
    } catch (e) {
      _logger.log(pushNotifications, 'getToken Failed', e);
      return Future.value(null);
    }
  } else {
    return Future.value(null);
  }
}, name: 'pushNotificationGetTokenFpod');

final pushNotificationOnTokenRefreshSpod = StreamProvider<String>((ref) {
  return FirebaseMessaging.instance.onTokenRefresh;
}, name: 'pushNotificationOnTokenRefreshSpod');

/// Must be initialized after [successfull authentication]
final pushNotificationRegisterTokenPod = Provider<void>((ref) {
  final service = ref.watch(notificationServicePod);
  final getToken = ref.watch(pushNotificationGetTokenFpod);

  getToken.whenData((token) => _registerToken(service, token));
}, name: 'pushNotificationRegisterTokenPod');

/// Must be initialized after [successfull authentication]
final pushNotificationOnTokenRefreshPod = Provider<void>((ref) async {
  final service = ref.watch(notificationServicePod);
  final onTokenRefresh = ref.watch(pushNotificationOnTokenRefreshSpod);

  onTokenRefresh.whenData((token) => _registerToken(service, token));
}, name: 'pushNotificationOnTokenRefreshPod');

Future<void> _registerToken(NotificationService service, String? token) async {
  if (token != null) {
    final model = RegisterTokenRequestModel(
      token: token,
      locale: 'en',
    );

    try {
      await service.registerToken(model);
    } catch (e) {
      _logger.log(pushNotifications, 'registerToken Failed', e);
    }
  }
}
