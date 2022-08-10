import 'package:hooks_riverpod/hooks_riverpod.dart';
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

  void useBio({required bool useBio}) {
    _logger.log(notifier, useBio);
    final storageService = read(localStorageServicePod);
    storageService.setString(useBioKey, useBio.toString());
    read(startupNotipod.notifier).authenticatedBoot();
  }
}
