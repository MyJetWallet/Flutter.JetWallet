// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/actions/action_buy/action_buy.dart';
import 'package:jetwallet/features/actions/action_receive/action_receive.dart';
import 'package:jetwallet/features/actions/action_send/action_send.dart';
import 'package:jetwallet/features/my_wallets/helper/show_deposit_details_popup.dart';
import 'package:jetwallet/features/my_wallets/store/my_wallets_srore.dart';
import 'package:jetwallet/utils/helpers/currencies_with_balance_from.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_add_cash.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_buy.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_receive.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_send.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/shared/simple_paddings.dart';
import 'package:simple_kit/modules/shared/simple_spacers.dart';
import 'package:simple_kit_updated/widgets/shared/simple_skeleton_loader.dart';

class ActionsMyWalletsRowWidget extends StatelessWidget {
  const ActionsMyWalletsRowWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final myWalletsSrore = getIt.get<MyWalletsSrore>();

    return SPaddingH24(
      child: Observer(
        builder: (context) {
          final currencies = sSignalRModules.currenciesList;
          final isEmptyBalanse = currenciesWithBalanceFrom(currencies).isEmpty;

          return myWalletsSrore.isLoading
              ? const SPaddingH24(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [_LoadingButton(), _LoadingButton(), _LoadingButton(), _LoadingButton()],
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleActionBuy(
                      onTap: () {
                        sAnalytics.tapOnTheBuyWalletButton(source: 'Wallets - Buy');
                        if (myWalletsSrore.isReordering) {
                          myWalletsSrore.endReorderingImmediately();
                        } else {
                          showBuyAction(context: context);
                        }
                      },
                    ),
                    CircleActionSend(
                      onTap: () {
                        sAnalytics.tabOnTheSendButton(source: 'My Assets - Send');
                        if (myWalletsSrore.isReordering) {
                          myWalletsSrore.endReorderingImmediately();
                        } else {
                          showSendAction(context);
                        }
                      },
                      isDisabled: isEmptyBalanse,
                    ),
                    CircleActionReceive(
                      onTap: () {
                        sAnalytics.tapOnTheReceiveButton(source: 'My Assets - Receive');
                        if (myWalletsSrore.isReordering) {
                          myWalletsSrore.endReorderingImmediately();
                        } else {
                          showReceiveAction(context);
                        }
                      },
                    ),
                    CircleActionAddCash(
                      onTap: () {
                        sAnalytics.tabOnTheSendButton(source: 'My Assets - Add cash');
                        if (myWalletsSrore.isReordering) {
                          myWalletsSrore.endReorderingImmediately();
                        } else {
                          showSelectAccountForAddCash(context);
                        }
                      },
                    ),
                  ],
                );
        },
      ),
    );
  }
}

class _LoadingButton extends StatelessWidget {
  const _LoadingButton();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 68,
        child: Column(
          children: [
            SSkeletonLoader(
              width: 40,
              height: 40,
              borderRadius: BorderRadius.circular(40),
            ),
            SpaceH12(),
            SSkeletonLoader(
              width: 28,
              height: 16,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      ),
    );
  }
}
