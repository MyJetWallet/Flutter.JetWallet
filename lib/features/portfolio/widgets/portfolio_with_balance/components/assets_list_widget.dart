import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/portfolio/widgets/portfolio_with_balance/components/balance_in_process.dart';
import 'package:jetwallet/features/wallet/helper/market_item_from.dart';
import 'package:jetwallet/features/wallet/helper/navigate_to_wallet.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/actual_in_progress_operation.dart';
import 'package:jetwallet/utils/helpers/currencies_helpers.dart';
import 'package:jetwallet/utils/helpers/currencies_with_balance_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';

class AssetsListWidget extends StatelessWidget {
  const AssetsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final baseCurrency = sSignalRModules.baseCurrency;
    final currencies = sSignalRModules.currenciesList;
    final marketItems = sSignalRModules.marketItems;
    final itemsWithBalance = currenciesWithBalanceFrom(currencies);
    final currenciesList = currencies.toList();
    sortCurrenciesMyAssets(currenciesList);

    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: getIt<AppStore>().showAllAssets
          ? currenciesList.length
          : itemsWithBalance.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final actualItem = getIt<AppStore>().showAllAssets
            ? currenciesList[index]
            : itemsWithBalance[index];

        return Column(
          children: [
            Observer(
              builder: (context) {
                return SWalletItem(
                  key: UniqueKey(),
                  isBalanceHide: getIt<AppStore>().isBalanceHide,
                  decline: actualItem.dayPercentChange.isNegative,
                  icon: SNetworkSvg24(
                    url: actualItem.iconUrl,
                  ),
                  baseCurrPrefix: baseCurrency.prefix,
                  primaryText: actualItem.description,
                  amount: actualItem.volumeBaseBalance(baseCurrency),
                  secondaryText: getIt<AppStore>().isBalanceHide
                      ? actualItem.symbol
                      : actualItem.volumeAssetBalance,
                  onTap: () {
                    if (actualItem.type == AssetType.indices) {
                      sRouter.push(
                        MarketDetailsRouter(
                          marketItem: marketItemFrom(
                            marketItems,
                            actualItem.symbol,
                          ),
                        ),
                      );
                    } else {
                      navigateToWallet(
                        context,
                        actualItem,
                      );
                    }
                  },
                  removeDivider: true,
                  isPendingDeposit: actualItem.isPendingDeposit,
                );
              },
            ),
            if (actualItem.isPendingDeposit) ...[
              BalanceInProcess(
                text: getIt<AppStore>().isBalanceHide
                    ? actualItem.symbol
                    : _balanceInProgressText(actualItem),
                leadText: _balanceInProgressLeadText(
                  actualItem,
                ),
                removeDivider: actualItem ==
                    (getIt<AppStore>().showAllAssets
                        ? currenciesList.last
                        : itemsWithBalance.last),
                icon: _balanceInProgressIcon(
                  actualItem,
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _balanceInProgressIcon(
    CurrencyModel currency,
  ) {
    if (!currency.isSingleTypeInProgress) {
      return const SDepositTotalIcon();
    }
    if (currency.transfersInProcessTotal > Decimal.zero) {
      return const SDepositSendIcon();
    } else if (currency.earnInProcessTotal > Decimal.zero) {
      return const SDepositEarnIcon();
    } else if (currency.buysInProcessTotal > Decimal.zero) {
      return const SDepositBuyIcon();
    }

    return const SDepositTotalIcon();
  }

  String _balanceInProgressText(
    CurrencyModel currency,
  ) {
    if (currency.isSingleTypeInProgress) {
      return volumeFormat(
        decimal: currency.totalAmountInProcess,
        accuracy: currency.accuracy,
        symbol: currency.symbol,
      );
    }

    return intl.portfolioWithBalanceBody_transactions;
  }

  String _balanceInProgressLeadText(
    CurrencyModel currency,
  ) {
    if (currency.isSingleTypeInProgress) {
      return actualInProcessOperationName(
        currency,
        intl.portfolioWithBalanceBody_send,
        '',
        intl.portfolioWithBalanceBody_simplex,
      );
    }

    return '${counterOfOperationInProgressTransactions(currency)} ';
  }
}
