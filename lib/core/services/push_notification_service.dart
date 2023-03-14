import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/deep_link_service.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:logger/logger.dart';

const String _loggerService = 'PushNotificationService';

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

    await FirebaseMessaging.instance.getInitialMessage().then(
      (RemoteMessage? message) {
        getIt.get<SimpleLoggerService>().log(
              level: Level.info,
              place: _loggerService,
              message: 'getInitialMessage() $message',
            );

        if (message != null) {
          getIt.get<DeepLinkService>().handlePushNotificationLink(message);
        }
      },
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen(_onMessage);
    } else {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: _loggerService,
            message: 'User declined or has not accepted permission',
          );
    }
  }

  void _onMessageOpenedApp(RemoteMessage message) {
    getIt.get<DeepLinkService>().handlePushNotificationLink(message);

    getIt.get<SimpleLoggerService>().log(
          level: Level.info,
          place: _loggerService,
          message: 'onMessageOpenedApp: notification: ${message}',
        );

    if (_nullChecked(message)) {
      final notification = message.notification!;

      getIt.get<SimpleLoggerService>().log(
            level: Level.info,
            place: _loggerService,
            message:
                'onMessageOpenedApp: notification title: ${notification.title}',
          );
    } else {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: _loggerService,
            message: '_onMessage \n\n android or notification is null',
          );
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
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: _loggerService,
            message: '_onMessage \n\n android or notification is null',
          );
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

  getIt.get<SimpleLoggerService>().log(
        level: Level.info,
        place: _loggerService,
        message:
            '_messagingBackgroundHandler \n\n A background message just showed up: $message',
      );
}
