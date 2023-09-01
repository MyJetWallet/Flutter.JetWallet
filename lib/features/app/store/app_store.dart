import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/dio_proxy_service.dart';
import 'package:jetwallet/core/services/force_update_service.dart';
import 'package:jetwallet/core/services/local_cache/local_cache_service.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/remote_config/models/remote_config_union.dart';
import 'package:jetwallet/core/services/route_query_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/core/services/startup_service.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/app/init_router/router_union.dart';
import 'package:jetwallet/features/app/store/models/auth_info_state.dart';
import 'package:jetwallet/features/app/store/models/authorization_union.dart';
import 'package:jetwallet/features/app/store/models/authorized_union.dart';
import 'package:jetwallet/features/auth/verification_reg/store/verification_store.dart';
import 'package:jetwallet/features/disclaimer/store/disclaimer_store.dart';
import 'package:jetwallet/features/pin_screen/model/pin_flow_union.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/helpers/country_code_by_user_register.dart';
import '../../phone_verification/ui/phone_verification.dart';

part 'app_store.g.dart';

enum AppStatus { start, inProcess, end }

class AppStore = _AppStoreBase with _$AppStore;

abstract class _AppStoreBase with Store {
  _AppStoreBase() {
    reaction(
      (_) => authStatus,
      (msg) => checkInitRouter(),
    );

    reaction(
      (_) => authorizedStatus,
      (msg) => checkInitRouter(),
    );

    reaction(
      (_) => remoteConfigStatus,
      (msg) => checkInitRouter(),
    );
  }

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
  AppStatus appStatus = AppStatus.start;
  @action
  void setAppStatus(AppStatus status) => appStatus = status;

  @observable
  RouterUnion initRouter = const RouterUnion.loading();
  @action
  void manualUpdateRoute(RouterUnion route) {
    initRouter = route;

    _logger.log(
      level: Level.info,
      place: _loggerValue,
      message: 'INIT ROUTER UPDATED $route',
    );
  }

  @observable
  String env = '';
  @action
  void setEnv(String val) {
    env = val;
  }

  @observable
  bool afterInstall = false;
  @action
  void setAfterInstall(bool val) => afterInstall = val;

  @observable
  bool isBalanceHide = true;

  @observable
  bool showAllAssets = false;

  @observable
  bool isAcceptedGlobalSendTC = false;

  @action
  void setIsBalanceHide(bool value) {
    isBalanceHide = value;

    getIt<LocalCacheService>().saveBalanceHide(value);
  }

  @action
  void setShowAllAssets(bool value) {
    showAllAssets = value;

    getIt<LocalCacheService>().saveHideZeroBalance(value);
  }

  @action
  void setIsAcceptedGlobalSendTC(bool value) {
    isAcceptedGlobalSendTC = value;

    getIt<LocalCacheService>().saveGlobalSendConditions(value);
  }

  @action
  Future<void> pushToUnlogin() async {
    initRouter = const RouterUnion.unauthorized();
  }

  /// Костыль, позже убрать
  var openPinVerification = false;
  var homeOpened = false;
  String lastRoute = '';

