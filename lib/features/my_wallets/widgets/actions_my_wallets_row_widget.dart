import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/actions/action_buy/action_buy.dart';
import 'package:jetwallet/features/actions/action_receive/action_receive.dart';
import 'package:jetwallet/features/actions/action_send/action_send.dart';
import 'package:jetwallet/features/actions/action_send/widgets/show_send_timer_alert_or.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/my_wallets/store/my_wallets_srore.dart';
import 'package:jetwallet/utils/helpers/currencies_with_balance_from.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_buy.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_exchange.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_receive.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_send.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';

class ActionsMyWalletsRowWidget extends StatelessWidget {
  const ActionsMyWalletsRowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final kycState = getIt.get<KycService>();
    final myWalletsSrore = getIt.get<MyWalletsSrore>();

    final currencies = sSignalRModules.currenciesList;
    final isEmptyBalanse = currenciesWithBalanceFrom(currencies).isEmpty;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CircleActionBuy(
          onTap: () {
            sAnalytics.newBuyTapBuy(
              source: 'My Assets - Buy',
            );
            if (myWalletsSrore.isReordering) {
              myWalletsSrore.endReorderingImmediately();
            } else {
              showBuyAction(
                shouldPop: false,
                context: context,
              );
            }
          },
        ),
        CircleActionReceive(
          onTap: () {
            sAnalytics.tapOnTheReceiveButton(
              source: 'My Assets - Receive',
            );
            if (myWalletsSrore.isReordering) {
              myWalletsSrore.endReorderingImmediately();
            } else {
              showReceiveAction(context);
            }
          },
        ),
        CircleActionSend(
          onTap: () {
            sAnalytics.tabOnTheSendButton(source: 'My Assets - Send');

            if (myWalletsSrore.isReordering) {
              myWalletsSrore.endReorderingImmediately();
            } else {
              showSendAction(
                context,
              );
            }
          },
          isDisabled: isEmptyBalanse,
        ),
        CircleActionExchange(
          onTap: () {
            if (myWalletsSrore.isReordering) {
              myWalletsSrore.endReorderingImmediately();
            } else if (kycState.sellStatus == kycOperationStatus(KycStatus.allowed)) {
              showSendTimerAlertOr(
                context: context,
                or: () => sRouter.push(ConvertRouter()),
                from: BlockingType.trade,
              );
            } else {
              sNotification.showError(
                intl.my_wallets_actions_warning,
                id: 3,
                hideIcon: true,
              );
            }
          },
          isDisabled: isEmptyBalanse,
        ),
      ],
    );
  }
}
