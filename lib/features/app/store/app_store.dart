import 'dart:async';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/apps_flyer_service.dart';
import 'package:jetwallet/core/services/device_info/device_info.dart';
import 'package:jetwallet/core/services/dio_proxy_service.dart';
import 'package:jetwallet/core/services/dynamic_link_service.dart';
import 'package:jetwallet/core/services/flavor_service.dart';
import 'package:jetwallet/core/services/force_update_service.dart';
import 'package:jetwallet/core/services/local_cache/local_cache_service.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/logout_service/logout_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/refresh_token_service.dart';
import 'package:jetwallet/core/services/remote_config/models/remote_config_union.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/core/services/startup_service.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/app/init_router/router_union.dart';
import 'package:jetwallet/features/app/store/models/auth_info_state.dart';
import 'package:jetwallet/features/app/store/models/authorization_union.dart';
import 'package:jetwallet/features/app/store/models/authorized_union.dart';
import 'package:jetwallet/features/disclaimer/store/disclaimer_store.dart';
import 'package:jetwallet/features/pin_screen/model/pin_flow_union.dart';
import 'package:jetwallet/features/two_fa_phone/model/two_fa_phone_trigger_union.dart';
import 'package:jetwallet/utils/helpers/firebase_analytics.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_networking/helpers/models/refresh_token_status.dart';
import 'package:simple_networking/modules/logs_api/models/add_log_model.dart';
import 'package:uuid/uuid.dart';
import 'package:logger/logger.dart';

part 'app_store.g.dart';

enum AppStatus { Start, InProcess, End }

class AppStore = _AppStoreBase with _$AppStore;

abstract class _AppStoreBase with Store {
  final _logger = getIt.get<SimpleLoggerService>();
  final _loggerValue = 'AppStore';

  @observable
  String sessionID = '';
  @action
  void generateNewSessionID() {
    const uuid = Uuid();
    sessionID = uuid.v1();
  }

  @observable
  AppStatus appStatus = AppStatus.Start;
  @action
  void setAppStatus(AppStatus status) => appStatus = status;

  @observable
  RouterUnion initRouter = const RouterUnion.loading();
  @action
  void manualUpdateRoute(RouterUnion route) {
    initRouter = route;
  }

  @observable
  String env = '';
  @action
  void setEnv(String val) {
    env = val;
  }

  @observable
  bool isBalanceHide = true;
  @action
  void setIsBalanceHide(bool value) {
    isBalanceHide = value;

    getIt<LocalCacheService>().saveBalanceHide(value);
  }

  @action
  Future<void> pushToUnlogin() async {
    initRouter = const RouterUnion.unauthorized();
  }

  /// Костыль, позже убрать
  var openPinVerification = false;

  @action
  Future<void> checkInitRouter() async {
    FlutterNativeSplash.remove();

    if (remoteConfigStatus is Success) {
      if (env == 'stage' && !getIt.get<DioProxyService>().proxySkiped) {
        if (!sRouter.isPathActive('/api_selector')) {
          //initRouter = const RouterUnion.apiSelector();

          await getIt<AppRouter>().replaceAll([
            const ApiSelectorRouter(),
          ]);
        }

        return;
      }

      if (!skipVersionCheck) {
        if (await getIt<ForceServiceUpdate>().init()) {
          //initRouter = const RouterUnion.appUpdate();

          await getIt<ForceServiceUpdate>().init(
            context: getIt.get<AppRouter>().navigatorKey.currentContext!,
            showPopup: true,
          );

          return;
        }
      }

      authStatus.when(
        loading: () {
          //initRouter = const RouterUnion.loading();
        },
        authorized: () {
          authorizedStatus.when(
            loading: () {
              //initRouter = const RouterUnion.loading();
            },
            twoFaVerification: () {
              //initRouter = const RouterUnion.twoFaVerification();

              getIt<AppRouter>().replaceAll([
                TwoFaPhoneRouter(
                  trigger: TwoFaPhoneTriggerUnion.startup(),
                ),
              ]);
            },
            pinSetup: () {
              //initRouter = const RouterUnion.pinSetup();

              if (sRouter.current.path != '/pin_screen') {
                getIt<AppRouter>().replaceAll([
                  PinScreenRoute(
                    union: Setup(),
                    cannotLeave: true,
                  ),
                ]);
              }
            },
            pinVerification: () {
              //initRouter = const RouterUnion.pinVerification();

              if (openPinVerification) return;
              openPinVerification = true;

              if (sRouter.current.path != '/pin_screen') {
                getIt<AppRouter>().replaceAll([
                  PinScreenRoute(
                    union: Verification(),
                    cannotLeave: true,
                    displayHeader: false,
                  ),
                ]);
              }
            },
            home: () {
              //initRouter = const RouterUnion.home();

              sRouter.replaceAll([
                const HomeRouter(
                  children: [
                    PortfolioRouter(),
                  ],
                ),
              ]);
            },
            askBioUsing: () {
              //initRouter = const RouterUnion.askBioUsing();

              getIt<AppRouter>().replaceAll([
                BiometricRouter(),
              ]);
            },
            userDataVerification: () {
              //initRouter = const RouterUnion.userDataVerification();

              getIt<AppRouter>().replaceAll([
                UserDataScreenRouter(),
              ]);
            },
            singleIn: () {
              //initRouter = const RouterUnion.singleIn();

              getIt<AppRouter>().replaceAll([
                SingInRouter(),
              ]);
            },
            emailVerification: () {},
          );
        },
        unauthorized: () {
          //initRouter = const RouterUnion.unauthorized();

          print('unauthorized');

          getIt<AppRouter>().replaceAll([
            OnboardingRoute(),
          ]);
        },
      );
    } else {
      initRouter = const RouterUnion.loading();
    }
  }