  @action
  Future<void> checkInitRouter() async {
    FlutterNativeSplash.remove();

    if (remoteConfigStatus is Success) {
      if (env == 'stage' && !getIt.get<DioProxyService>().proxySkiped) {
        if (!sRouter.isPathActive('/api_selector')) {
          await getIt<AppRouter>().replaceAll([
            const ApiSelectorRouter(),
          ]);
        }

        return;
      }

      if (!skipVersionCheck) {
        if (await getIt<ForceServiceUpdate>().init()) {
          await getIt<ForceServiceUpdate>().init(
            context: getIt.get<AppRouter>().navigatorKey.currentContext,
            showPopup: true,
          );

          return;
        }
      }

      authStatus.when(
        loading: () {},
        authorized: () {
          authorizedStatus.when(
            loading: () {},
            twoFaVerification: () {
              if (lastRoute != 'verification_screen') {
                sAnalytics.signInFlowPhoneNumberView();

                getIt<AppRouter>().replaceAll([
                  SetPhoneNumberRouter(
                    successText: intl.profileDetails_newPhoneNumberConfirmed,
                    fromRegister: true,
                    then: () {
                      getIt.get<StartupService>().secondAction();

                      getIt.get<VerificationStore>().phoneDone();
                    },
                  ),
                ]);
              }

              lastRoute = 'verification_screen';
            },
            phoneVerification: () async {
              if (lastRoute != 'verification_phone_screen') {
                await initSessionInfo();
                final userInfoN = sUserInfo;

                final phoneNumber = countryCodeByUserRegister();
                await getIt<AppRouter>().replaceAll([
                  PhoneVerificationRouter(
                    args: PhoneVerificationArgs(
                      phoneNumber: sUserInfo.phone,
                      activeDialCode: phoneNumber,
                      onVerified: () {
                        userInfoN.updatePhoneVerified(
                          phoneVerifiedValue: true,
                        );
                        userInfoN.updateTwoFaStatus(enabled: true);

                        getIt.get<StartupService>().secondAction();

                        getIt.get<VerificationStore>().phoneDone();
                      },
                    ),
                  ),
                ]);
              }

              lastRoute = 'verification_phone_screen';
            },
            pinSetup: () {
              if (lastRoute != 'pin_screen') {
                if (getIt.get<VerificationStore>().isRefreshPin) {
                  getIt<AppRouter>().replaceAll([
                    PinScreenRoute(
                      union: const Setup(),
                      cannotLeave: true,
                      isForgotPassword: true,
                    ),
                  ]);
                } else {
                  getIt<AppRouter>().replaceAll([
                    PinScreenRoute(
                      union: const Setup(),
                      cannotLeave: true,
                    ),
                  ]);
                }
              }

              lastRoute = 'pin_screen';
            },
            pinVerification: () {
              if (lastRoute != 'pin_screen_verification') {
                if (openPinVerification) return;
                openPinVerification = true;

                if (sRouter.current.path != '/pin_screen') {
                  sAnalytics.signInFlowEnterPinView();
                  getIt<AppRouter>().replaceAll([
                    PinScreenRoute(
                      union: const Verification(),
                      cannotLeave: true,
                      displayHeader: false,
                    ),
                  ]);
                }
              }

              lastRoute = 'pin_screen_verification';
            },
            home: () {
              if (homeOpened) return;
              homeOpened = true;

              initSessionInfo();

              sRouter.replaceAll([
                const HomeRouter(
                  children: [
                    PortfolioRouter(),
                  ],
                ),
              ]);

              Future.delayed(
                const Duration(milliseconds: 150),
                () {
                  if (!getIt<RouteQueryService>().isNavigate) {
                    getIt<RouteQueryService>().runQuery();
                  }
                },
              );
            },
            askBioUsing: () {
              if (lastRoute != 'askBioUsing') {
                getIt<AppRouter>().replaceAll([
                  BiometricRouter(),
                ]);
              }

              lastRoute = 'askBioUsing';
            },
            userDataVerification: () {
              if (lastRoute != 'userDataVerification') {
                sAnalytics.signInFlowPersonalDetailsView();
                getIt<AppRouter>().replaceAll([
                  const UserDataScreenRouter(),
                ]);
              }

              lastRoute = 'userDataVerification';
            },
            singleIn: () {
              if (lastRoute != 'singleIn') {
                getIt<AppRouter>().replaceAll([
                  SingInRouter(),
                ]);
              }

              lastRoute = 'singleIn';
            },
            emailVerification: () {},
          );
        },
        unauthorized: () {
          getIt<AppRouter>().replaceAll([
            const OnboardingRoute(),
          ]);
        },
      );
    }
  }

  /// Variable for storing the Auth user's state. Can be: authorized/unauthorized
  @observable
  AuthorizationUnion authStatus = const AuthorizationUnion.loading();
  @action
  void setAuthStatus(AuthorizationUnion value) {
    authStatus = value;
  }

  @observable
  AuthorizedUnion authorizedStatus = const AuthorizedUnion.loading();
  @action
  void setAuthorizedStatus(AuthorizedUnion value) {
    authorizedStatus = value;
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
          twoFaEnabledValue: info.data!.twoFaEnabled,
          phoneVerifiedValue: info.data!.phoneVerified,
          hasDisclaimersValue: info.data!.hasDisclaimers,
          hasHighYieldDisclaimersValue: info.data!.hasHighYieldDisclaimers,
          hasNftDisclaimersValue: info.data!.hasNftDisclaimers,
          isTechClientValue: info.data!.isTechClient,
        );
      }

      if (userInfo.hasDisclaimers) {
        await getIt<DisclaimerStore>().init();
      }

      if (profileInfo.data != null) {
        userInfo.updateWithValuesFromProfileInfo(
          emailConfirmedValue: profileInfo.data!.emailConfirmed,
          phoneConfirmedValue: profileInfo.data!.phoneConfirmed,
          kycPassedValue: profileInfo.data!.kycPassed,
          cardAvailableValue: profileInfo.data!.cardAvailable,
          cardRequestedValue: profileInfo.data!.cardRequested,
          emailValue: profileInfo.data!.email ?? '',
          phoneValue: profileInfo.data!.phone ?? '',
          referralLinkValue: profileInfo.data!.referralLink ?? '',
          referralCodeValue: profileInfo.data!.referralCode ?? '',
          countryOfRegistrationValue:
              profileInfo.data!.countryOfRegistration ?? '',
          countryOfResidenceValue: profileInfo.data!.countryOfResidence ?? '',
          countryOfCitizenshipValue:
              profileInfo.data!.countryOfCitizenship ?? '',
          firstNameValue: profileInfo.data!.firstName ?? '',
          lastNameValue: profileInfo.data!.lastName ?? '',
        );
      }

      sAnalytics.updateTechAccValue(
        userInfo.isTechClient,
      );

      authState = authState.copyWith(
        initSessionReceived: true,
      );
    }
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
    appStatus = AppStatus.start;

    openPinVerification = false;
    homeOpened = false;

    lastRoute = '';
  }
}
