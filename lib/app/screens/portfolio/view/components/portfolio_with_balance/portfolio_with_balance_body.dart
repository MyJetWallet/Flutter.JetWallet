import 'package:charts/simple_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jetwallet/app/screens/market/provider/market_cryptos_pod.dart';
import 'package:jetwallet/app/screens/market/provider/market_currencies_indices_pod.dart';
import 'package:jetwallet/app/screens/market/provider/market_fiats_pod.dart';
import 'package:jetwallet/app/screens/market/provider/market_indices_pod.dart';
import 'package:jetwallet/shared/constants.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/helpers/currencies_with_balance_from.dart';
import '../../../../../shared/features/chart/notifier/chart_notipod.dart';
import '../../../../../shared/features/chart/notifier/chart_state.dart';
import '../../../../../shared/features/chart/view/balance_chart.dart';
import '../../../../../shared/features/market_details/helper/period_change.dart';
import '../../../../../shared/features/wallet/helper/navigate_to_wallet.dart';
import '../../../../../shared/helpers/format_currency_amount.dart';
import '../../../../../shared/models/currency_model.dart';
import '../../../../../shared/providers/base_currency_pod/base_currency_model.dart';
import '../../../../../shared/providers/base_currency_pod/base_currency_pod.dart';
import '../../../../../shared/providers/client_detail_pod/client_detail_pod.dart';
import '../../../../../shared/providers/currencies_pod/currencies_pod.dart';
import '../../../helper/currencies_without_balance_from.dart';
import '../../../helper/zero_balance_wallets_empty.dart';
import '../../../provider/show_zero_balance_wallets_stpod.dart';
import 'components/padding_l_24.dart';

