import 'dart:async';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:data_channel/data_channel.dart';
import 'package:flutter/foundation.dart';
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
import 'package:jetwallet/core/services/remote_config/models/remote_config_union.dart' as rcu;
import 'package:jetwallet/core/services/remote_config/remote_config.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
// import 'package:jetwallet/core/services/sentry_service.dart';
import 'package:jetwallet/core/services/session_check_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/core/services/splash_error/splash_error_service.dart';
import 'package:jetwallet/core/services/sumsub_service/sumsub_service.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/app/store/models/authorization_union.dart';
import 'package:jetwallet/features/app/store/models/authorized_union.dart';
import 'package:jetwallet/features/auth/verification_reg/store/verification_store.dart';
import 'package:jetwallet/features/iban/store/iban_store.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/pin_screen/model/pin_flow_union.dart';
import 'package:jetwallet/utils/helpers/check_kyc_status.dart';
import 'package:jetwallet/utils/helpers/firebase_analytics.dart';
import 'package:logger/logger.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_networking/helpers/models/refresh_token_status.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/analytic_records/models/analytic_record.dart';
import 'package:simple_networking/modules/analytic_records/models/analytic_record_response.dart';
import 'package:simple_networking/modules/auth_api/models/install_model.dart';
import 'package:simple_networking/modules/auth_api/models/session_chek/session_check_response_model.dart';
import 'package:simple_networking/modules/logs_api/models/add_log_model.dart';
import 'package:simple_sift/sift.dart';
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

    LocalStorageService storageService;

    ///
    /// SplashErrorException - 1
    ///
    try {
      storageService = getIt.get<LocalStorageService>();
    } catch (e, stackTrace) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: '[StartupService]',
            message: 'Error: $e, $stackTrace',
          );
      // // getIt.get<SentryService>().captureException(e, stackTrace);
      throw SplashErrorException(1, e, stackTrace);
    }

    try {
      token = await storageService.getValue(refreshTokenKey);
      email = await storageService.getValue(userEmailKey);
      parsedEmail = email ?? '<${intl.appInitFpod_emailNotFound}>';
    } catch (e, stackTrace) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: '[StartupService]',
            message: 'Error: $e, $stackTrace',
          );
      token = null;
      email = null;
      parsedEmail = '<${intl.appInitFpod_emailNotFound}>';
    }

    ///
    /// SplashErrorException - 22
    ///
    if (getIt.get<SplashErrorService>().isNetworkError) {
      getIt.get<SplashErrorService>().isNetworkError = false;
      throw SplashErrorException(22, 'network error');
    }

    ///
    /// SplashErrorException - 21
    ///
    if (getIt.get<AppStore>().remoteConfigStatus is rcu.Error) {
      throw SplashErrorException(21);
    }

    await getAdvData();

    ///
    /// SplashErrorException - 4
    ///
    unawaited(launchSift());

    ///
    /// SplashErrorException - 5
    ///
    unawaited(initAppFBAnalytic());

    ///
    /// SplashErrorException - 6
    ///
    unawaited(initAppsFlyer());

    ///
    /// SplashErrorException - 7
    ///
    try {
      getIt<AppStore>().setAppStatus(AppStatus.start);
      getIt<AppStore>().generateNewSessionID();
    } catch (e, stackTrace) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: '[StartupService]',
            message: 'Error: $e, $stackTrace',
          );
      // getIt.get<SentryService>().captureException(e, stackTrace);
      throw SplashErrorException(7, e, stackTrace);
    }

    ///
    /// SplashErrorException - 8
    ///
    bool authStatus;
    try {
      authStatus = await checkIsUserAuthorized(token);
    } catch (e, stackTrace) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: '[StartupService]',
            message: 'Error: $e, $stackTrace',
          );
      // getIt.get<SentryService>().captureException(e, stackTrace);
      throw SplashErrorException(8, e, stackTrace);
    }

    ///
    /// SplashErrorException - 9
    ///
    try {
      await getIt.get<SNetwork>().init(getIt<AppStore>().sessionID);
    } catch (e, stackTrace) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: '[StartupService]',
            message: 'Error: $e, $stackTrace',
          );
      // getIt.get<SentryService>().captureException(e, stackTrace);
      throw SplashErrorException(9, e, stackTrace);
    }

    ///
    /// SplashErrorException - 11
    ///
    try {
      if (getIt<AppStore>().afterInstall) {
        unawaited(saveInstallID());
      }
    } catch (e, stackTrace) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: '[StartupService]',
            message: 'Error: $e, $stackTrace',
          );
      // getIt.get<SentryService>().captureException(e, stackTrace);
      throw SplashErrorException(11, e, stackTrace);
    }

    ///
    /// SplashErrorException - 10
    ///
    try {
      if (!getIt.isRegistered<ProfileGetUserCountry>()) {
        getIt.registerSingletonAsync<ProfileGetUserCountry>(() => ProfileGetUserCountry().init());
      } else {
        await getIt.get<ProfileGetUserCountry>().init();
      }

      await getIt.isReady<ProfileGetUserCountry>();

      final useAmplitude =
          amplitudeAllowCountryList.contains(getIt.get<ProfileGetUserCountry>().profileUserCountry.countryCode);

      var allowedSendEventsToAmplitude = false;
      if (useAmplitude) {
        allowedSendEventsToAmplitude = await RemoteConfig().getRemoteConfigAnalyticFromServer();
      }

      await sAnalytics.init(
        environmentKey: analyticsApiKey,
        techAcc: userInfo.isTechClient,
        // this function is necessary to send events for analytics
        // from the plugins/simple_analytics package to our back end
        logEventFunc: ({
          required String name,
          required Map<String, dynamic> body,
          required int orderIndex,
          required bool amp,
        }) async {
          final model = AnalyticRecordModel(
            eventName: name,
            eventBody: body,
            orderIndex: orderIndex,
            amp: amp,
          );
          try {
            DC<ServerRejectException, AnalyticRecordResponseModel> result;
            if (authStatus) {
              result =
                  await getIt.get<SNetwork>().simpleNetworking.getAnalyticApiModule().postAddAnalyticRecord([model]);
            } else {
              result = await getIt
                  .get<SNetwork>()
                  .simpleNetworkingUnathorized
                  .getAnalyticApiModule()
                  .postAddAnalyticRecord([model]);
            }
            if (result.data == null) {
              return true;
            } else {
              return result.data!.limitExceeded;
            }
          } catch (e) {
            return true;
          }
        },
        userEmail: parsedEmail,
        useAmplitude: useAmplitude,
        allowedSendEventsToAmplitude: allowedSendEventsToAmplitude,
      );
    } catch (e, stackTrace) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: '[StartupService]',
            message: 'Error: $e, $stackTrace',
          );
      // getIt.get<SentryService>().captureException(e, stackTrace);
      throw SplashErrorException(10, e, stackTrace);
    }

    if (authStatus) {
      ///
      /// SplashErrorException - 12
      ///
      try {
        getIt<AppStore>().updateAuthState(
          refreshToken: token,
          email: parsedEmail,
        );
      } catch (e, stackTrace) {
        getIt.get<SimpleLoggerService>().log(
              level: Level.error,
              place: '[StartupService]',
              message: 'Error: $e, $stackTrace',
            );
        // getIt.get<SentryService>().captureException(e, stackTrace);
        throw SplashErrorException(12, e, stackTrace);
      }

      try {
        ///
        /// SplashErrorException - 13
        ///
        try {
          final resultRefreshToken = await refreshToken(updateSignalR: false);

          if (resultRefreshToken == RefreshTokenStatus.success) {
            await userInfo.initPinStatus();
          }
        } catch (e, stackTrace) {
          getIt.get<SimpleLoggerService>().log(
                level: Level.error,
                place: '[StartupService]',
                message: 'Error: $e, $stackTrace',
              );
          throw SplashErrorException(13, e, stackTrace);
        }

        await secondAction();
      } catch (e, stackTrace) {
        getIt.get<SimpleLoggerService>().log(
              level: Level.error,
              place: '[StartupService]',
              message: 'Error: $e, $stackTrace',
            );
        getIt.get<SimpleLoggerService>().log(
              level: Level.error,
              place: 'StartupService',
              message: '$e',
            );
        rethrow;
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

    ///
    /// SplashErrorException - 14
    ///
    try {
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
    } catch (e, stackTrace) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: '[StartupService]',
            message: 'Error: $e, $stackTrace',
          );
      // getIt.get<SentryService>().captureException(e, stackTrace);
      throw SplashErrorException(14, e, stackTrace);
    }

    ///
    /// SplashErrorException - 15
    ///
    try {
      if (!userInfo.isServicesRegisterd) {
        await startingServices();
      } else {
        await reCreateServices();
      }
    } catch (e, stackTrace) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: '[StartupService]',
            message: 'Error: $e, $stackTrace',
          );
      // getIt.get<SentryService>().captureException(e, stackTrace);
      throw SplashErrorException(15, e, stackTrace);
    }

    ///
    /// SplashErrorException - 16
    ///
    try {
      getIt<AppStore>().setIsBalanceHide(
        await getIt<LocalCacheService>().getBalanceHide() ?? false,
      );
      getIt<AppStore>().setShowAllAssets(
        await getIt<LocalCacheService>().getHideZeroBalance() ?? false,
      );
      getIt<AppStore>().setIsAcceptedGlobalSendTC(
        await getIt<LocalCacheService>().getGlobalSendConditions() ?? false,
      );
    } catch (e, stackTrace) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: '[StartupService]',
            message: 'Error: $e, $stackTrace',
          );
      // getIt.get<SentryService>().captureException(e, stackTrace);
      throw SplashErrorException(16, e, stackTrace);
    }

    // Запускаем SignlaR
    ///
    /// SplashErrorException - 17
    ///
    try {
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
    } catch (e, stackTrace) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: '[StartupService]',
            message: 'Error: $e, $stackTrace',
          );
      throw SplashErrorException(17, e, stackTrace);
    }

    ///
    /// SplashErrorException - 18
    ///
    try {
      unawaited(getIt.get<PushNotification>().registerToken());
    } catch (e, stackTrace) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: '[StartupService]',
            message: 'Error: $e, $stackTrace',
          );
      // getIt.get<SentryService>().captureException(e, stackTrace);
      throw SplashErrorException(18, e, stackTrace);
    }

    await makeSessionCheck();

    ///
    /// SplashErrorException - 20
    ///
    try {
      final kyc = getIt.get<KycService>();

      var analyticsKyc = 0;
      if (checkKycPassed(
        kyc.depositStatus,
        kyc.tradeStatus,
        kyc.withdrawalStatus,
      )) {
        analyticsKyc = 2;
      }
      if (kycInProgress(
        kyc.depositStatus,
        kyc.tradeStatus,
        kyc.withdrawalStatus,
      )) {
        analyticsKyc = 1;
      }
      if (checkKycBlocked(
        kyc.depositStatus,
        kyc.tradeStatus,
        kyc.withdrawalStatus,
      )) {
        analyticsKyc = 4;
      }
      sAnalytics.setKYCDepositStatus = analyticsKyc;
    } catch (e, stackTrace) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: '[StartupService]',
            message: 'Error: $e, $stackTrace',
          );
      // getIt.get<SentryService>().captureException(e, stackTrace);
      throw SplashErrorException(20, e, stackTrace);
    }

    //await getIt.get<ZenDeskService>().authZenDesk();
  }

  Future<bool> checkIsUserAuthorized(String? token) async {
    if (token == null || token.isEmpty) {
      getIt<AppStore>().setAuthStatus(const AuthorizationUnion.unauthorized());

      return false;
    } else {
      return true;
    }
  }

  SessionCheckResponseModel? sessionInfo;

  Future<void> makeSessionCheck() async {
    final info = await getIt.get<SessionCheckService>().sessionCheck();

    if (info != null) {
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
      sessionInfo = info;
    }

    unawaited(getIt.get<AppStore>().checkInitRouter());
  }

  void successfullAuthentication({bool needPush = true}) {
    TextInput.finishAutofillContext(); // prompt to save credentials00

    getIt.get<AppStore>().setFromLoginRegister(true);

    secondAction();
  }

  Future<void> startingServices() async {
    try {
      if (!getIt.isRegistered<KycService>()) {
        getIt.registerSingleton<KycService>(
          KycService(),
        );
      }

      if (!getIt.isRegistered<InternetCheckerService>()) {
        getIt.registerSingletonAsync<InternetCheckerService>(
          () async => InternetCheckerService().initialise(),
        );
      }

      if (!getIt.isRegistered<KycProfileCountries>()) {
        getIt.registerSingletonAsync<KycProfileCountries>(
          () async => KycProfileCountries().init(),
        );
      }

      if (!getIt.isRegistered<FormatService>()) {
        getIt.registerSingletonAsync<FormatService>(
          () async => FormatService(),
        );
      }

      await getIt.isReady<KycProfileCountries>();
      await getIt.isReady<ProfileGetUserCountry>();

      if (!getIt.isRegistered<IbanStore>()) {
        getIt.registerSingleton<IbanStore>(
          IbanStore(),
        );
      }

      if (!getIt.isRegistered<SumsubService>()) {
        getIt.registerLazySingleton<SumsubService>(
          () => SumsubService(),
        );
      }

      userInfo.updateServicesRegistred(true);

      return;
    } catch (e, stackTrace) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: '[StartupService]',
            message: 'Error: $e, $stackTrace',
          );
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
    } catch (e, stackTrace) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: '[StartupService]',
            message: 'Error: $e, $stackTrace',
          );
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
      final storageService = getIt.get<LocalStorageService>();

      await getIt<LocalCacheService>().saveInstallID(installID);
      final utmSource = await storageService.getValue(utmSourceKey);
      final campaign = await storageService.getValue(campaignKey);
      final mediaSource = await storageService.getValue(mediaSourceKey);

      final packageInfo = getIt.get<PackageInfoService>().info;

      final model = InstallModel(
        installId: installID,
        platform: Platform.isIOS ? 1 : 2,
        deviceUid: getIt.get<DeviceInfo>().deviceUid,
        version: packageInfo.version,
        lang: intl.localeName,
        appsflyerId: '',
        idfa: await AppTrackingTransparency.getAdvertisingIdentifier(),
        idfv: sDeviceInfo.deviceUid,
        adid: '',
        utmSource: utmSource,
        campaign: campaign,
        mediaSource: mediaSource,
      );

      final _ = await getIt.get<SNetwork>().simpleNetworkingUnathorized.getAuthModule().postInstall(
            model,
          );
    } catch (e, stackTrace) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: '[StartupService]',
            message: 'Error: $e, $stackTrace',
          );
      _logger.log(
        level: Level.error,
        place: _loggerValue,
        message: 'Failed to save InstallID: $e',
      );
    }
  }

  ///

  Future<void> initAppFBAnalytic() async {
    try {
      final deviceInfo = getIt.get<DeviceInfo>();
      final storageService = getIt.get<LocalStorageService>();
      await deviceInfo.deviceInfo();

      unawaited(
        checkInitAppFBAnalytics(
          storageService,
          deviceInfo.model,
        ),
      );
    } catch (e, stackTrace) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: '[StartupService]',
            message: 'Error: $e, $stackTrace',
          );
      // getIt.get<SentryService>().captureException(e, stackTrace);
      throw SplashErrorException(5, e, stackTrace);
    }
  }

  Future<void> initAppsFlyer() async {
    try {
      final appsFlyerService = getIt.get<AppsFlyerService>();

      await appsFlyerService.init();
      await appsFlyerService.updateServerUninstallToken();
    } catch (e, stackTrace) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: '[StartupService]',
            message: 'Error: $e, $stackTrace',
          );
      // getIt.get<SentryService>().captureException(e, stackTrace);
      throw SplashErrorException(6, e, stackTrace);
    }
  }

  ///
  void pushHome() {
    getIt.get<AppStore>().setAuthorizedStatus(
          const Home(),
        );
  }

  void pinVerified() {
    final info = getIt.get<SessionCheckService>().data;

    if (info != null) {
      if (info.toCheckSelfie) {
        kDebugMode ? pushHome() : getIt.get<AppStore>().setAuthorizedStatus(const CheckSelfie());
      } else {
        pushHome();
      }
    } else {
      pushHome();
    }

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
            place: 'StartupService processPinState',
            message: e.toString(),
          );
    }
  }
}

Future<void> launchSift() async {
  final logger = getIt.get<SimpleLoggerService>();
  try {
    final siftPlugin = SimpleSift();

    final siftStatus = await siftPlugin.setSiftConfig(
      accountId: siftAccountId,
      beaconKey: siftBeaconKey,
    );

    logger.log(
      level: Level.info,
      place: 'launchSift',
      message: 'Sift: $siftStatus',
    );
  } catch (e, stackTrace) {
    getIt.get<SimpleLoggerService>().log(
          level: Level.error,
          place: '[StartupService]',
          message: 'Error: $e, $stackTrace',
        );
    // getIt.get<SentryService>().captureException(e, stackTrace);
    throw SplashErrorException(4, e, stackTrace);
  }
}

Future<void> getAdvData() async {
  await AppTrackingTransparency.requestTrackingAuthorization();

  final _ = await AppTrackingTransparency.getAdvertisingIdentifier();
}
