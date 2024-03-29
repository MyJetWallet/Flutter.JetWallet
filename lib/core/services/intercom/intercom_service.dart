import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:logger/logger.dart';

class IntercomService {
  final _logger = getIt.get<SimpleLoggerService>();

  static const _appId = String.fromEnvironment('INTERCOM_APP_ID');
  static const _androidKey = String.fromEnvironment('INTERCOM_ANDROID_KEY');
  static const _iOSKey = String.fromEnvironment('INTERCOM_IOS_KEY');

  bool _isInited = false;

  Future<IntercomService> init() async {
    try {
      await Intercom.instance.initialize(
        'lci42mfw',
        iosApiKey: 'ios_sdk-798dd512c506503fc2da6c81797ac8428e0eb419',
        androidApiKey: 'android_sdk-684bae5a9d75b05e583aeb048fbfa1be7774247c',
        // TODO (yaroslav): uncomment it
        // const String.fromEnvironment('INTERCOM_APP_ID'),
        // iosApiKey: const String.fromEnvironment('INTERCOM_ANDROID_KEY'),
        // androidApiKey: const String.fromEnvironment('INTERCOM_IOS_KEY'),
      );

      _isInited = true;

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
    return this;
  }

  Future<void> login() async {
    try {
      if (!_isInited) {
        await init();
      }

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

  Future<void> showMessenger() async {
    try {
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
