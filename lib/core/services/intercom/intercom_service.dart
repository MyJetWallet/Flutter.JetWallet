import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';

part 'intercom_service.g.dart';

class IntercomService = _IntercomServiceBase with _$IntercomService;

abstract class _IntercomServiceBase with Store {
  final _logger = getIt.get<SimpleLoggerService>();

  static const _appId = String.fromEnvironment('INTERCOM_APP_ID');
  static const _androidKey = String.fromEnvironment('INTERCOM_ANDROID_KEY');
  static const _iOSKey = String.fromEnvironment('INTERCOM_IOS_KEY');

  @action
  Future<void> init() async {
    try {
      await Intercom.instance.initialize(
        _appId,
        iosApiKey: _iOSKey,
        androidApiKey: _androidKey,
      );

      _logger.log(
        level: Level.info,
        place: 'Intercom init',
        message: 'success [_appId: $_appId, _androidKey: $_androidKey, _iOSKey: $_iOSKey]',
      );
    } catch (e) {
      _logger.log(
        level: Level.error,
        place: 'Intercom showMessenger',
        message: '$e [_appId: $_appId, _androidKey: $_androidKey, _iOSKey: $_iOSKey]]',
      );
    }
  }

  @action
  Future<void> login() async {
    try {
      final authInfo = getIt.get<AppStore>().authState;
      await Intercom.instance.loginIdentifiedUser(
        email: authInfo.email,
      );
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

  @action
  Future<void> logout() async {
    try {
      await Intercom.instance.logout();
      _logger.log(
        level: Level.error,
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

  @action
  Future<void> showMessenger() async {
    try {
      await Intercom.instance.displayMessenger();
      _logger.log(
        level: Level.error,
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