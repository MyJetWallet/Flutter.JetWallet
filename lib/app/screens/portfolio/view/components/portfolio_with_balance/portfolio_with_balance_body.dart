import 'package:charts/entity/chart_info.dart';
import 'package:charts/entity/resolution_string_enum.dart';
import 'package:charts/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jetwallet/app/screens/market/model/market_item_model.dart';
import 'package:jetwallet/app/screens/market/provider/market_items_pod.dart';
import 'package:jetwallet/app/screens/portfolio/view/components/portfolio_with_balance/components/portfolio_item.dart';
import 'package:jetwallet/app/shared/features/chart/notifier/chart_notipod.dart';
import 'package:jetwallet/app/shared/features/chart/notifier/chart_state.dart';
import 'package:jetwallet/app/shared/features/chart/view/asset_chart.dart';
import 'package:jetwallet/app/shared/features/chart/view/balance_chart.dart';
import 'package:jetwallet/app/shared/features/market_details/helper/average_period_change.dart';
import 'package:jetwallet/app/shared/features/market_details/helper/average_period_price.dart';
import 'package:jetwallet/app/shared/features/wallet/helper/assets_with_balance_from.dart';
import 'package:jetwallet/app/shared/features/wallet/provider/wallet_hidden_stpod.dart';
import 'package:jetwallet/shared/components/header_text.dart';
import 'package:jetwallet/shared/components/spacers.dart';

class PortfolioWithBalanceBody extends HookWidget {
  const PortfolioWithBalanceBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = assetsWithBalanceFrom(useProvider(marketItemsPod));
    final chartN = useProvider(chartNotipod.notifier);
    final chart = useProvider(chartNotipod);
    final hidden = useProvider(walletHiddenStPod);

    items.sort((a, b) => b.baseBalance.compareTo(a.baseBalance));

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          children: [
            Text(
              hidden.state ? 'HIDDEN' : _price(chart, items),
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
            for (final item in items)
              PortfolioItem(assetId: item.associateAsset)
          ],
        ),
      ),
    );
  }

  String _price(
    ChartState chart,
    List<MarketItemModel> items,
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
