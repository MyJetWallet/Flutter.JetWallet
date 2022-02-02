import 'package:charts/main.dart';
import 'package:charts/simple_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../screens/market/model/market_item_model.dart';
import '../notifier/chart_notipod.dart';
import '../provider/asset_chart_init_fpod.dart';
import 'components/loading_chart_view.dart';

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
    final initCharts = useProvider(
      assetChartInitFpod(
        widget.marketItem.associateAssetPair,
      ),
    );
    final chartNotifier = useProvider(
      chartNotipod.notifier,
    );
    final chartState = useProvider(
      chartNotipod,
    );

    return initCharts.when(
      data: (_) {
        return chartState.union.when(
          candles: () {
            return Chart(
              onResolutionChanged: (resolution) {
                chartNotifier.fetchAssetCandles(
                  resolution,
                  widget.marketItem.associateAssetPair,
                );
              },
              onChartTypeChanged: (type) {
                chartNotifier.updateChartType(type);
              },
              chartType: chartState.type,
              candleResolution: chartState.resolution,
              candles: chartState.candles[chartState.resolution]!,
              onCandleSelected: widget.onCandleSelected,
              chartHeight: 240,
              chartWidgetHeight: 336,
              isAssetChart: true,
              walletCreationDate: widget.marketItem.startMarketTime,
            );
          },
          loading: () => const LoadingChartView(
            height: 336,
            showLoader: false,
          ),
          error: (String error) {
            return Center(
              child: Text(error),
            );
          },
        );
      },
      loading: () => const LoadingChartView(
        height: 336,
        showLoader: true,
      ),
      error: (_, __) => const LoadingChartView(
        height: 336,
        showLoader: false,
      ),
    );
  }
}
