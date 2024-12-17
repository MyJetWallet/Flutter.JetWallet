import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/actions/action_buy/action_buy.dart';
import 'package:jetwallet/features/actions/action_sell/action_sell.dart';
import 'package:jetwallet/features/actions/action_send/action_send.dart';
import 'package:jetwallet/features/my_wallets/helper/show_select_account_for_add_cash.dart';
import 'package:jetwallet/features/my_wallets/store/my_wallets_srore.dart';
import 'package:jetwallet/utils/helpers/currencies_with_balance_from.dart';
import 'package:simple_analytics/simple_analytics.dart';

class ActionsMyWalletsRowWidget extends StatelessWidget {
  const ActionsMyWalletsRowWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final myWalletsSrore = MyWalletsSrore.of(context);
    final colors = SColorsLight();

    return SPaddingH24(
      child: Observer(
        builder: (context) {
          final currencies = sSignalRModules.currenciesList;
          final isEmptyBalance = currenciesWithBalanceFrom(currencies).isEmpty;

          return myWalletsSrore.isLoading
              ? const SPaddingH24(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _LoadingButton(),
                      _LoadingButton(),
                      _LoadingButton(),
                      _LoadingButton(),
                    ],
                  ),
                )
              : ActionPannel(
                  actionButtons: [
                    SActionButton(
                      icon: Assets.svg.medium.add.simpleSvg(
                        color: colors.white,
                      ),
                      onTap: () {
                        sAnalytics.tapOnTheBuyWalletButton(
                          source: 'Wallets - Buy',
                        );

                        myWalletsSrore.endReorderingImmediately();

                        showBuyAction(context: context);
                      },
                      lable: intl.balanceActionButtons_buy,
                    ),
                    SActionButton(
                      onTap: () {
                        sAnalytics.tapOnTheSellButtonOnWalletsScr();

                        myWalletsSrore.endReorderingImmediately();

                        showSellAction(context);
                      },
                      lable: intl.operationName_sell,
                      icon: Assets.svg.medium.remove.simpleSvg(
                        color: SColorsLight().white,
                      ),
                    ),
                    SActionButton(
                      onTap: () {
                        myWalletsSrore.endReorderingImmediately();

                        showSendAction(isEmptyBalance, context);
                      },
                      lable: intl.balanceActionButtons_send,
                      icon: Assets.svg.medium.arrowUp.simpleSvg(
                        color: SColorsLight().white,
                      ),
                    ),
                    SActionButton(
                      icon: Assets.svg.medium.cash.simpleSvg(
                        color: colors.white,
                      ),
                      onTap: () {
                        sAnalytics.tapOnTheButtonAddCashWalletsOnWalletsScreen();
                        sAnalytics.tapOnTheDepositButton(
                          source: 'Wallets - Deposit',
                        );

                        myWalletsSrore.endReorderingImmediately();

                        showSelectAccountForAddCash(context);
                      },
                      lable: intl.balanceActionButtons_add_cash,
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
            const SpaceH12(),
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
