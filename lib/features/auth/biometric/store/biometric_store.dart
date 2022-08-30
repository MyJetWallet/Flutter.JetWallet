import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/startup_service.dart';
import 'package:jetwallet/utils/logging.dart';
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

  void useBio({required bool useBio}) {
    _logger.log(notifier, useBio);

    final storageService = sLocalStorageService;

    storageService.setString(useBioKey, useBio.toString());

    getIt.get<StartupService>().pinVerified();
  }
}