  /// Variable for storing the Auth user's state. Can be: authorized/unauthorized
  @observable
  AuthorizationUnion authStatus = const AuthorizationUnion.loading();
  @action
  void setAuthStatus(AuthorizationUnion value) {
    authStatus = value;

    checkInitRouter();
  }

  @observable
  AuthorizedUnion authorizedStatus = const AuthorizedUnion.loading();
  @action
  void setAuthorizedStatus(AuthorizedUnion value) {
    authorizedStatus = value;

    checkInitRouter();
  }

  @observable
  RemoteConfigUnion remoteConfigStatus = const RemoteConfigUnion.loading();
  @action
  void setRemoteConfigStatus(RemoteConfigUnion value) {
    _logger.log(
      level: Level.info,
      place: _loggerValue,
      message: 'REMOTE CONFIG STATUS: $value',
    );

    remoteConfigStatus = value;

    checkInitRouter();
  }

  @observable
  TabsRouter? tabsRouter;
  @action
  void setTabsRouter(TabsRouter value) => tabsRouter = value;

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
  int homeTab = 0;
  @action
  void setHomeTab(int value) => homeTab = value;

  @observable
  bool skipVersionCheck = false;
  @action
  bool setSkipVersionCheck(bool value) => skipVersionCheck = value;

  @observable
  TabController? marketController;
  @action
  TabController? setMarketController(TabController? value) =>
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
          isTechClient: info.data!.isTechClient,
        );
      }

      if (userInfo.userInfo.hasDisclaimers) {
        await getIt<DisclaimerStore>().init();
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

      sAnalytics.updateTechAccValue(
        userInfo.userInfo.isTechClient,
      );

      authState = authState.copyWith(
        initSessionReceived: true,
      );
    }
  }

  @action
  Future<void> getAuthStatus() async {
    _logger.log(
      level: Level.info,
      place: _loggerValue,
      message: 'User start init App Store - getAuthStatus()',
    );

    final storageService = getIt.get<LocalStorageService>();

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
    await getIt.get<SNetwork>().init(getIt<AppStore>().sessionID);

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

      // TODO
      final appsFlyerService = getIt.get<AppsFlyerService>();

      await appsFlyerService.init();
      await appsFlyerService.updateServerUninstallToken();
    } catch (error, stackTrace) {
      _logger.log(
        level: Level.error,
        place: _loggerValue,
        message: 'appsFlyerService $error $stackTrace',
      );
    }

    unawaited(
      getIt
          .get<SNetwork>()
          .simpleNetworkingUnathorized
          .getLogsApiModule()
          .postAddLog(
            AddLogModel(
              level: 'info',
              message: 'Initialising the application for the user',
              source: 'AppStore',
              process: 'getAuthStatus',
              token: token,
            ),
          ),
    );

    appStatus = AppStatus.Start;
    generateNewSessionID();

    _logger.log(
      level: Level.info,
      place: _loggerValue,
      message: 'User token: $token',
    );

    if (token == null) {
      // TODO
      //await sAnalytics.init(analyticsApiKey);

      authStatus = const AuthorizationUnion.unauthorized();
    } else {
      updateAuthState(
        refreshToken: token,
        email: parsedEmail,
      );

      isBalanceHide = await getIt<LocalCacheService>().getBalanceHide() ?? true;

      unawaited(initSessionInfo());

      try {
        final userInfo = getIt.get<UserInfoService>();

        final result = await refreshToken(updateSignalR: false);

        _logger.log(
          level: Level.info,
          place: _loggerValue,
          message: 'Start update token when init APPSTORE status: $result',
        );

        /// Recreating a dio object with a token
        await getIt.get<SNetwork>().init(sessionID);

        if (result == RefreshTokenStatus.success) {
          await userInfo.initPinStatus();

          await sAnalytics.init(
            analyticsApiKey,
            userInfo.userInfo.isTechClient,
            parsedEmail,
          );

          authStatus = const AuthorizationUnion.authorized();

          await getIt.get<StartupService>().processStartupState();
        } else {
          _logger.log(
            level: Level.error,
            place: _loggerValue,
            message: 'RefreshToken func return error, we cant update our token',
          );

          await sAnalytics.init(
            analyticsApiKey,
            userInfo.userInfo.isTechClient,
          );

          authStatus = const AuthorizationUnion.unauthorized();
        }
      } catch (e) {
        _logger.log(
          level: Level.error,
          place: _loggerValue,
          message: 'Something goes wrong on refreshToken: $e',
        );

        await sAnalytics.init(
          analyticsApiKey,
          false,
        );

        authStatus = const AuthorizationUnion.unauthorized();

        await getIt.get<LogoutService>().logout('APP_STORE, $e');

        sAnalytics.remoteConfigError();
      }
    }

    unawaited(checkInitRouter());
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

  @action
  void resetAppStore() {
    authStatus = const AuthorizationUnion.loading();
    authorizedStatus = const AuthorizedUnion.loading();
    initRouter = const RouterUnion.unauthorized();

    authState = const AuthInfoState();
    actionMenuActive = false;
    openBottomMenu = false;
    fromLoginRegister = false;
    withdrawDynamicLink = false;
    homeTab = 0;
    isBalanceHide = true;
    appStatus = AppStatus.Start;

    openPinVerification = false;
  }
}
