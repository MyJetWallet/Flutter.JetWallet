import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../service_providers.dart';
import '../helpers/register_token.dart';
import 'notification_spod.dart';

final notificationInitFpod = FutureProvider.autoDispose<void>((ref) async {
  final notificationService = ref.watch(notificationServicePod);
  final notification = ref.watch(notificationSpod);

  if (!kIsWeb) {
    final token = await FirebaseMessaging.instance.getToken();
    await registerToken(notificationService, token);

    notification.whenData((token) => registerToken(notificationService, token));
  }
});