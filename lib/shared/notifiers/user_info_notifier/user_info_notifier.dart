import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../logging/levels.dart';
import '../../providers/service_providers.dart';
import '../../services/local_storage_service.dart';
import 'user_info_state.dart';

class UserInfoNotifier extends StateNotifier<UserInfoState> {
  UserInfoNotifier(this.read) : super(const UserInfoState()) {
    storage = read(localStorageServicePod);
  }

  final Reader read;

  static final _logger = Logger('UserInfoNotifier');

  late LocalStorageService storage;

  void updateWithValuesFromSessionInfo({
    required bool twoFaEnabled,
    required bool phoneVerified,
  }) {
    _logger.log(notifier, 'updateWithValuesFromSessionInfo');

    state = state.copyWith(
      twoFaEnabled: twoFaEnabled,
      phoneVerified: phoneVerified,
    );
  }

  /// Inits PIN/Biometrics information
  Future<void> initPinStatus() async {
    _logger.log(notifier, 'initPinStatus');

    final storage = read(localStorageServicePod);
    final pin = await storage.getString(pinStatusKey);

    if (pin == null || pin.isEmpty) {
      _updatePin(null);
    } else {
      _updatePin(pin);
    }

    final pinDisabled = await storage.getString(pinDisabledKey);

    if (pinDisabled == null) {
      _updatePinDisabled(false);
    } else {
      _updatePinDisabled(true);
    }
  }

  Future<void> disablePin() async {
    _logger.log(notifier, 'disablePin');

    await storage.setString(pinDisabledKey, 'disabled');
    _updatePinDisabled(true);
  }

  /// Set PIN/Biometrics information
  Future<void> setPin(String value) async {
    _logger.log(notifier, 'setPin');

    await storage.setString(pinStatusKey, value);
    _updatePin(value);
  }

  /// Reset PIN/Biometrics information
  Future<void> resetPin() async {
    _logger.log(notifier, 'resetPin');

    await storage.setString(pinStatusKey, '');
    _updatePin(null);
  }

  void _updatePin(String? value) {
    state = state.copyWith(pin: value);
  }

  void _updatePinDisabled(bool value) {
    state = state.copyWith(pinDisabled: value);
  }

  void updateTwoFaStatus({required bool enabled}) {
    _logger.log(notifier, 'updateTwoFaStatus');

    state = state.copyWith(twoFaEnabled: enabled);
  }

  void updatePhoneVerified({required bool phoneVerified}) {
    _logger.log(notifier, 'updatePhoneVerified');

    state = state.copyWith(phoneVerified: phoneVerified);
  }

  void clear() {
    state = state.copyWith(
      pin: null,
      phoneVerified: false,
      twoFaEnabled: false,
    );
  }

  void updatePhoneNumber(String phone) {
    _logger.log(notifier, 'updatePhoneNumber');

    state = state.copyWith(phone: phone);
  }
}
