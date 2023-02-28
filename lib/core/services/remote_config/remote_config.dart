import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/apps_flyer_service.dart';
import 'package:jetwallet/core/services/flavor_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/remote_config/models/remote_config_union.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_networking/config/options.dart';
import 'package:simple_networking/modules/remote_config/models/remote_config_model.dart';
import 'package:simple_networking/simple_networking.dart';

import '../local_cache/local_cache_service.dart';
import '../local_storage_service.dart';

const _retryTime = 10; // in seconds
const _defaultFlavorIndex = 0;

/// [RemoteConfigService] is a Signleton
class RemoteConfig {
  static final _logger = Logger('RemoteConfigStore');

  Timer? _timer;
  late Timer _durationTimer;
  late int retryTime;
  final stopwatch = Stopwatch();
  bool isStopwatchStarted = false;

  RemoteConfigModel? remoteConfig;

  Future<RemoteConfig> fetchAndActivate() async {
    getIt.get<AppStore>().setRemoteConfigStatus(
          const RemoteConfigUnion.loading(),
        );

    _logger.log(stateFlow, 'Loading Remote Config');

    try {
      final flavor = flavorService();
      //final timeTrackerN = read(timeTrackingNotipod.notifier);

      var remoteConfigURL = '';
      final storageService = getIt.get<LocalStorageService>();
      final activeSlotUsing = await storageService.getValue(activeSlot);
      final isFirstRunning =
          await getIt<LocalCacheService>().checkIsFirstRunning();
      final isSlotBActive = activeSlotUsing == 'slot b' && !isFirstRunning;

      remoteConfigURL = flavor == Flavor.prod
          ? 'https://wallet-api.simple.app/api/v1/remote-config/config'
          : 'https://wallet-api-uat.simple-spot.biz/api/v1/remote-config/config';

      final response = await Dio().get(remoteConfigURL);

      //final response = await SimpleNetworking(setupDioWithoutInterceptors()).getRemoteConfigModule().getRemoteConfig(remoteConfigURL);

      Map<String, dynamic> responseData;

      responseData = response.data is String
          ? jsonDecode(response.data as String) as Map<String, dynamic>
          : response.data as Map<String, dynamic>;

      final respModel = RemoteConfigModel.fromJson(responseData);

      _logger.log(notifier, 'Loading Remote LOADED');

      remoteConfig = respModel;

      overrideAppConfigValues();
      overrideVersioningValues();
      overrideSupportValues();
      overrideAnalyticsValues();
      overrideSimplexValues();
      overrideAppsFlyerValues();
      overrideCircleValues();
      overrideNFTValues();

      overrideApisFrom(_defaultFlavorIndex, isSlotBActive);

      _logger.log(notifier, 'PUSH TO HOMEROUTER');

      sAnalytics.remoteConfig();

      getIt.get<AppStore>().setRemoteConfigStatus(
            const RemoteConfigUnion.success(),
          );
    } catch (e) {
      print('REMOTE: $e');

      _logger.log(stateFlow, '_fetchAndActivate', e);
      sAnalytics.remoteConfigError();

      getIt.get<AppStore>().setRemoteConfigStatus(
            const RemoteConfigUnion.error(),
          );

      _refreshTimer();
    }

    return this;
  }

