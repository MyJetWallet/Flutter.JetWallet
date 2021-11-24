import 'package:charts/entity/chart_info.dart';
import 'package:charts/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../notifier/chart_notipod.dart';
import '../provider/asset_chart_init_fpod.dart';
import 'components/loading_chart_view.dart';

class AssetChart extends HookWidget {
  const AssetChart(
    this.instrumentId,
    this.onCandleSelected,
  );

  final String instrumentId;
  final void Function(ChartInfo?) onCandleSelected;

  @override
  Widget build(BuildContext context) {
    final initCharts = useProvider(assetChartInitFpod(instrumentId));
    final chartNotifier = useProvider(chartNotipod.notifier);
    final chartState = useProvider(chartNotipod);

    return initCharts.when(
      data: (_) {
        return chartState.union.when(
          candles: () => Chart(
            onResolutionChanged: (resolution) {
              chartNotifier.fetchAssetCandles(resolution, instrumentId);
            },
            onChartTypeChanged: (type) {
              chartNotifier.updateChartType(type);
            },
            chartType: chartState.type,
            candleResolution: chartState.resolution,
            candles: chartState.candles,
            onCandleSelected: onCandleSelected,
          ),
          loading: () => const LoadingChartView(),
          error: (String error) {
            return Center(
              child: Text(error),
            );
          },
        );
      },
      loading: () => const LoadingChartView(),
      error: (_, __) => const Text('Error'),
    );
  }
}
