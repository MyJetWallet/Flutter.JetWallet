import 'dart:async';

import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:zendesk_messaging/zendesk_messaging.dart';

class ZenDeskService {
  Future<ZenDeskService> initZenDesk() async {
    try {
      unawaited(ZendeskMessaging.initialize(
        androidChannelKey: zendeskAndroid,
        iosChannelKey: zendeskIOS,
      ));
    } catch (e) {}

    return this;
  }

  Future<void> showZenDesk() async {
    try {
      await ZendeskMessaging.show();
    } catch (e) {}
  }

  Future<void> authZenDesk() async {
    try {
      final authInfo = getIt.get<AppStore>().authState;

      print([
        '${sUserInfo.firstName} ${sUserInfo.lastName}',
        sUserInfo.countryOfResidence,
        authInfo.email,
        sUserInfo.phone,
      ].toList());

      await ZendeskMessaging.setConversationTags([
        '${sUserInfo.firstName} ${sUserInfo.lastName}',
        sUserInfo.countryOfResidence,
        authInfo.email,
        sUserInfo.phone,
      ]);
    } catch (e) {
      print(e);
    }

    await ZendeskMessaging.loginUser(jwt: getIt.get<AppStore>().authState.token);
  }

  Future<void> logoutZenDesk() async {
    try {
      await ZendeskMessaging.clearConversationTags();
    } catch (e) {}
    //await ZendeskMessaging.logoutUser();
  }
}
