import 'dart:async';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/apps_flyer_service.dart';
import 'package:jetwallet/core/services/device_info/device_info.dart';
import 'package:jetwallet/core/services/dynamic_link_service.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/logout_service/logout_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/refresh_token_service.dart';
import 'package:jetwallet/core/services/remote_config/models/remote_config_union.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/core/services/startup_service.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/app/store/models/auth_info_state.dart';
import 'package:jetwallet/features/app/store/models/authorization_union.dart';
import 'package:jetwallet/features/app/store/models/authorized_union.dart';
import 'package:jetwallet/utils/helpers/firebase_analytics.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_networking/helpers/models/refresh_token_status.dart';

part 'app_store.g.dart';

@lazySingleton
class AppStore = _AppStoreBase with _$AppStore;

abstract class _AppStoreBase with Store {
  static final _logger = Logger('AppStore');

  /// Variable for storing the Auth user's state. Can be: authorized/unauthorized
  @observable
  AuthorizationUnion authStatus = const AuthorizationUnion.loading();
  @action
  AuthorizationUnion setAuthStatus(AuthorizationUnion value) =>
      authStatus = value;

  @observable
  AuthorizedUnion authorizedStatus = const AuthorizedUnion.loading();
  @action
  void setAuthorizedStatus(AuthorizedUnion value) {
    print('setAuthorizedStatus $value');

    authorizedStatus = value;
  }

  @observable
  RemoteConfigUnion remoteConfigStatus = const RemoteConfigUnion.loading();
  @action
  void setRemoteConfigStatus(RemoteConfigUnion value) {
    _logger.log(stateFlow, 'REMOTE CONFIG STATUS: $value');

    remoteConfigStatus = value;
  }

  @observable
  AuthInfoState authState = const AuthInfoState();

  @observable
  bool actionMenuActive = false;
  @action
  bool setActionMenuActive(bool value) => actionMenuActive = value;

  @observable
  bool openBottomMenu = false;
  @action
  bool setOpenBottomMenu(bool value) => openBottomMenu = value;

  /// Means that at the startup of the app user login or register manually
  @observable
  bool fromLoginRegister = false;
  @action
  bool setFromLoginRegister(bool value) => fromLoginRegister = value;

  /// If current withdraw session was opened from dynamicLink return true
  @observable
  bool withdrawDynamicLink = false;
  @action
  bool setWithdrawDynamicLink(bool value) => withdrawDynamicLink = value;

  @observable
  int marketTab = 1;
  @action
  int setMarketTab(int value) => marketTab = value;

  @observable
  TabController? marketController;
  @action
  TabController setMarketController(TabController value) =>
      marketController = value;

  @action
  Future<void> initSessionInfo() async {
    if (!authState.initSessionReceived) {
      final userInfo = getIt.get<UserInfoService>();
      final info = await sNetwork.getWalletModule().getSessionInfo();
      final profileInfo = await sNetwork.getWalletModule().getProfileInfo();
      if (info.data != null) {
        userInfo.updateWithValuesFromSessionInfo(
          twoFaEnabled: info.data!.twoFaEnabled,
          phoneVerified: info.data!.phoneVerified,
          hasDisclaimers: info.data!.hasDisclaimers,
          hasHighYieldDisclaimers: info.data!.hasHighYieldDisclaimers,
          hasNftDisclaimers: info.data!.hasNftDisclaimers,
        );
      }
      if (profileInfo.data != null) {
        userInfo.updateWithValuesFromProfileInfo(
          emailConfirmed: profileInfo.data!.emailConfirmed,
          phoneConfirmed: profileInfo.data!.phoneConfirmed,
          kycPassed: profileInfo.data!.kycPassed,
          email: profileInfo.data!.email ?? '',
          phone: profileInfo.data!.phone ?? '',
          referralLink: profileInfo.data!.referralLink ?? '',
          referralCode: profileInfo.data!.referralCode ?? '',
          countryOfRegistration: profileInfo.data!.countryOfRegistration ?? '',
          countryOfResidence: profileInfo.data!.countryOfResidence ?? '',
          countryOfCitizenship: profileInfo.data!.countryOfCitizenship ?? '',
          firstName: profileInfo.data!.firstName ?? '',
          lastName: profileInfo.data!.lastName ?? '',
        );
      }
      authState = authState.copyWith(
        initSessionReceived: true,
      );
    }
  }

