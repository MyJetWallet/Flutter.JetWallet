import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/chart/model/chart_state.dart';
import 'package:jetwallet/features/chart/store/chart_store.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:jetwallet/utils/models/base_currency_model/base_currency_model.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../helper/period_change.dart';

class AssetDayChange extends StatelessObserverWidget {
  const AssetDayChange({
    Key? key,
    required this.marketItem,
  }) : super(key: key);

  final MarketItemModel marketItem;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    final chart = ChartStore.of(context);
    final baseCurrency = sSignalRModules.baseCurrency;
    final periodChange = _periodChange(
      ChartState(
        selectedCandle: chart.selectedCandle,
        candles: chart.candles,
        type: chart.type,
        resolution: chart.resolution,
        union: chart.union,
      ),
      marketItem,
      baseCurrency,
    );

    return SizedBox(
      height: 24,
      child: Baseline(
        baseline: 24,
        baselineType: TextBaseline.alphabetic,
        child: Text(
          periodChange[0] + ' ' + periodChange[1],
          style: sSubtitle3Style.copyWith(
            color: periodChange[0].contains('-') ? colors.red : colors.green,
          ),
        ),
      ),
    );
  }

  List<String> _periodChange(
    ChartState chartState,
    MarketItemModel marketItem,
    BaseCurrencyModel baseCurrency,
  ) {
    return chartState.selectedCandle != null
        ? periodChange(
            chart: chartState,
            selectedCandle: chartState.selectedCandle,
            baseCurrency: baseCurrency,
            marketItem: marketItem,
          )
        : periodChange(
            chart: chartState,
            baseCurrency: baseCurrency,
            marketItem: marketItem,
          );
  }
}
