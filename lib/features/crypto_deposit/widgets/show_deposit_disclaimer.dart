import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:simple_kit/modules/shared/simple_show_slides_alert_popup.dart';
import 'package:simple_kit/simple_kit.dart';

void showDepositDisclaimer({
  required BuildContext context,
  required String assetSymbol,
  required String screenTitle,
  required void Function()? onDismiss,
  required PageController controller,
  required Widget slidesControllers,
  required KycAlertHandler kycAlertHandler,
  required SWidgetSize size,
  required List<KycDocumentType> requiredDocuments,
  required List<RequiredVerified> requiredVerifications,
  required bool verificationInProgress,
  required int withdrawalStatus,
  required bool showAllAlerts,
}) {
  final action =
      screenTitle == 'Receive' ? screenTitle : intl.showDepositDisclaimer_send;

  if (showAllAlerts) {
    sShowSlideAlertPopup(
      context,
      controller: controller,
      slidesControllers: slidesControllers,
      primaryText: '$action ${intl.showDepositDisclaimer_only} '
          '$assetSymbol ${intl.showDepositDisclaimer_primatyTextTitle}',
      secondaryText: intl.showDepositDisclaimer_primatyTextSecond,
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
      primaryText1: '${intl.showDepositDisclaimer_primatyTextOnly} \$700',
      secondaryText1: intl.actionBuy_alertPopupSecond,
      primaryButtonName1: intl.actionBuy_goToKYC,
      onPrimaryButtonTap1: () {
        kycAlertHandler.handle(
          status: withdrawalStatus,
          isProgress: verificationInProgress,
          currentNavigate: () {},
          size: size,
          kycFlowOnly: true,
          requiredDocuments: requiredDocuments,
          requiredVerifications: requiredVerifications,
        );
      },
      secondaryButtonName1: intl.actionBuy_gotIt,
      onSecondaryButtonTap1: () {
        Navigator.pop(context);

        final storage = sLocalStorageService;

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
        final storage = sLocalStorageService;
        storage.setString(assetSymbol, 'accepted');
        if (onDismiss != null) {
          onDismiss();
        }
      },
    );
  }
}
