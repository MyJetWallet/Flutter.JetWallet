import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:simple_kit/modules/shared/simple_show_alert_popup.dart';

class InternetCheckerService {
  InternetCheckerService() {
    _context = sRouter.navigatorKey.currentContext!;

    initialise();
  }

  late BuildContext _context;

  final _connectivity = Connectivity();

  bool internetAvailable = false;
  bool isWaitAlert = false;
  bool isAlertOpen = false;
  Duration secondsBeforeOpen = const Duration(seconds: 5);

  Future<void> initialise() async {
    final result = await _connectivity.checkConnectivity();

    await _checkStatus(result);
    _connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  Future<void> _checkStatus(ConnectivityResult result) async {
    if (result == ConnectivityResult.mobile) {
      internetAvailable = true;

      if (isAlertOpen) {
        Navigator.pop(_context);
        isAlertOpen = false;
      }
    } else if (result == ConnectivityResult.wifi) {
      internetAvailable = true;

      if (isAlertOpen) {
        Navigator.pop(_context);
        isAlertOpen = false;
      }
    } else {
      internetAvailable = false;

      showNoConnectionAlert();
    }
  }

  void showNoConnectionAlert() {
    ;
    isWaitAlert = true;

    Future.delayed(secondsBeforeOpen, () {
      if (internetAvailable) {
        isWaitAlert = false;

        return;
      } else {
        isAlertOpen = true;

        sShowAlertPopup(
          _context,
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
