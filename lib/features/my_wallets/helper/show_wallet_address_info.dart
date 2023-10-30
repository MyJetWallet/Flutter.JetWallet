import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

void showWalletAdressInfo(
  BuildContext context, {
  required VoidCallback after,
}) {
  final kycState = getIt.get<KycService>();
  final kycAlertHandler = getIt.get<KycAlertHandler>();

  sShowAlertPopup(
    context,
    primaryText: '',
    secondaryText: intl.wallet_please_update_your_address,
    primaryButtonName: intl.wallet_continue,
    image: Image.asset(
      infoLightAsset,
      width: 80,
      height: 80,
      package: 'simple_kit',
    ),
    onPrimaryButtonTap: () {
      sAnalytics.eurWalletTapContinueOnAdreeInfo();

      Navigator.pop(context);
      final isDepositAllow = kycState.depositStatus != kycOperationStatus(KycStatus.allowed);
      final isWithdrawalAllow = kycState.withdrawalStatus != kycOperationStatus(KycStatus.allowed);

      kycAlertHandler.handle(
        status: isDepositAllow
            ? kycState.depositStatus
            : isWithdrawalAllow
                ? kycState.withdrawalStatus
                : kycState.tradeStatus,
        isProgress: kycState.verificationInProgress,
        currentNavigate: after,
        requiredDocuments: kycState.requiredDocuments,
        requiredVerifications: kycState.requiredVerifications,
      );
    },
    secondaryButtonName: intl.wallet_cancel,
    onSecondaryButtonTap: () {
      Navigator.pop(context);
    },
  );
}
