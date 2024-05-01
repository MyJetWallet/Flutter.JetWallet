import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/startup_service.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/kyc/allow_camera/store/allow_camera_store.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:local_auth/local_auth.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';

import '../../../../core/services/apps_flyer_service.dart';

part 'biometric_store.g.dart';

class BiometricStore extends _BiometricStoreBase with _$BiometricStore {
  BiometricStore() : super();

  static _BiometricStoreBase of(BuildContext context) =>
      Provider.of<BiometricStore>(context, listen: false);
}

abstract class _BiometricStoreBase with Store {
  static final _logger = Logger('BiometricStore');

  @observable
  UserLocation userLocation = UserLocation.app;

  void useBio({
    required bool useBio,
    bool isAccSettings = false,
  }) {
    _logger.log(notifier, useBio);

    final storageService = sLocalStorageService;

    storageService.setString(useBioKey, useBio.toString());

    getIt.get<UserInfoService>().updateBiometric(
          hideBiometric: !useBio,
        );

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
      sRouter.maybePop();
    } else {
      getIt.get<StartupService>().pinVerified();
    }
  }

  Future<void> handleBiometricPermission() async {
    _logger.log(notifier, 'handleBiometricPermission');
    _updateUserLocation(UserLocation.settings);
    final userInfoN = getIt.get<UserInfoService>();
    userInfoN.updateBiometric(hideBiometric: false);
    await openAppSettings();
  }

  Future<void> handleBiometricPermissionAfterSettingsChange(
    BuildContext context,
  ) async {
    _logger.log(notifier, 'handleBiometricPermissionAfterSettingsChange');
    final storageService = sLocalStorageService;

    _updateUserLocation(UserLocation.app);
    Navigator.pop(context);
    await storageService.setString(useBioKey, 'true');
    final userInfoN = getIt.get<UserInfoService>();
    await userInfoN.initBiometricStatus();

    if (userInfoN.isJustLogged) {
      sAnalytics.signInFlowVerificationPassed();
      final appsFlyerService = getIt.get<AppsFlyerService>();
      final userInfo = getIt.get<UserInfoService>();

      final appsFlyerID =
          await appsFlyerService.appsflyerSdk.getAppsFlyerUID() ?? '';
      final bytes = utf8.encode(userInfo.email);
      final hashEmail = sha256.convert(bytes).toString();

      appsFlyerService.appsflyerSdk.setCustomerUserId(hashEmail);
      await appsFlyerService.appsflyerSdk.logEvent('af_registration_finished', {
        'IsTechAcc': '${userInfo.isTechClient}',
        'Customer User iD': hashEmail,
        'Appsflyer ID': appsFlyerID,
      });
    }
  }

  void _updateUserLocation(UserLocation location) {
    userLocation = location;
  }
}
