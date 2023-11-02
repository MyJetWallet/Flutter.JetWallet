import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/actions/action_send/widgets/show_send_timer_alert_or.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';

void showExchangeAction({
  required BuildContext context,
}) {
  final kycState = getIt.get<KycService>();
  final handler = getIt.get<KycAlertHandler>();
  if (kycState.tradeStatus == kycOperationStatus(KycStatus.allowed)) {
    showSendTimerAlertOr(
      context: context,
      or: () => sRouter.push(ConvertRouter()),
      from: [BlockingType.trade],
    );
  } else {
    handler.handle(
      status: kycState.tradeStatus,
      isProgress: kycState.verificationInProgress,
      currentNavigate: () {
        sRouter.push(ConvertRouter());
      },
      requiredDocuments: kycState.requiredDocuments,
      requiredVerifications: kycState.requiredVerifications,
    );
  }
}
