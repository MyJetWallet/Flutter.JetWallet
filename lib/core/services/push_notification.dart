import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/app/store/models/authorization_union.dart';
import 'package:logger/logger.dart';
import 'package:simple_networking/modules/wallet_api/models/notification/register_token_request_model.dart';

class PushNotification {
  PushNotification() {
    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      if (getIt.get<AppStore>().authStatus is Authorized) {
        _registerToken(token);
      }
    });
  }

  Future<String?> getToken() async {
    if (!kIsWeb) {
      try {
        return FirebaseMessaging.instance.getToken();
      } catch (e) {
        getIt.get<SimpleLoggerService>().log(
          level: Level.error,
          place: 'PushNotification',
          message: e.toString(),
        );

        return Future.value();
      }
    } else {
      return Future.value();
    }
  }

  Future<void> registerToken() async {
    final gToken = await getToken();

    if (gToken != null) {
      await _registerToken(gToken);
    }
  }

  Future<void> deletePushToken() async {
    try {
      await FirebaseMessaging.instance.deleteToken();
    } catch (e) {
      getIt.get<SimpleLoggerService>().log(
        level: Level.error,
        place: 'PushNotification',
        message: e.toString(),
      );
    }
  }
}

Future<void> _registerToken(
  String? token,
) async {
  if (token != null) {
    final model = RegisterTokenRequestModel(
      token: token,
      locale: intl.localeName,
    );

    try {
      await sNetwork.getWalletModule().postRegisterToken(model);
    } catch (e) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: 'PushNotification',
            message: e.toString(),
          );
    }
  }
}
