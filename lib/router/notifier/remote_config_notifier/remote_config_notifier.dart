import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_networking/services/remote_config/models/remote_config_model.dart';
import 'package:simple_networking/shared/api_urls.dart';

import '../../../shared/logging/levels.dart';
import '../../../shared/providers/flavor_pod.dart';
import '../../../shared/providers/service_providers.dart';
import '../../../shared/services/remote_config_service/remote_config_values.dart';
import 'remote_config_union.dart';

const _retryTime = 10; // in seconds
const _defaultFlavorIndex = 0;
//const _splashScreenDuration = 3000; // in milliseconds

class RemoteConfigNotifier extends StateNotifier<RemoteConfigUnion> {
  RemoteConfigNotifier(this.read) : super(const Loading()) {
    _fetchAndActivate();
  }

  static final _logger = Logger('RemoteConfigNotifier');
  Reader read;

  Timer? _timer;
  late Timer _durationTimer;
  late int retryTime;
  final stopwatch = Stopwatch();
  bool isStopwatchStarted = false;

  RemoteConfigModel? remoteConfig;

  /*
  void _startStopwatch() {
    isStopwatchStarted = true;

    if (!isStopwatchStarted) {
      stopwatch.start();
    }
  }
  */

  Future<void> _fetchAndActivate() async {
    state = const Loading();

    try {
      //_startStopwatch();

      //await RemoteConfigService().fetchAndActivate();

      //stopwatch.stop();

      final flavor = read(flavorPod);

      var remoteConfigURL = '';

      if (flavor == Flavor.prod) {
        remoteConfigURL = 'https://wallet-api.simple-spot.biz/api/v1';
      } else {
        remoteConfigURL = 'https://wallet-api-uat.simple-spot.biz/api/v1';
      }

      final _ = await read(remoteConfigPod)
          .getRemoteConfig(
        remoteConfigURL,
        read(intlPod).localeName,
      )
          .then(
        (value) {
          remoteConfig = value;

          overrideAppConfigValues();
          overrideApisFrom(_defaultFlavorIndex);
          overrideVersioningValues();
          overrideSupportValues();
          overrideAnalyticsValues();
          overrideSimplexValues();
          overrideAppsFlyerValues();
          overrideCircleValues();

          state = const Success();
        },
      );

      /*
      if (stopwatch.elapsedMilliseconds < _splashScreenDuration) {
        _durationTimer = Timer(
          Duration(
            milliseconds: _splashScreenDuration - stopwatch.elapsedMilliseconds,
          ),
          () {
            state = const Success();
          },
        );
      } else {
        state = const Success();
      }
      */
    } catch (e) {
      _logger.log(stateFlow, '_fetchAndActivate', e);

      state = const Loading();

      _refreshTimer();
    }
  }

  void _refreshTimer() {
    _timer?.cancel();
    retryTime = _retryTime;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (retryTime == 0) {
          timer.cancel();
          _fetchAndActivate();
        } else {
          retryTime -= 1;
        }
      },
    );
  }

  void overrideApisFrom(int index) {
    final flavor = remoteConfig?.connectionFlavors[index];

    candlesApi = flavor!.candlesApi;
    authApi = flavor.authApi;
    walletApi = flavor.walletApi;
    walletApiSignalR = flavor.walletApiSignalR;
    validationApi = flavor.validationApi;
    iconApi = flavor.iconApi;
  }

  void overrideAppConfigValues() {
    emailVerificationCodeLength =
        remoteConfig!.appConfig.emailVerificationCodeLength;
    phoneVerificationCodeLength =
        remoteConfig!.appConfig.phoneVerificationCodeLength;
    userAgreementLink = remoteConfig!.appConfig.userAgreementLink;
    privacyPolicyLink = remoteConfig!.appConfig.privacyPolicyLink;
    referralPolicyLink = remoteConfig!.appConfig.referralPolicyLink;
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
  }

  void overrideCircleValues() {
    cvvEnabled = remoteConfig!.circle.cvvEnabled;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _durationTimer.cancel();
    super.dispose();
  }
}
