import 'package:charts/entity/chart_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../shared/components/header_text.dart';
import '../../../../../../shared/components/spacers.dart';
import '../../../../../shared/features/chart/notifier/chart_notipod.dart';
import '../../../../../shared/features/chart/notifier/chart_state.dart';
import '../../../../../shared/features/chart/view/balance_chart.dart';
import '../../../../../shared/features/market_details/helper/average_period_change.dart';
import '../../../../../shared/features/market_details/helper/average_period_price.dart';
import '../../../../../shared/features/wallet/provider/wallet_hidden_stpod.dart';
import '../../../../../shared/models/currency_model.dart';
import '../../../../../shared/providers/currencies_pod/currencies_pod.dart';
import '../../../helpers/currencies_with_balance_from.dart';
import '../../../helpers/currencies_without_balance_from.dart';
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
    final showZeroBalanceWallets = useProvider(showZeroBalanceWalletsStPod);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          children: [
            Text(
              hidden.state ? 'HIDDEN' : _price(chart, itemsWithBalance),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 48.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              hidden.state ? '' : _dayChange(chart),
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
            InkWell(
              onTap: () =>
                  showZeroBalanceWallets.state = !showZeroBalanceWallets.state,
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
  ) {
    var totalBalance = 0.0;
    for (final item in items) {
      totalBalance += item.baseBalance;
    }

    if (chart.selectedCandle != null) {
      return averagePeriodPrice(
        chart: chart,
        selectedCandle: chart.selectedCandle,
      );
    } else {
      return '\$${totalBalance.toStringAsFixed(2)}';
    }
  }

  String _dayChange(
    ChartState chart,
  ) {
    if (chart.selectedCandle != null) {
      return averagePeriodChange(
        chart: chart,
        selectedCandle: chart.selectedCandle,
      );
    } else {
      return averagePeriodChange(chart: chart);
    }
  }
}
