import 'package:jetwallet/core/router/app_router.dart';
import 'package:simple_kit/modules/notifications/simple_notification_service.dart';

final sNotification = SNotificationNotifier(
  sRouter.navigatorKey.currentContext!,
);
