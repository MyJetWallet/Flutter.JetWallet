import 'package:charts/entity/chart_info.dart';
import 'package:charts/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../notifier/chart_notipod.dart';
import '../../provider/chart_init_fpod.dart';
import 'loading_chart_view.dart';

class ChartView extends HookWidget {
  const ChartView(
    this.instrumentId,
    this.onCandleSelected,
  );

  final String instrumentId;
  final void Function(ChartInfo?) onCandleSelected;

  @override
  Widget build(BuildContext context) {
    final initCharts = useProvider(chartInitFpod(instrumentId));
    final chartNotifier = useProvider(chartNotipod.notifier);
    final chartState = useProvider(chartNotipod);

    return initCharts.when(
      data: (data) {
        return chartState.union.when(
          candles: () => Chart(
            onResolutionChanged: (resolution) {
              chartNotifier.fetchCandles(resolution, instrumentId);
            },
            onChartTypeChanged: (type) {
              chartNotifier.updateChartType(type);
            },
            chartType: chartState.type,
            candleResolution: chartState.resolution,
            candles: chartState.candles,
            onCandleSelected: onCandleSelected,
          ),
          loading: () => LoadingChartView(),
          error: (String error) {
            return Center(
              child: Text(error),
            );
          },
        );
      },
      loading: () => LoadingChartView(),
      error: (_, __) => const Text('Error'),
    );
  }
}
