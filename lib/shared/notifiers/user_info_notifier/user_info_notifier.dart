import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../logging/levels.dart';
import '../../providers/service_providers.dart';
import '../../services/local_storage_service.dart';
import 'user_info_state.dart';

class UserInfoNotifier extends StateNotifier<UserInfoState> {
  UserInfoNotifier(this.read) : super(const UserInfoState());

  final Reader read;

  static final _logger = Logger('UserInfoNotifier');

  /// Inits PIN/Biometrics information
  Future<void> initPinStatus() async {
    final storage = read(localStorageServicePod);
    final status = await storage.getString(pinStatusKey);

    if (status == null || status == pinDisabled) {
      _updatePinEnabled(false);
    } else {
      _updatePinEnabled(true);
    }
  }

  /// Updates PIN/Biometrics information
  Future<void> switchPin() async {
    final storage = read(localStorageServicePod);

    if (state.pinEnabled) {
      await storage.setString(pinStatusKey, pinDisabled);
      _updatePinEnabled(false);
    } else {
      await storage.setString(pinStatusKey, pinEnabled);
      _updatePinEnabled(true);
    }
  }

  void _updatePinEnabled(bool value) {
    _logger.log(notifier, 'updatePinEnabled');

    state = state.copyWith(pinEnabled: value);
  }
}
