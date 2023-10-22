import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/actions/action_send/widgets/show_send_timer_alert_or.dart';
import 'package:jetwallet/features/currency_buy/ui/screens/pay_with_bottom_sheet.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';

/// Checks KYC elegebility status and shows appropriate action
void showBuyAction({
  bool shouldPop = true,
  bool showRecurring = false,
  Source? from,
  CurrencyModel? currency,
  required BuildContext context,
}) {
  final kyc = getIt.get<KycService>();

  final isBuyMethodsAvailable =
      sSignalRModules.currenciesList.where((element) => element.buyMethods.isNotEmpty).isNotEmpty;

  if ((kyc.depositStatus == kycOperationStatus(KycStatus.allowed)) && isBuyMethodsAvailable) {
    _showAction(context);
  } else {
    if (shouldPop) Navigator.pop(context);
    sNotification.showError(
      intl.my_wallets_actions_warning,
      id: 1,
      hideIcon: true,
    );
  }
}

void _showAction(BuildContext context) {
  sAnalytics.newBuyChooseAssetView();

  showSendTimerAlertOr(
    context: context,
    or: () {
      sRouter.push(
        ChooseAssetRouter(
          onChooseAsset: (currency) {
            showPayWithBottomSheet(
              context: context,
              currency: currency,
            );
          },
        ),
      );
    },
    from: BlockingType.deposit,
  );
}
