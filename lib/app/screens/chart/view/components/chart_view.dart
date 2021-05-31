import 'package:charts/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/charts_init_fpod.dart';
import '../../providers/charts_notipod.dart';
import 'loading_chart_view.dart';

class ChartView extends HookWidget {
  const ChartView(this.instrumentId);

  final String instrumentId;

  @override
  Widget build(BuildContext context) {
    final initCharts = useProvider(chartsInitFpod(instrumentId));
    final chartsNotifier = useProvider(chartNotipod.notifier);
    final chartsState = useProvider(chartNotipod);

    return initCharts.when(
      data: (data) {
        return chartsState.union.when(
          candles: () => Chart(
            onResolutionChanged: (resolution) =>
                chartsNotifier.fetchCandles(resolution, instrumentId),
            candles: chartsState.candles,
          ),
          loading: () => LoadingChartView(),
          error: (String error) => Center(
            child: Text(error),
          ),
        );
      },
      loading: () => LoadingChartView(),
      error: (_, __) => const Text('Error'),
    );
  }
}
