import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:simple_kit/modules/shared/simple_show_alert_popup.dart';

class InternetCheckerService {
  final _connectivity = Connectivity();

  bool internetAvailable = false;
  bool isWaitAlert = false;
  bool isAlertOpen = false;
  Duration secondsBeforeOpen = const Duration(seconds: 5);

  Future<InternetCheckerService> initialise() async {
    final result = await _connectivity.checkConnectivity();

    await _checkStatus(result);
    _connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });

    return this;
  }

  Future<void> checkFromForeground() async {
    final result = await _connectivity.checkConnectivity();

    await _checkStatus(result);
  }

  Future<void> _checkStatus(List<ConnectivityResult> result) async {
    if (result.contains(ConnectivityResult.mobile)) {
      internetAvailable = true;

      if (isAlertOpen) {
        Navigator.pop(sRouter.navigatorKey.currentContext!);
        isAlertOpen = false;
      }
    } else if (result.contains(ConnectivityResult.wifi)) {
      internetAvailable = true;

      if (isAlertOpen) {
        Navigator.pop(sRouter.navigatorKey.currentContext!);
        isAlertOpen = false;
      }
    } else {
      internetAvailable = false;

      showNoConnectionAlert();
    }
  }

  void showNoConnectionAlert([Duration? duration]) {
    isWaitAlert = true;

    Future.delayed(duration ?? secondsBeforeOpen, () {
      if (internetAvailable) {
        isWaitAlert = false;

        return;
      } else {
        if (isAlertOpen) return;

        isAlertOpen = true;

        sShowAlertPopup(
          sRouter.navigatorKey.currentContext!,
          willPopScope: false,
          primaryText: intl.noInternetConnection_header,
          secondaryText: intl.noInternetConnection_descr,
          isNeedPrimaryButton: false,
          primaryButtonName: '',
          onPrimaryButtonTap: () => () {},
        );
      }
    });
  }
}
