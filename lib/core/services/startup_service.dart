import 'dart:async';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/services.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/apps_flyer_service.dart';
import 'package:jetwallet/core/services/device_info/device_info.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/internet_checker_service.dart';
import 'package:jetwallet/core/services/kyc_profile_countries.dart';
import 'package:jetwallet/core/services/local_cache/local_cache_service.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/package_info_service.dart';
import 'package:jetwallet/core/services/push_notification.dart';
import 'package:jetwallet/core/services/refresh_token_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/core/services/sumsub_service/sumsub_service.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/app/store/models/authorization_union.dart';
import 'package:jetwallet/features/app/store/models/authorized_union.dart';
import 'package:jetwallet/features/auth/verification_reg/store/verification_store.dart';
import 'package:jetwallet/features/iban/store/iban_store.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/pin_screen/model/pin_flow_union.dart';
import 'package:jetwallet/utils/helpers/firebase_analytics.dart';
import 'package:logger/logger.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_networking/helpers/models/refresh_token_status.dart';
import 'package:simple_networking/modules/auth_api/models/install_model.dart';
import 'package:simple_networking/modules/auth_api/models/session_chek/session_check_response_model.dart';
import 'package:simple_networking/modules/logs_api/models/add_log_model.dart';
import 'package:universal_io/io.dart';
import 'package:uuid/uuid.dart';

class StartupService {
  final _logger = getIt.get<SimpleLoggerService>();
  final _loggerValue = 'StartupService';

  final userInfo = getIt.get<UserInfoService>();

  Future<void> firstAction() async {
    String? token;
    String? email;
    String parsedEmail;

    final storageService = getIt.get<LocalStorageService>();

    try {
      token = await storageService.getValue(refreshTokenKey);
      email = await storageService.getValue(userEmailKey);
      parsedEmail = email ?? '<${intl.appInitFpod_emailNotFound}>';
    } catch (e) {
      token = null;
      email = null;
      parsedEmail = '<${intl.appInitFpod_emailNotFound}>';
    }

    await getAdvData();

    unawaited(initAppFBAnalytic());
    unawaited(initAppsFlyer());

    getIt<AppStore>().setAppStatus(AppStatus.start);
    getIt<AppStore>().generateNewSessionID();

    final authStatus = await checkIsUserAuthorized(token);

    await getIt.get<SNetwork>().init(getIt<AppStore>().sessionID);

    if (getIt<AppStore>().afterInstall) {
      unawaited(saveInstallID());
    }

    if (authStatus) {
      getIt<AppStore>().updateAuthState(
        refreshToken: token,
        email: parsedEmail,
      );

      try {
        final resultRefreshToken = await refreshToken(updateSignalR: false);

        if (resultRefreshToken == RefreshTokenStatus.success) {
          await userInfo.initPinStatus();

          await sAnalytics.init(
            analyticsApiKey,
            userInfo.isTechClient,
            parsedEmail,
          );
        }

        await secondAction();
      } catch (e) {
        getIt.get<SimpleLoggerService>().log(
              level: Level.error,
              place: 'StartupService',
              message: '$e',
            );
      } finally {
        getIt<AppStore>().setAuthStatus(const AuthorizationUnion.authorized());
      }
    }
  }

