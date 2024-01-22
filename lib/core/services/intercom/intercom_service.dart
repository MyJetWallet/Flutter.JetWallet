import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:mobx/mobx.dart';

part 'intercom_service.g.dart';

class IntercomService = _IntercomServiceBase with _$IntercomService;

abstract class _IntercomServiceBase with Store {
  @action
  Future<void> init() async {
    const appId = String.fromEnvironment('INTERCOM_APP_ID');
    const androidKey = String.fromEnvironment('INTERCOM_ANDROID_KEY');
    const iOSKey = String.fromEnvironment('INTERCOM_IOS_KEY');

    await Intercom.instance.initialize(appId, iosApiKey: iOSKey, androidApiKey: androidKey);
  }

  @action
  Future<void> login() async {
    final authInfo = getIt.get<AppStore>().authState;
    await Intercom.instance.loginIdentifiedUser(
      email: authInfo.email,
    );
  }

  @action
  Future<void> logout() async {
    await Intercom.instance.logout();
  }

  @action
  Future<void> showMessenger() async {
    await Intercom.instance.displayMessenger();
  }
}