  void _refreshTimer() {
    _timer?.cancel();
    retryTime = _retryTime;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (retryTime == 0) {
          timer.cancel();
          fetchAndActivate();
        } else {
          retryTime -= 1;
        }
      },
    );
  }

  /// Each index respresents different flavor (backend environment)
  void overrideApisFrom(int index, bool slotBActive) {
    final flavor = slotBActive
        ? remoteConfig?.connectionFlavorsSlave[index]
        : remoteConfig?.connectionFlavors[index];

    getIt.get<SNetwork>().simpleOptions = SimpleOptions(
      candlesApi: flavor!.candlesApi,
      authApi: flavor.authApi,
      walletApi: flavor.walletApi,
      walletApiSignalR: flavor.walletApiSignalR,
      validationApi: flavor.validationApi,
      iconApi: flavor.iconApi,
    );
  }

  void overrideAppConfigValues() {
    emailVerificationCodeLength =
        remoteConfig!.appConfig.emailVerificationCodeLength;
    phoneVerificationCodeLength =
        remoteConfig!.appConfig.phoneVerificationCodeLength;
    userAgreementLink = remoteConfig!.appConfig.userAgreementLink;
    privacyPolicyLink = remoteConfig!.appConfig.privacyPolicyLink;
    referralPolicyLink = remoteConfig!.appConfig.referralPolicyLink;
    nftTermsLink = remoteConfig!.appConfig.nftTermsLink;
    nftPolicyLink = remoteConfig!.appConfig.nftPolicyLink;
    simpleCompanyName = remoteConfig!.appConfig.simpleCompanyName;
    simpleCompanyAddress = remoteConfig!.appConfig.simpleCompanyAddress;
    infoRewardsLink = remoteConfig!.appConfig.infoRewardsLink;
    infoEarnLink = remoteConfig!.appConfig.infoEarnLink;
    paymentDelayDays = remoteConfig!.appConfig.paymentDelayDays;
    privacyEarnLink = remoteConfig!.appConfig.privacyEarnLink;
    amlKycPolicyLink = remoteConfig!.appConfig.amlKycPolicyLink;
    minAmountOfCharsInPassword =
        remoteConfig!.appConfig.minAmountOfCharsInPassword;
    maxAmountOfCharsInPassword =
        remoteConfig!.appConfig.maxAmountOfCharsInPassword;
    quoteRetryInterval = remoteConfig!.appConfig.quoteRetryInterval;
    defaultAssetIcon = remoteConfig!.appConfig.defaultAssetIcon;
    emailResendCountdown = remoteConfig!.appConfig.emailResendCountdown;
    withdrawalConfirmResendCountdown =
        remoteConfig!.appConfig.withdrawConfirmResendCountdown;
    localPinLength = remoteConfig!.appConfig.localPinLength;
    maxPinAttempts = remoteConfig!.appConfig.maxPinAttempts;
    forgotPasswordLockHours = remoteConfig!.appConfig.forgotPasswordLockHours;
    changePasswordLockHours = remoteConfig!.appConfig.changePasswordLockHours;
    changePhoneLockHours = remoteConfig!.appConfig.changePhoneLockHours;
    refundPolicyLink = remoteConfig!.appConfig.refundPolicyLink;
    cardLimitsLearnMoreLink = remoteConfig!.appConfig.cardLimitsLearnMoreLink;
  }

  void overrideVersioningValues() {
    recommendedVersion = remoteConfig!.versioning.recommendedVersion;
    minimumVersion = remoteConfig!.versioning.minimumVersion;
  }

  void overrideSupportValues() {
    faqLink = remoteConfig!.support.faqLink;
    crispWebsiteId = remoteConfig!.support.crispWebsiteId;
  }

  void overrideAnalyticsValues() {
    analyticsApiKey = remoteConfig!.analytics.apiKey;
  }

  void overrideSimplexValues() {
    simplexOrigin = remoteConfig!.simplex.origin;
  }

  void overrideAppsFlyerValues() {
    appsFlyerKey = remoteConfig!.appsFlyer.devKey;
    iosAppId = remoteConfig!.appsFlyer.iosAppId;

    getIt.registerSingleton<AppsFlyerService>(
      AppsFlyerService.create(
        devKey: appsFlyerKey,
        iosAppId: iosAppId,
      ),
    );
  }

  void overrideCircleValues() {
    cvvEnabled = remoteConfig!.circle.cvvEnabled;
  }

  void overrideNFTValues() {
    shortUrl = remoteConfig!.nft.shortUrl;
    fullUrl = remoteConfig!.nft.fullUrl;
    shareLink = remoteConfig!.nft.shareLink;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _durationTimer.cancel();
  }
}