  Future<void> secondAction() async {
    _logger.log(
      level: Level.info,
      place: _loggerValue,
      message: 'secondAction ${getIt.get<AppStore>().authStatus}',
    );

    if (getIt.get<AppStore>().authStatus is Unauthorized) {
      return;
    }
    final storageService = getIt.get<LocalStorageService>();

    unawaited(
      getIt.get<SNetwork>().simpleNetworkingUnathorized.getLogsApiModule().postAddLog(
            AddLogModel(
              level: 'info',
              message: 'User auth ${getIt.get<AppStore>().authStatus}',
              source: 'Second Action',
              process: 'StartupService',
              token: await storageService.getValue(refreshTokenKey),
            ),
          ),
    );

    if (!userInfo.isServicesRegisterd) {
      await startingServices();
    } else {
      await reCreateServices();
    }

    getIt<AppStore>().setIsBalanceHide(
      await getIt<LocalCacheService>().getBalanceHide() ?? false,
    );
    getIt<AppStore>().setShowAllAssets(
      await getIt<LocalCacheService>().getHideZeroBalance() ?? false,
    );
    getIt<AppStore>().setIsAcceptedGlobalSendTC(
      await getIt<LocalCacheService>().getGlobalSendConditions() ?? false,
    );

    // Запускаем SignlaR
    if (!userInfo.isSignalRInited) {
      await getIt.get<SignalRService>().start();

      userInfo.updateSignalRStatus(true);

      unawaited(
        getIt.get<SNetwork>().simpleNetworkingUnathorized.getLogsApiModule().postAddLog(
              AddLogModel(
                level: 'info',
                message: 'Starting signalr',
                source: 'Second Action',
                process: 'StartupService',
                token: await storageService.getValue(refreshTokenKey),
              ),
            ),
      );
    }

    unawaited(getIt.get<PushNotification>().registerToken());

    await makeSessionCheck();

    final kyc = getIt.get<KycService>();
    sAnalytics.setKYCDepositStatus = kyc.depositStatus;
  }

  Future<bool> checkIsUserAuthorized(String? token) async {
    if (token == null || token.isEmpty) {
      getIt<AppStore>().setAuthStatus(const AuthorizationUnion.unauthorized());

      return false;
    } else {
      return true;
    }
  }

  Future<void> makeSessionCheck() async {
    final infoRequest = await sNetwork.getAuthModule().postSessionCheck();
    infoRequest.pick(
      onData: (SessionCheckResponseModel info) async {
        unawaited(
          getIt.get<SNetwork>().simpleNetworkingUnathorized.getLogsApiModule().postAddLog(
                AddLogModel(
                  level: 'info',
                  message: '$info',
                  source: 'makeSessionCheck',
                  process: 'StartupService',
                  token: await getIt.get<LocalStorageService>().getValue(refreshTokenKey),
                ),
              ),
        );

        // For verification Screen
        if (!info.toSetupPhone) {
          getIt.get<VerificationStore>().phoneDone();
        }
        if (!info.toCheckSimpleKyc) {
          getIt.get<VerificationStore>().personalDetailDone();
        }

        if (info.toSetupPhone) {
          getIt.get<AppStore>().setAuthorizedStatus(
                const TwoFaVerification(),
              );
        } else if (info.toVerifyPhone) {
          getIt.get<AppStore>().setAuthorizedStatus(
                const PhoneVerification(),
              );
        } else if (info.toCheckSimpleKyc) {
          getIt.get<AppStore>().setAuthorizedStatus(
                const UserDataVerification(),
              );
        } else if (info.toSetupPin) {
          if (!userInfo.isJustRegistered) {
            getIt.get<VerificationStore>().setRefreshPin();
          }
          getIt.get<AppStore>().setAuthorizedStatus(
                const PinSetup(),
              );
        } else {
          getIt.get<AppStore>().setAuthorizedStatus(
                const PinVerification(),
              );
        }

        unawaited(getIt.get<AppStore>().checkInitRouter());
      },
      onError: (error) {
        _logger.log(
          level: Level.error,
          place: _loggerValue,
          message: 'Failed to fetch session info: $error',
        );
      },
    );
  }

  void successfullAuthentication({bool needPush = true}) {
    TextInput.finishAutofillContext(); // prompt to save credentials00

    getIt.get<AppStore>().setFromLoginRegister(true);

    secondAction();
  }

