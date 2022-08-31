import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:logging/logging.dart';

import '../../../../router/notifier/startup_notifier/startup_notipod.dart';
import '../../../../shared/logging/levels.dart';
import '../../../../shared/providers/service_providers.dart';
import '../../../../shared/services/local_storage_service.dart';
import 'biometric_state.dart';

class BiometricNotifier extends StateNotifier<BiometricState> {
  BiometricNotifier(
    this.read,
  ) : super(
          const BiometricState(),
        );

  final Reader read;

  static final _logger = Logger('BiometricNotifier');

  void useBio({
    required bool useBio,
    bool isAccSettings = false,
    required BuildContext context,
  }) {
    _logger.log(notifier, useBio);
    final storageService = read(localStorageServicePod);
    storageService.setString(useBioKey, useBio.toString());
    if (useBio) {
      final auth = LocalAuthentication();
      auth.authenticate(
        localizedReason: 'We need you to confirm your identity',
        stickyAuth: true,
        biometricOnly: true,
      );
    }
    if (isAccSettings) {
      Navigator.pop(context);
    } else {
      read(startupNotipod.notifier).pinVerified();
    }
  }
}
