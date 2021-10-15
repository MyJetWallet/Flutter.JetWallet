import 'package:charts/entity/chart_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../shared/components/header_text.dart';
import '../../../../../../shared/components/spacers.dart';
import '../../../../../../shared/helpers/currencies_with_balance_from.dart';
import '../../../../../shared/features/chart/notifier/chart_notipod.dart';
import '../../../../../shared/features/chart/notifier/chart_state.dart';
import '../../../../../shared/features/chart/view/balance_chart.dart';
import '../../../../../shared/features/market_details/helper/period_change.dart';
import '../../../../../shared/features/wallet/provider/wallet_hidden_stpod.dart';
import '../../../../../shared/helpers/format_currency_amount.dart';
import '../../../../../shared/models/currency_model.dart';
import '../../../../../shared/providers/base_currency_pod/base_currency_model.dart';
import '../../../../../shared/providers/base_currency_pod/base_currency_pod.dart';
import '../../../../../shared/providers/currencies_pod/currencies_pod.dart';
import '../../../helper/currencies_without_balance_from.dart';
import '../../../helper/zero_balance_wallets_empty.dart';
import '../../../provider/show_zero_balance_wallets_stpod.dart';
import 'components/portfolio_item.dart';
import 'components/portfolio_small_text.dart';

class PortfolioWithBalanceBody extends HookWidget {
  const PortfolioWithBalanceBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencies = useProvider(currenciesPod);
    final itemsWithBalance = currenciesWithBalanceFrom(currencies);
    final itemsWithoutBalance = currenciesWithoutBalanceFrom(currencies);
    final chartN = useProvider(chartNotipod.notifier);
    final chart = useProvider(chartNotipod);
    final hidden = useProvider(walletHiddenStPod);
    final showZeroBalanceWallets = useProvider(showZeroBalanceWalletsStpod);
    final baseCurrency = useProvider(baseCurrencyPod);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          children: [
            Text(
              hidden.state
                  ? 'HIDDEN'
                  : _price(
                      chart,
                      itemsWithBalance,
                      baseCurrency,
                    ),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 48.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              hidden.state
                  ? ''
                  : _periodChange(
                      chart,
                      baseCurrency,
                    ),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 0.35.sh,
              child: BalanceChart(
                onCandleSelected: (ChartInfo? chartInfo) {
                  chartN.updateSelectedCandle(chartInfo?.right);
                },
              ),
            ),
            const SpaceH15(),
            const SizedBox(
              width: double.infinity,
              child: HeaderText(
                text: 'My wallets',
                textAlign: TextAlign.start,
              ),
            ),
            const SpaceH15(),
            for (final item in itemsWithBalance)
              PortfolioItem(assetId: item.symbol),
            if (showZeroBalanceWallets.state)
              for (final item in itemsWithoutBalance)
                PortfolioItem(assetId: item.symbol),
            if (!zeroBalanceWalletsEmpty(itemsWithoutBalance))
              InkWell(
                onTap: () => showZeroBalanceWallets.state =
                    !showZeroBalanceWallets.state,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PortfolioSmallText(
                      text: showZeroBalanceWallets.state
                          ? 'Hide zero wallets'
                          : 'Show all wallets',
                    ),
                    const SpaceW4(),
                    Icon(
                      showZeroBalanceWallets.state
                          ? FontAwesomeIcons.chevronUp
                          : FontAwesomeIcons.chevronDown,
                      size: 12.r,
                      color: Colors.grey.shade500,
                    )
                  ],
                ),
              ),
          ],
        ),
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
