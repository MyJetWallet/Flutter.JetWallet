import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/actions/action_buy/action_buy.dart';
import 'package:jetwallet/features/actions/action_receive/action_receive.dart';
import 'package:jetwallet/features/actions/action_send/action_send.dart';
import 'package:jetwallet/features/my_wallets/store/my_wallets_srore.dart';
import 'package:jetwallet/utils/helpers/currencies_with_balance_from.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_buy.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_receive.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_send.dart';
import 'package:simple_analytics/simple_analytics.dart';

class ActionsMyWalletsRowWidget extends StatelessWidget {
  const ActionsMyWalletsRowWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
      ],
    );
  }
}
