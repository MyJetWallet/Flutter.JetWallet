import 'package:charts/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/chart_init_fpod.dart';
import '../../providers/chart_notipod.dart';
import 'loading_chart_view.dart';

class ChartView extends HookWidget {
  const ChartView(this.instrumentId);

  final String instrumentId;

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
            candles: chartState.candles,
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
