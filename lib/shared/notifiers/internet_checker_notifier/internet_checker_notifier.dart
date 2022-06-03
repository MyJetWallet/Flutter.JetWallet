import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';
import '../../providers/service_providers.dart';
import 'internet_checker_state.dart';

class InternetCheckerNotifier extends StateNotifier<InternetCheckerState> {
  InternetCheckerNotifier(this.read) : super(InternetCheckerState()) {
    _context = read(sNavigatorKeyPod).currentContext!;
  }

  final Reader read;

  final _connectivity = Connectivity();
  late BuildContext _context;

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
      state = state.copyWith(internetAvailable: true);

      if (isAlertOpen) {
        Navigator.pop(_context);
        isAlertOpen = false;
      }
    } else if (result == ConnectivityResult.wifi) {
      state = state.copyWith(internetAvailable: true);

      if (isAlertOpen) {
        Navigator.pop(_context);
        isAlertOpen = false;
      }
    } else {
      state = state.copyWith(internetAvailable: false);

      showNoConnectionAlert();
    }
  }

  void showNoConnectionAlert() {
    final intl = read(intlPod);
    isWaitAlert = true;

    Future.delayed(secondsBeforeOpen, () {
      if (state.internetAvailable == true) {
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
