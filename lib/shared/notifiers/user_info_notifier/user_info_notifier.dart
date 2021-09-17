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
}