class PortfolioWithBalanceBody extends HookWidget {
  const PortfolioWithBalanceBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final currencies = useProvider(currenciesPod);
    final itemsWithBalance = currenciesWithBalanceFrom(currencies);
    final itemsWithoutBalance = currenciesWithoutBalanceFrom(currencies);
    final cryptosWithBalance =
        currenciesWithBalanceFrom(useProvider(marketCryptosPod));
    final cryptosWithoutBalance =
    currenciesWithoutBalanceFrom(useProvider(marketCryptosPod));
    final indicesWithBalance =
    currenciesWithBalanceFrom(useProvider(marketCurrenciesIndicesPod));
    final indicesWithoutBalance =
    currenciesWithoutBalanceFrom(useProvider(marketCurrenciesIndicesPod));
    final fiatsWithBalance =
    currenciesWithBalanceFrom(useProvider(marketFiatsPod));
    final fiatsWithoutBalance =
    currenciesWithoutBalanceFrom(useProvider(marketFiatsPod));
    final chartN = useProvider(chartNotipod.notifier);
    final chart = useProvider(chartNotipod);
    final showZeroBalanceWallets = useProvider(showZeroBalanceWalletsStpod);
    final baseCurrency = useProvider(baseCurrencyPod);
    final clientDetail = useProvider(clientDetailPod);
    final periodChange = _periodChange(chart, baseCurrency);
    final periodChangeColor =
        periodChange.contains('-') ? colors.red : colors.green;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 104,
            child: PaddingL24(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _price(
                      chart,
                      itemsWithBalance,
                      baseCurrency,
                    ),
                    style: sTextH1Style,
                  ),
                  Row(
                    children: [
                      Text(
                        periodChange,
                        style: sSubtitle3Style.copyWith(
                          color: periodChangeColor,
                        ),
                      ),
                      const SpaceW10(),
                      Text(
                        'Today',
                        style: sBodyText2Style.copyWith(
                          color: colors.grey3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          BalanceChart(
            onCandleSelected: (ChartInfoModel? chartInfo) {
              chartN.updateSelectedCandle(chartInfo?.right);
            },
            walletCreationDate: clientDetail.walletCreationDate,
          ),
          const SpaceH76(),
          SPaddingH24(
            child: Row(
              children: [
                Text(
                  'Portfolio',
                  style: sTextH4Style,
                ),
                const Spacer(),
                SvgPicture.asset(
                  indexHistoryImageAsset,
                ),
              ],
            ),
          ),
          const SpaceH15(),
          SizedBox(
            height: 300,
            child: TabBarView(
              children: [
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: Column(
                    children: [
                      for (final item in itemsWithBalance)
                        SWalletItem(
                          decline: item.dayPercentChange.isNegative,
                          icon: SNetworkSvg24(
                            url: item.iconUrl,
                          ),
                          primaryText: item.description,
                          amount: formatCurrencyAmount(
                            prefix: baseCurrency.prefix,
                            value: item.baseBalance,
                            symbol: baseCurrency.symbol,
                            accuracy: baseCurrency.accuracy,
                          ),
                          secondaryText: '${item.assetBalance} ${item.symbol}',
                          onTap: () => navigateToWallet(context, item),
                          removeDivider: item == itemsWithBalance.last,
                        ),
                      if (showZeroBalanceWallets.state)
                        for (final item in itemsWithoutBalance)
                          SWalletItem(
                            decline: item.dayPercentChange.isNegative,
                            icon: SNetworkSvg24(
                              url: item.iconUrl,
                            ),
                            primaryText: item.description,
                            amount: formatCurrencyAmount(
                              prefix: baseCurrency.prefix,
                              value: item.baseBalance,
                              symbol: baseCurrency.symbol,
                              accuracy: baseCurrency.accuracy,
                            ),
                            secondaryText:
                                '${item.assetBalance} ${item.symbol}',
                            onTap: () => navigateToWallet(context, item),
                            color: colors.black,
                            removeDivider: item == itemsWithoutBalance.last,
                          ),
                      if (!zeroBalanceWalletsEmpty(itemsWithoutBalance))
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 27.5,
                          ),
                          child: Center(
                            child: InkWell(
                              splashColor: Colors.transparent,
                              onTap: () => showZeroBalanceWallets.state =
                                  !showZeroBalanceWallets.state,
                              child: Text(
                                showZeroBalanceWallets.state
                                    ? 'Hide zero wallets'
                                    : 'Show all wallets',
                                style: sBodyText2Style,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: Column(
                    children: [
                      for (final item in cryptosWithBalance)
                        SWalletItem(
                          decline: item.dayPercentChange.isNegative,
                          icon: SNetworkSvg24(
                            url: item.iconUrl,
                          ),
                          primaryText: item.description,
                          amount: formatCurrencyAmount(
                            prefix: baseCurrency.prefix,
                            value: item.baseBalance,
                            symbol: baseCurrency.symbol,
                            accuracy: baseCurrency.accuracy,
                          ),
                          secondaryText: '${item.assetBalance} ${item.symbol}',
                          onTap: () => navigateToWallet(context, item),
                          removeDivider: item == cryptosWithBalance.last,
                        ),
                      if (showZeroBalanceWallets.state)
                        for (final item in cryptosWithoutBalance)
                          SWalletItem(
                            decline: item.dayPercentChange.isNegative,
                            icon: SNetworkSvg24(
                              url: item.iconUrl,
                            ),
                            primaryText: item.description,
                            amount: formatCurrencyAmount(
                              prefix: baseCurrency.prefix,
                              value: item.baseBalance,
                              symbol: baseCurrency.symbol,
                              accuracy: baseCurrency.accuracy,
                            ),
                            secondaryText:
                            '${item.assetBalance} ${item.symbol}',
                            onTap: () => navigateToWallet(context, item),
                            color: colors.black,
                            removeDivider: item == itemsWithoutBalance.last,
                          ),
                      if (!zeroBalanceWalletsEmpty(itemsWithoutBalance))
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 27.5,
                          ),
                          child: Center(
                            child: InkWell(
                              splashColor: Colors.transparent,
                              onTap: () => showZeroBalanceWallets.state =
                              !showZeroBalanceWallets.state,
                              child: Text(
                                showZeroBalanceWallets.state
                                    ? 'Hide zero wallets'
                                    : 'Show all wallets',
                                style: sBodyText2Style,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: Column(
                    children: [
                      for (final item in indicesWithBalance)
                        SWalletItem(
                          decline: item.dayPercentChange.isNegative,
                          icon: SNetworkSvg24(
                            url: item.iconUrl,
                          ),
                          primaryText: item.description,
                          amount: formatCurrencyAmount(
                            prefix: baseCurrency.prefix,
                            value: item.baseBalance,
                            symbol: baseCurrency.symbol,
                            accuracy: baseCurrency.accuracy,
                          ),
                          secondaryText: '${item.assetBalance} ${item.symbol}',
                          onTap: () => navigateToWallet(context, item),
                          removeDivider: item == indicesWithBalance.last,
                        ),
                      if (showZeroBalanceWallets.state)
                        for (final item in indicesWithoutBalance)
                          SWalletItem(
                            decline: item.dayPercentChange.isNegative,
                            icon: SNetworkSvg24(
                              url: item.iconUrl,
                            ),
                            primaryText: item.description,
                            amount: formatCurrencyAmount(
                              prefix: baseCurrency.prefix,
                              value: item.baseBalance,
                              symbol: baseCurrency.symbol,
                              accuracy: baseCurrency.accuracy,
                            ),
                            secondaryText:
                            '${item.assetBalance} ${item.symbol}',
                            onTap: () => navigateToWallet(context, item),
                            color: colors.black,
                            removeDivider: item == indicesWithoutBalance.last,
                          ),
                      if (!zeroBalanceWalletsEmpty(indicesWithoutBalance))
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 27.5,
                          ),
                          child: Center(
                            child: InkWell(
                              splashColor: Colors.transparent,
                              onTap: () => showZeroBalanceWallets.state =
                              !showZeroBalanceWallets.state,
                              child: Text(
                                showZeroBalanceWallets.state
                                    ? 'Hide zero wallets'
                                    : 'Show all wallets',
                                style: sBodyText2Style,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: Column(
                    children: [
                      for (final item in fiatsWithBalance)
                        SWalletItem(
                          decline: item.dayPercentChange.isNegative,
                          icon: SNetworkSvg24(
                            url: item.iconUrl,
                          ),
                          primaryText: item.description,
                          amount: formatCurrencyAmount(
                            prefix: baseCurrency.prefix,
                            value: item.baseBalance,
                            symbol: baseCurrency.symbol,
                            accuracy: baseCurrency.accuracy,
                          ),
                          secondaryText: '${item.assetBalance} ${item.symbol}',
                          onTap: () => navigateToWallet(context, item),
                          removeDivider: item == fiatsWithBalance.last,
                        ),
                      if (showZeroBalanceWallets.state)
                        for (final item in fiatsWithoutBalance)
                          SWalletItem(
                            decline: item.dayPercentChange.isNegative,
                            icon: SNetworkSvg24(
                              url: item.iconUrl,
                            ),
                            primaryText: item.description,
                            amount: formatCurrencyAmount(
                              prefix: baseCurrency.prefix,
                              value: item.baseBalance,
                              symbol: baseCurrency.symbol,
                              accuracy: baseCurrency.accuracy,
                            ),
                            secondaryText:
                            '${item.assetBalance} ${item.symbol}',
                            onTap: () => navigateToWallet(context, item),
                            color: colors.black,
                            removeDivider: item == fiatsWithoutBalance.last,
                          ),
                      if (!zeroBalanceWalletsEmpty(fiatsWithoutBalance))
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 27.5,
                          ),
                          child: Center(
                            child: InkWell(
                              splashColor: Colors.transparent,
                              onTap: () => showZeroBalanceWallets.state =
                              !showZeroBalanceWallets.state,
                              child: Text(
                                showZeroBalanceWallets.state
                                    ? 'Hide zero wallets'
                                    : 'Show all wallets',
                                style: sBodyText2Style,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _price(
    ChartState chart,
    List<CurrencyModel> items,
    BaseCurrencyModel baseCurrency,
  ) {
    var totalBalance = 0.0;
    for (final item in items) {
      totalBalance += item.baseBalance;
    }

    if (chart.selectedCandle != null) {
      return formatCurrencyAmount(
        prefix: baseCurrency.prefix,
        value: chart.selectedCandle!.close,
        accuracy: baseCurrency.accuracy,
        symbol: baseCurrency.symbol,
      );
    } else {
      return formatCurrencyAmount(
        prefix: baseCurrency.prefix,
        value: totalBalance,
        accuracy: baseCurrency.accuracy,
        symbol: baseCurrency.symbol,
      );
    }
  }

  String _periodChange(
    ChartState chart,
    BaseCurrencyModel baseCurrency,
  ) {
    if (chart.selectedCandle != null) {
      return periodChange(
        chart: chart,
        selectedCandle: chart.selectedCandle,
        baseCurrency: baseCurrency,
      );
    } else {
      return periodChange(
        chart: chart,
        baseCurrency: baseCurrency,
      );
    }
  }
}