  Future<void> startingServices() async {
    try {
      getIt.registerSingleton<KycService>(
        KycService(),
      );

      getIt.registerSingletonAsync<InternetCheckerService>(
        () async => InternetCheckerService().initialise(),
      );

      getIt.registerSingletonAsync<KycProfileCountries>(
        () async => KycProfileCountries().init(),
      );

      getIt.registerSingletonAsync<ProfileGetUserCountry>(
        () async => ProfileGetUserCountry().init(),
      );

      getIt.registerSingletonAsync<FormatService>(
        () async => FormatService(),
      );

      await getIt.isReady<KycProfileCountries>();
      await getIt.isReady<ProfileGetUserCountry>();

      getIt.registerLazySingleton<IbanStore>(
        () => IbanStore(),
      );

      getIt.registerLazySingleton<SumsubService>(
        () => SumsubService(),
      );

      userInfo.updateServicesRegistred(true);

      return;
    } catch (e) {
      _logger.log(
        level: Level.error,
        place: _loggerValue,
        message: 'Failed to start Init Services: $e',
      );
    }
  }

  Future<void> reCreateServices() async {
    try {
      if (getIt.isRegistered<KycService>()) {}

      if (getIt.isRegistered<KycProfileCountries>()) {
        await getIt<KycProfileCountries>().init();
      }

      if (getIt.isRegistered<ProfileGetUserCountry>()) {
        await getIt<ProfileGetUserCountry>().init();
      }
    } catch (e) {
      _logger.log(
        level: Level.error,
        place: _loggerValue,
        message: 'Failed to restart Init Services: $e',
      );
    }
  }

  Future<void> saveInstallID() async {
    try {
      const uuid = Uuid();

      final installID = uuid.v1();

      await getIt<LocalCacheService>().saveInstallID(installID);

      final packageInfo = getIt.get<PackageInfoService>().info;

      final model = InstallModel(
        installId: installID,
        platform: Platform.isIOS ? 1 : 2,
        deviceUid: getIt.get<DeviceInfo>().deviceUid,
        version: packageInfo.version,
        lang: intl.localeName,
        appsflyerId: await getIt.get<AppsFlyerService>().appsflyerSdk.getAppsFlyerUID() ?? '',
        idfa: await AppTrackingTransparency.getAdvertisingIdentifier(),
        idfv: sDeviceInfo.deviceUid,
        adid: '',
      );

      final _ = await getIt.get<SNetwork>().simpleNetworkingUnathorized.getAuthModule().postInstall(
            model,
          );
    } catch (e) {
      _logger.log(
        level: Level.error,
        place: _loggerValue,
        message: 'Failed to save InstallID: $e',
      );
    }
  }

  ///

  Future<void> initAppFBAnalytic() async {
    final deviceInfo = getIt.get<DeviceInfo>();
    final storageService = getIt.get<LocalStorageService>();
    await deviceInfo.deviceInfo();

    unawaited(
      checkInitAppFBAnalytics(
        storageService,
        deviceInfo.model,
      ),
    );
  }

  Future<void> initAppsFlyer() async {
    final appsFlyerService = getIt.get<AppsFlyerService>();

    await appsFlyerService.init();
    await appsFlyerService.updateServerUninstallToken();
  }

  ///
  void pinVerified() {
    getIt.get<AppStore>().setAuthorizedStatus(
          const Home(),
        );

    getIt.get<AppStore>().checkInitRouter();
  }

  void processPinState() {
    try {
      final userInfo = getIt.get<UserInfoService>();

      if (userInfo.pinEnabled) {
        getIt.get<AppStore>().setAuthorizedStatus(
              const PinVerification(),
            );

        sRouter.push(
          PinScreenRoute(
            union: const PinFlowUnion.verification(),
            cannotLeave: true,
            displayHeader: false,
          ),
        );
      } else {
        getIt.get<AppStore>().setAuthorizedStatus(
              const PinSetup(),
            );

        sRouter.push(
          PinScreenRoute(
            union: const PinFlowUnion.setup(),
            cannotLeave: true,
          ),
        );
      }
    } catch (e) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: 'StartupService',
            message: e.toString(),
          );
    }
  }
}

Future<void> getAdvData() async {
  try {
    await AppTrackingTransparency.requestTrackingAuthorization();
  } catch (e) {
    getIt.get<SimpleLoggerService>().log(
          level: Level.error,
          place: 'StartupService',
          message: e.toString(),
        );
  }

  final _ = await AppTrackingTransparency.getAdvertisingIdentifier();
}
