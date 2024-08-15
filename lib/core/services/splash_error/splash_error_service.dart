import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/remote_config/remote_config.dart';
import 'package:jetwallet/core/services/sentry_service.dart';
import 'package:jetwallet/core/services/startup_service.dart';
import 'package:simple_kit/modules/shared/simple_show_alert_popup.dart';

///
/// Splash error exception decoder:
///
/// 1 - LocalStorageService init error
/// 2 - AppTrackingTransparency.requestTrackingAuthorization error
/// 3 - AppTrackingTransparency.getAdvertisingIdentifier error
/// 4 - launchSift error
/// 5 - initAppFBAnalytic error
/// 6 - initAppsFlyer error
/// 7 - AppStore setAppStatus and generateNewSessionID error
/// 8 - checkIsUserAuthorized error
/// 9 - SNetwork init error
/// 10 - sAnalytics init error
/// 11 - saveInstallID error
/// 12 - AppStore updateAuthState error
/// 13 - Refresh token error
/// 14 - SNetwork simpleNetworkingUnathorized getLogsApiModule error
/// 15 - startingServices error
/// 16 - LocalCacheService load error
/// 17 - SignlaR error
/// 18 - PushNotification registerToken error
/// 19 -
/// 20 - kyc error
/// 21 - Remote config error
///

class SplashErrorService {
  int error = 0;
  bool isWaitAlert = false;
  bool isAlertOpen = false;

  void showErrorAlert() {
    isWaitAlert = true;

    Future.delayed(const Duration(seconds: 3), () {
      if (error == 0) {
        isWaitAlert = false;

        return;
      } else {
        if (isAlertOpen) return;

        isAlertOpen = true;

        sShowAlertPopup(
          sRouter.navigatorKey.currentContext!,
          willPopScope: false,
          primaryText: '${intl.something_went_wrong} ($error)',
          primaryButtonName: intl.transactionsList_retry,
          onPrimaryButtonTap: () {
            if (error == 21) {
              getIt.get<RemoteConfig>().fetchAndActivate();
            }

            getIt.get<StartupService>().firstAction().onError(
                  (e, stackTrace) {
                if (e is SplashErrorException) {
                  getIt.get<SentryService>().captureException(e, stackTrace);

                  getIt.get<SplashErrorService>().error = e.errorCode;
                  getIt.get<SplashErrorService>().showErrorAlert();
                }
              },
            );
            error = 0;
            closeErrorAlert();
          },
        );
      }
    });
  }

  void closeErrorAlert() {
    if (isAlertOpen) {
      Navigator.pop(sRouter.navigatorKey.currentContext!);
      isAlertOpen = false;
    }
  }
}

class SplashErrorException implements Exception {
  SplashErrorException(this.errorCode);

  final int errorCode;

  @override
  String toString() => 'SplashErrorException error: $errorCode';
}
