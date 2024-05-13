import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/actions/action_send/widgets/show_send_timer_alert_or.dart';
import 'package:jetwallet/features/buy_flow/ui/amount_screen.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/sell_flow/widgets/sell_choose_asset_bottom_sheet.dart';
import 'package:jetwallet/features/sell_flow/widgets/sell_with_bottom_sheet.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';

void showSellAction(BuildContext context) {
  final kyc = getIt.get<KycService>();
  final handler = getIt.get<KycAlertHandler>();

  handler.handle(
    status: kyc.tradeStatus,
    isProgress: kyc.verificationInProgress,
    currentNavigate: () => showSendTimerAlertOr(
      context: context,
      or: () {
        _sellAction(context);
      },
      from: [BlockingType.trade],
    ),
    requiredDocuments: kyc.requiredDocuments,
    requiredVerifications: kyc.requiredVerifications,
  );
}

void _sellAction(BuildContext context) {
  showSellChooseAssetBottomSheet(
    context: context,
    onChooseAsset: (currency) {
      showSellPayWithBottomSheet(
        context: context,
        currency: currency,
        onSelected: ({account, card}) {
          sRouter.push(
            AmountRoute(
              tab: AmountScreenTab.sell,
              asset: currency,
              account: account,
              simpleCard: card,
            ),
          );
        },
        then: (value) {
          if (value != true) {
            sAnalytics.tapOnCloseSheetSellToButton();
          }
        },
      );
    },
    then: (value) {
      if (value != true) {
        sAnalytics.tapOnCloseSheetFromSellButton();
      }
    },
  );
}
