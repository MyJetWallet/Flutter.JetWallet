import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/providers/service_providers.dart';
import '../../../kyc/helper/kyc_alert_handler.dart';
import '../../../kyc/model/kyc_verified_model.dart';

void showDepositDisclaimer({
  required BuildContext context,
  required String assetSymbol,
  required String screenTitle,
  required void Function()? onDismiss,
  required PageController controller,
  required Widget slidesControllers,
  required KycAlertHandler kycAlertHandler,
  required KycModel kycState,
  required SWidgetSize size,
  required bool showAllAlerts,
}) {
  final intl = context.read(intlPod);
  final action =
      screenTitle == 'Receive' ? screenTitle : intl.showDepositDisclaimer_send;

  if (showAllAlerts) {
    sShowSlideAlertPopup(
      context,
      controller: controller,
      slidesControllers: slidesControllers,
      primaryText: '$action ${intl.showDepositDisclaimer_only} '
          '$assetSymbol ${intl.showDepositDisclaimer_primatyText}',
      primaryButtonName: intl.showDepositDisclaimer_next,
      barrierDismissible: false,
      willPopScope: false,
      size: size,
      onPrimaryButtonTap: () {
        controller.animateToPage(
          1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.linear,
        );
      },
      primaryText1: intl.actionBuy_alertPopup,
      primaryButtonName1: intl.actionBuy_goToKYC,
      onPrimaryButtonTap1: () {
        kycAlertHandler.handle(
          status: kycState.withdrawalStatus,
          kycVerified: kycState,
          isProgress: kycState.verificationInProgress,
          currentNavigate: () {},
          size: size,
          kycFlowOnly: true,
        );
      },
      secondaryButtonName1: intl.actionBuy_gotIt,
      onSecondaryButtonTap1: () {
        Navigator.pop(context);
        final storage = context.read(localStorageServicePod);
        storage.setString(assetSymbol, 'accepted');
        if (onDismiss != null) {
          onDismiss();
        }
      },
    );
  } else {
    sShowAlertPopup(
      context,
      primaryText: '$action ${intl.showDepositDisclaimer_only} '
          '$assetSymbol ${intl.showDepositDisclaimer_primatyText}',
      primaryButtonName: intl.showDepositDisclaimer_gotIt,
      barrierDismissible: false,
      willPopScope: false,
      onPrimaryButtonTap: () {
        Navigator.pop(context);
        final storage = context.read(localStorageServicePod);
        storage.setString(assetSymbol, 'accepted');
        if (onDismiss != null) {
          onDismiss();
        }
      },
    );
  }
}
