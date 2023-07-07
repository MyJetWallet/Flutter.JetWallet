import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/actions/action_buy/widgets/buy_payment_currency.dart';
import 'package:jetwallet/features/actions/action_send/widgets/show_send_timer_alert_or.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';

/// Checks KYC elegebility status and shows appropriate action
void showBuyAction({
  bool shouldPop = true,
  bool showRecurring = false,
  Source? from,
  required bool fromCard,
  required BuildContext context,
}) {
  final kyc = getIt.get<KycService>();
  final handler = getIt.get<KycAlertHandler>();

  void showAction() {
    sAnalytics.newBuyChooseAssetView();

    showSendTimerAlertOr(
      context: context,
      or: () {
        sRouter.push(
          const ChooseAssetRouter(),
        );
      },
      from: BlockingType.deposit,
    );
  }

  if (kyc.depositStatus == kycOperationStatus(KycStatus.allowed)) {
    showAction();
  } else {
    if (shouldPop) Navigator.pop(context);
    handler.handle(
      status: kyc.depositStatus,
      isProgress: kyc.verificationInProgress,
      currentNavigate: () => showAction(),
      requiredDocuments: kyc.requiredDocuments,
      requiredVerifications: kyc.requiredVerifications,
    );
  }
}
