import 'package:charts/simple_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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

class PortfolioWithBalanceBody extends StatefulHookWidget {
  const PortfolioWithBalanceBody({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PortfolioWithBalanceBodyState();
}

class _PortfolioWithBalanceBodyState extends State<PortfolioWithBalanceBody>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final currencies = useProvider(currenciesPod);
    final itemsWithBalance = currenciesWithBalanceFrom(currencies);
    final itemsWithoutBalance = currenciesWithoutBalanceFrom(currencies);
    final chartN = useProvider(chartNotipod.notifier);
    final chart = useProvider(chartNotipod);
    final showZeroBalanceWallets = useProvider(showZeroBalanceWalletsStpod);
    final baseCurrency = useProvider(baseCurrencyPod);
    final clientDetail = useProvider(clientDetailPod);
    final periodChange = _periodChange(chart, baseCurrency);
    final periodChangeColor =
        periodChange.contains('-') ? colors.red : colors.green;

    return SingleChildScrollView(
      child: Stack(
        children: [
          Positioned(
            top: 100,
            child: SvgPicture.asset(
              periodChange.contains('-')
                  ? redPortfolioImageAsset
                  : greenPortfolioImageAsset,
              width: double.infinity,
              height: 528,
              fit: BoxFit.fill,
            ),
          ),
          Column(
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
              const SpaceH40(),
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  color: colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SpaceH36(),
                    PaddingL24(
                      child: Text(
                        'My wallets',
                        style: sTextH4Style,
                      ),
                    ),
                    const SpaceH15(),
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
                          secondaryText: '${item.assetBalance} ${item.symbol}',
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
            ],
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
