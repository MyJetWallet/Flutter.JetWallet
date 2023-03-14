import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/deep_link_service.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';

final _logger = Logger('');

@injectable
class PushNotificationService {
  final _plugin = FlutterLocalNotificationsPlugin();
  final _messaging = FirebaseMessaging.instance;

  static const _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  final _notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: _channel.description,
      icon: '@drawable/ic_notification',
    ),
  );

  Future<void> initialize() async {
    await _resolvePlatformImplementation();

    final settings = await _messaging.requestPermission();

    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    FirebaseMessaging.onBackgroundMessage(_messagingBackgroundHandler);

    await _setForegroundNotification();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen(_onMessage);
    } else {
      _logger.log(
        pushNotifications,
        'User declined or has not accepted permission',
      );
    }
  }

  void _onMessageOpenedApp(RemoteMessage message) {
    getIt.get<DeepLinkService>().handlePushNotificationLink(message);

    if (_nullChecked(message)) {
      final notification = message.notification!;

      _logger.log(
        pushNotifications,
        'onMessageOpenedApp: notification title: ${notification.title}',
      );
    } else {
      _logger.log(pushNotifications, 'android or notification is null');
    }
  }

  void _onMessage(RemoteMessage message) {
    if (_nullChecked(message)) {
      final notification = message.notification!;

      _plugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        _notificationDetails,
      );
    } else {
      _logger.log(pushNotifications, 'android or notification is null');
    }
  }

  bool _nullChecked(RemoteMessage message) {
    final notification = message.notification;
    final android = message.notification?.android;

    return notification != null && android != null;
  }

  Future<void> _resolvePlatformImplementation() async {
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(_channel);
  }

  Future<void> _setForegroundNotification() async {
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}

/// background message handler must be a top-level function
/// (e.g. not a class method which requires initialization)
Future<void> _messagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  await getIt.get<DeepLinkService>().handlePushNotificationLink(message);

  _logger.log(
    pushNotifications,
    'A background message just showed up: ${message.messageId}',
  );
}
