import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/session_check_service.dart';
import 'package:logger/logger.dart';

class IntercomService {
  final _logger = getIt.get<SimpleLoggerService>();

  bool _isInited = false;

  Future<IntercomService> init() async {
    try {
      await Intercom.instance.initialize(
        'lci42mfw',
        iosApiKey: 'android_sdk-684bae5a9d75b05e583aeb048fbfa1be7774247c',
        androidApiKey: 'ios_sdk-798dd512c506503fc2da6c81797ac8428e0eb419',
      );

      _isInited = true;

      sRouter.addListener(() {
        if (sRouter.stack.any((rout) => rout.name == 'HomeRouter')) {
          Intercom.instance.setInAppMessagesVisibility(IntercomVisibility.visible);
        } else {
          Intercom.instance.setInAppMessagesVisibility(IntercomVisibility.gone);
        }
      });

      _logger.log(
        level: Level.info,
        place: 'Intercom init',
        message: 'success',
      );
    } catch (e) {
      _logger.log(
        level: Level.error,
        place: 'Intercom showMessenger',
        message: '$e',
      );
    }
    return this;
  }

  Future<void> initPushNotif() async {
    final firebaseMessaging = FirebaseMessaging.instance;
    final intercomToken = Platform.isIOS ? await firebaseMessaging.getAPNSToken() : await firebaseMessaging.getToken();

    if (intercomToken != null) {
      unawaited(Intercom.instance.sendTokenToIntercom(intercomToken));
    }
  }

  Future<void> login() async {
    try {
      if (!_isInited) {
        await init();
      }

      final info = getIt.get<SessionCheckService>().data;
      final userId = info?.trackId;

      if (userId != null) {
        await Intercom.instance.loginIdentifiedUser(
          userId: userId,
        );
      } else {
        await Intercom.instance.loginUnidentifiedUser();
      }

      await initPushNotif();

      _logger.log(
        level: Level.info,
        place: 'Intercom login',
        message: 'success',
      );
    } catch (e) {
      _logger.log(
        level: Level.error,
        place: 'Intercom login',
        message: e.toString(),
      );
    }
  }

  Future<void> logout() async {
    try {
      await Intercom.instance.logout();
      _logger.log(
        level: Level.info,
        place: 'Intercom logout',
        message: 'success',
      );
    } catch (e) {
      _logger.log(
        level: Level.error,
        place: 'Intercom logout',
        message: e.toString(),
      );
    }
  }

  bool messangerJustOpened = false;

  Future<void> showMessenger() async {
    try {
      if (messangerJustOpened) return;
      messangerJustOpened = true;
      unawaited(
        Future.delayed(
          const Duration(seconds: 2),
          () {
            messangerJustOpened = false;
          },
        ),
      );

      await Intercom.instance.displayMessenger();
      _logger.log(
        level: Level.info,
        place: 'Intercom showMessenger',
        message: 'success',
      );
    } catch (e) {
      _logger.log(
        level: Level.error,
        place: 'Intercom showMessenger',
        message: e.toString(),
      );
    }
  }
}
