import 'dart:async';

import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:zendesk_messaging/zendesk_messaging.dart';

class ZenDeskService {
  Future<ZenDeskService> initZenDesk() async {
    unawaited(ZendeskMessaging.initialize(
      androidChannelKey: zendeskAndroid,
      iosChannelKey: zendeskIOS,
    ));

    return this;
  }

  Future<void> showZenDesk() async {
    await ZendeskMessaging.show();
  }

  Future<void> authZenDesk() async {
    await ZendeskMessaging.loginUser(jwt: getIt.get<AppStore>().authState.token);
  }

  Future<void> logoutZenDesk() async {
    await ZendeskMessaging.logoutUser();
  }
}
