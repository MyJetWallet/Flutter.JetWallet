import 'dart:developer';

import '../../../../service/services/notification/model/register_token_request_model.dart';
import '../../../../service/services/notification/service/notification_service.dart';

Future<void> registerToken(
  NotificationService notificationService,
  String? token,
) async {
  if (token != null) {
    final model = RegisterTokenRequestModel(token: token, locale: 'en');
    try {
      await notificationService.registerToken(model);
    } catch (e) {
      log(e.toString());
    }
  }
}
