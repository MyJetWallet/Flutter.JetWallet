import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/apps_flyer_service.dart';
import 'package:jetwallet/core/services/flavor_service.dart';
import 'package:jetwallet/core/services/remote_config/models/remote_config_union.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_conection_url_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:simple_networking/config/options.dart';
import 'package:simple_networking/modules/remote_config/models/remote_config_model.dart';
import 'package:simple_networking/simple_networking.dart';

import '../local_cache/local_cache_service.dart';
import '../local_storage_service.dart';

const _retryTime = 10; // in seconds
const _defaultFlavorIndex = 0;

/// [RemoteConfigService] is a Signleton
class RemoteConfig {
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

    try {
      final flavor = flavorService();

      var remoteConfigURL = '';

      final storageService = getIt.get<LocalStorageService>();
      final activeSlotUsing = await storageService.getValue(activeSlot);

      final isFirstRunning = await getIt<LocalCacheService>().checkIsFirstRunning();

      final isSlotBActive = activeSlotUsing == 'slot b' && !isFirstRunning;

      Future<RemoteConfigModel> getRemoteConfigFromServer() async {
        remoteConfigURL = flavor == Flavor.prod
            ? 'https://wallet-api.simple.app/api/v1/remote-config/config'
            : 'https://wallet-api-uat.simple-spot.biz/api/v1/remote-config/config';

        final response = await Dio().get(remoteConfigURL);

        Map<String, dynamic> responseData;

        responseData = response.data is String
            ? jsonDecode(response.data as String) as Map<String, dynamic>
            : response.data as Map<String, dynamic>;

        return RemoteConfigModel.fromJson(responseData);
      }

      Future<RemoteConfigModel> getRemoteConfigFromCache() async {
        final remoteConfigLocal = await getIt<LocalCacheService>().getRemoteConfig();

        return remoteConfigLocal ?? await getRemoteConfigFromServer();
      }

      Future<void> overrideConfig() async {
        overrideAppConfigValues();
        overrideVersioningValues();
        overrideSupportValues();
        overrideAnalyticsValues();
        overrideSimplexValues();
        overrideAppsFlyerValues();
        overrideCircleValues();
        overrideMerchantPayConfigValues();
        overrideSiftConfigValues();

        overrideApisFrom(
          _defaultFlavorIndex,
          isSlotBActive,
        );
      }

      remoteConfig = await getRemoteConfigFromCache();

      await overrideConfig();

      getIt.get<AppStore>().setRemoteConfigStatus(
            const RemoteConfigUnion.success(),
          );

      /// Silent update from Server
      remoteConfig = await getRemoteConfigFromServer();

      await overrideConfig();
    } catch (e) {
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
    final flavor = slotBActive ? remoteConfig?.connectionFlavorsSlave[index] : remoteConfig?.connectionFlavors[index];

    getIt.get<SNetwork>().simpleOptions = SimpleOptions(
      candlesApi: flavor!.candlesApi,
      authApi: flavor.authApi,
      walletApi: flavor.walletApi,
      walletApiSignalR: flavor.walletApiSignalR,
      validationApi: flavor.validationApi,
      iconApi: flavor.iconApi,
    );

    getIt.get<SignalRConecrionUrlService>().init(
      urls: [
        flavor.walletApiSignalR,
        flavor.walletApiSignalR2,
        flavor.walletApiSignalR3,
        flavor.walletApiSignalR4,
        flavor.walletApiSignalR5,
        flavor.walletApiSignalR6,
      ],
    );

    iconApi = flavor.iconApi;
  }

  void overrideAppConfigValues() {
    emailVerificationCodeLength = remoteConfig!.appConfig.emailVerificationCodeLength;
    phoneVerificationCodeLength = remoteConfig!.appConfig.phoneVerificationCodeLength;
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
    minAmountOfCharsInPassword = remoteConfig!.appConfig.minAmountOfCharsInPassword;
    maxAmountOfCharsInPassword = remoteConfig!.appConfig.maxAmountOfCharsInPassword;
    quoteRetryInterval = remoteConfig!.appConfig.quoteRetryInterval;
    defaultAssetIcon = remoteConfig!.appConfig.defaultAssetIcon;
    emailResendCountdown = remoteConfig!.appConfig.emailResendCountdown;
    withdrawalConfirmResendCountdown = remoteConfig!.appConfig.withdrawConfirmResendCountdown;
    localPinLength = remoteConfig!.appConfig.localPinLength;
    maxPinAttempts = remoteConfig!.appConfig.maxPinAttempts;
    forgotPasswordLockHours = remoteConfig!.appConfig.forgotPasswordLockHours;
    changePasswordLockHours = remoteConfig!.appConfig.changePasswordLockHours;
    changePhoneLockHours = remoteConfig!.appConfig.changePhoneLockHours;
    refundPolicyLink = remoteConfig!.appConfig.refundPolicyLink;
    cardLimitsLearnMoreLink = remoteConfig!.appConfig.cardLimitsLearnMoreLink;
    p2pTerms = remoteConfig!.appConfig.p2pTerms;
    rateUp = remoteConfig!.appConfig.rateUp;
    displayCardPreorderScreen = remoteConfig!.appConfig.displayCardPreorderScreen;
    prepaidCardPartnerLink = remoteConfig!.appConfig.prepaidCardPartnerLink;
    prepaidCardTermsAndConditionsLink = remoteConfig!.appConfig.prepaidCardTermsAndConditionsLink;
    useAmplitude = remoteConfig!.appConfig.useAmplitude;
    simpleCoinDisclaimerLink = remoteConfig!.appConfig.simpleCoinDisclaimerLink;
    simpleTapLink = remoteConfig!.appConfig.simpleTapLink;
    usePhoneForSendGift = remoteConfig!.appConfig.usePhoneForSendGift;
    simpleCoinRoadmapCompletedSteep = remoteConfig!.appConfig.simpleCoinRoadmapCompletedSteep;
  }

  void overrideVersioningValues() {
    recommendedVersion = remoteConfig!.versioning.recommendedVersion;
    minimumVersion = remoteConfig!.versioning.minimumVersion;
  }

  void overrideSupportValues() {
    faqLink = remoteConfig!.support.faqLink ?? '';
    crispWebsiteId = remoteConfig!.support.crispWebsiteId ?? '';
    showZendesk = remoteConfig!.support.showZendesk ?? true;
    zendeskIOS = remoteConfig!.support.zendeskIOS ?? '';
    zendeskAndroid = remoteConfig!.support.zendeskAndroid ?? '';
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

    if (!getIt.isRegistered<AppsFlyerService>()) {
      getIt.registerSingleton<AppsFlyerService>(
        AppsFlyerService.create(
          devKey: appsFlyerKey,
          iosAppId: iosAppId,
        ),
      );
    }
  }

  void overrideCircleValues() {
    cvvEnabled = remoteConfig!.circle.cvvEnabled;
  }

  void overrideMerchantPayConfigValues() {
    displayName = remoteConfig!.merchantPay.displayName ?? '';
    merchantCapabilities = remoteConfig!.merchantPay.merchantCapabilities ?? [];
    supportedNetworks = remoteConfig!.merchantPay.supportedNetworks ?? [];
    countryCode = remoteConfig!.merchantPay.countryCode ?? '';
  }

  void overrideSiftConfigValues() {
    siftAccountId = remoteConfig!.sift?.siftAccountId ?? '';
    siftBeaconKey = remoteConfig!.sift?.siftBeaconKey ?? '';
  }

  void dispose() {
    _timer?.cancel();
    _durationTimer.cancel();
  }
}
