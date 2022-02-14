import 'package:charts/main.dart';
import 'package:charts/simple_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../screens/market/model/market_item_model.dart';
import '../../../helpers/formatting/base/market_format.dart';
import '../notifier/chart_notipod.dart';

class AssetChart extends StatefulHookWidget {
  const AssetChart(
    this.marketItem,
    this.onCandleSelected,
  );

  final MarketItemModel marketItem;
  final void Function(ChartInfoModel?) onCandleSelected;

  @override
  State<StatefulWidget> createState() => _AssetChartState();
}

class _AssetChartState extends State<AssetChart>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final chartNotifier = useProvider(
      chartNotipod(widget.marketItem.associateAssetPair).notifier,
    );
    final chartState = useProvider(
      chartNotipod(widget.marketItem.associateAssetPair),
    );

    return chartState.union.when(
      candles: () {
        return Chart(
          onResolutionChanged: (resolution) {
            chartNotifier.updateResolution(
              resolution,
            );
          },
          onChartTypeChanged: (type) {
            chartNotifier.updateChartType(type);
          },
          chartType: chartState.type,
          candleResolution: chartState.resolution,
          formatPrice: marketFormat,
          candles: chartState.candles[chartState.resolution],
          onCandleSelected: widget.onCandleSelected,
          chartHeight: 240,
          chartWidgetHeight: 297,
          isAssetChart: true,
          walletCreationDate: widget.marketItem.startMarketTime,
          loader: const LoaderSpinner(),
        );
      },
      loading: () => LoadingChartView(
        height: 297,
        showLoader: true,
        resolution: chartState.resolution,
        onResolutionChanged: (resolution) {
          chartNotifier.updateResolution(resolution);
        },
        loader: const LoaderSpinner(),
        isBalanceChart: false,
      ),
      error: (String error) {
        return Center(
          child: Text(error),
        );
      },
    );
  }
}
