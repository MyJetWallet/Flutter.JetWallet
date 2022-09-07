import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/startup_service.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:local_auth/local_auth.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

part 'biometric_store.g.dart';

class BiometricStore extends _BiometricStoreBase with _$BiometricStore {
  BiometricStore() : super();

  static _BiometricStoreBase of(BuildContext context) =>
      Provider.of<BiometricStore>(context, listen: false);
}

abstract class _BiometricStoreBase with Store {
  static final _logger = Logger('BiometricStore');

  void useBio({
    required bool useBio,
    bool isAccSettings = false,
    required BuildContext context,
  }) {
    _logger.log(notifier, useBio);

    final storageService = sLocalStorageService;

    storageService.setString(useBioKey, useBio.toString());

    if (useBio) {
      final auth = LocalAuthentication();

      auth.authenticate(
        localizedReason: 'We need you to confirm your identity',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    }
    if (isAccSettings) {
      Navigator.pop(context);
    } else {
      getIt.get<StartupService>().pinVerified();
    }
  }
}