  @action
  Future<void> getAuthStatus() async {
    print('START: APP STORE - getAuthStatus');

    _logger.log(stateFlow, 'START: APP STORE - getAuthStatus');

    final storageService = getIt.get<LocalStorageService>();

    // TODO
    final appsFlyerService = getIt.get<AppsFlyerService>();

    String? token;
    String? email;
    String parsedEmail;

    try {
      token = await storageService.getValue(refreshTokenKey);
      email = await storageService.getValue(userEmailKey);
      parsedEmail = email ?? '<${intl.appInitFpod_emailNotFound}>';
    } catch (e) {
      token = null;
      email = null;
      parsedEmail = '<${intl.appInitFpod_emailNotFound}>';
    }

    /// Init out API client
    await getIt.get<SNetwork>().init();

    try {
      final deviceInfo = getIt.get<DeviceInfo>();

      await AppTrackingTransparency.requestTrackingAuthorization();

      await deviceInfo.deviceInfo();

      unawaited(
        checkInitAppFBAnalytics(
          storageService,
          deviceInfo.model,
        ),
      );

      await appsFlyerService.init();
      await appsFlyerService.updateServerUninstallToken();
    } catch (error, stackTrace) {
      Logger.root.log(Level.SEVERE, 'appsFlyerService', error, stackTrace);

      _logger.log(stateFlow, 'appsFlyerService');
    }

    if (token == null) {
      _logger.log(stateFlow, 'TOKEN NULL');

      // TODO
      //await sAnalytics.init(analyticsApiKey);

      authStatus = const AuthorizationUnion.unauthorized();
    } else {
      _logger.log(stateFlow, 'TOKEN NOT NULL');

      updateAuthState(
        refreshToken: token,
        email: parsedEmail,
      );

      try {
        final userInfo = getIt.get<UserInfoService>();

        final result = await refreshToken();

        _logger.log(stateFlow, 'REFRESH RESULT: $result');

        /// Recreating a dio object with a token
        await getIt.get<SNetwork>().recreateDio();

        if (result == RefreshTokenStatus.success) {
          await userInfo.initPinStatus();

          await sAnalytics.init(analyticsApiKey, parsedEmail);

          authStatus = const AuthorizationUnion.authorized();

          await getIt.get<StartupService>().processStartupState();
        } else {
          _logger.log(stateFlow, 'TOKEN CANT UPDATE');

          await sAnalytics.init(analyticsApiKey);

          authStatus = const AuthorizationUnion.unauthorized();

          await getIt.get<LogoutService>().logout();
        }
      } catch (e) {
        _logger.log(stateFlow, 'TOKEN CANT UPDATE 2', e);

        await sAnalytics.init(analyticsApiKey);

        authStatus = const AuthorizationUnion.unauthorized();

        await getIt.get<LogoutService>().logout();

        sAnalytics.remoteConfigError();
      }
    }

    await getIt.get<AppRouter>().push(
          const HomeRouter(),
        );
  }

  @action
  void updateAuthState({
    String? token,
    String? refreshToken,
    String? email,
    String? deleteToken,
  }) {
    authState = authState.copyWith(
      token: token ?? authState.token,
      refreshToken: refreshToken ?? authState.refreshToken,
      email: email ?? authState.email,
      deleteToken: deleteToken ?? authState.deleteToken,
    );
  }

  @action
  void clearInitSessionReceived() {
    authState = authState.copyWith(initSessionReceived: false);
  }

  /// Whether to show ResendButton in EmailVerification Screen at first open
  @action
  void updateResendButton() {
    authState = authState.copyWith(
      showResendButton: !authState.showResendButton,
    );
  }

  /// Resets ResendButton state to the default one
  @action
  void resetResendButton() {
    authState = authState.copyWith(showResendButton: true);
  }

  @action
  void updateVerificationToken(String verificationToken) {
    authState = authState.copyWith(
      verificationToken: verificationToken,
    );
  }
}
