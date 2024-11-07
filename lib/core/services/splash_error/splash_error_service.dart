import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/remote_config/remote_config.dart';
import 'package:jetwallet/core/services/startup_service.dart';
import 'package:simple_kit/modules/shared/simple_show_alert_popup.dart';

///
/// Splash error exception decoder:
///
/// 1 - LocalStorageService init error
/// 2 -
/// 3 -
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
/// 22 - Network error
///

class SplashErrorService {
  int error = 0;
  bool isWaitAlert = false;
  bool isAlertOpen = false;
  bool isFirstAlert = true;
  bool isNetworkError = false;

  Future<void> showErrorAlert() async {
    isWaitAlert = true;

    if (isFirstAlert) {
      await Future.delayed(const Duration(seconds: 5));
      isFirstAlert = false;
    } else {
      await Future.delayed(const Duration(seconds: 1));
    }

    if (error == 0) {
      isWaitAlert = false;

      return;
    } else {
      if (isAlertOpen) return;

      isAlertOpen = true;

      if (sRouter.navigatorKey.currentContext != null) {
        await sShowAlertPopup(
          sRouter.navigatorKey.currentContext!,
          willPopScope: false,
          primaryText: error == 22 ? intl.noInternetConnection_header : '${intl.something_went_wrong} ($error)',
          secondaryText: error == 22 ? intl.noInternetConnection_descr : null,
          primaryButtonName: intl.transactionsList_retry,
          onPrimaryButtonTap: () async {
            if (error == 21 || error == 22) {
              await getIt.get<RemoteConfig>().fetchAndActivate();
            } else {
              await getIt.get<StartupService>().firstAction();
            }

            closeErrorAlert();
          },
        );
      } else {
        isAlertOpen = false;
      }
    }
  }

  void closeErrorAlert() {
    if (isAlertOpen) {
      isAlertOpen = false;
      try {
        if (sRouter.navigatorKey.currentContext!.routeData.name == SplashRoute.name) {
          Navigator.popUntil(
            sRouter.navigatorKey.currentContext!,
            (route) {
              return route.settings.name == SplashRoute.name;
            },
          );
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }
}

class SplashErrorException implements Exception {
  SplashErrorException(
    this.errorCode, [
    this.e,
    this.stackTrace,
  ]);

  final int errorCode;
  final Object? e;
  final StackTrace? stackTrace;

  @override
  String toString() => 'SplashErrorException error: $errorCode, e: $e, stackTrace: $stackTrace';
}
