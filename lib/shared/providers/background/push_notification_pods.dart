import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/notification/model/register_token_request_model.dart';
import 'package:simple_networking/services/notification/service/notification_service.dart';

import '../../logging/levels.dart';
import '../service_providers.dart';

final _logger = Logger('');

final pushNotificationGetTokenFpod = FutureProvider<String?>(
  (ref) {
    if (!kIsWeb) {
      try {
        return FirebaseMessaging.instance.getToken();
      } catch (e) {
        _logger.log(pushNotifications, 'getToken Failed', e);
        return Future.value();
      }
    } else {
      return Future.value();
    }
  },
  name: 'pushNotificationGetTokenFpod',
);

final pushNotificationOnTokenRefreshSpod = StreamProvider<String>(
  (ref) {
    return FirebaseMessaging.instance.onTokenRefresh;
  },
  name: 'pushNotificationOnTokenRefreshSpod',
);

/// Must be initialized after [successfull authentication]
final pushNotificationRegisterTokenPod = Provider.autoDispose<void>(
  (ref) {
    final getToken = ref.watch(pushNotificationGetTokenFpod);

    getToken.whenData((token) {
      _registerToken(ref.read(notificationServicePod), token, ref.read);
    });
  },
  name: 'pushNotificationRegisterTokenPod',
);

/// Must be initialized after [successfull authentication]
final pushNotificationOnTokenRefreshPod = Provider.autoDispose<void>(
  (ref) {
    final onTokenRefresh = ref.watch(pushNotificationOnTokenRefreshSpod);

    onTokenRefresh.whenData((token) {
      _registerToken(ref.read(notificationServicePod), token, ref.read);
    });
  },
  name: 'pushNotificationOnTokenRefreshPod',
);

Future<void> _registerToken(
  NotificationService service,
  String? token,
  Reader read,
) async {
  if (token != null) {
    final context = read(sNavigatorKeyPod).currentContext!;
    final localizations = AppLocalizations.of(context)!;

    final model = RegisterTokenRequestModel(
      token: token,
      locale: localizations.localeName,
    );

    try {
      await service.registerToken(model);
    } catch (e) {
      _logger.log(pushNotifications, 'registerToken Failed', e);
    }
  }
}
