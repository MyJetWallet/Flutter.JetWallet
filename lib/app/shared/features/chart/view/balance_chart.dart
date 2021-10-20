import 'package:charts/entity/chart_info.dart';
import 'package:charts/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../notifier/chart_notipod.dart';
import '../provider/balance_chart_init_fpod.dart';
import 'components/loading_chart_view.dart';

class BalanceChart extends HookWidget {
  const BalanceChart({
    Key? key,
    required this.onCandleSelected,
    required this.walletCreationDate,
  }) : super(key: key);

  final void Function(ChartInfo?) onCandleSelected;
  final String walletCreationDate;

  @override
  Widget build(BuildContext context) {
    final initChart = useProvider(balanceChartInitFpod);
    final chartNotifier = useProvider(chartNotipod.notifier);
    final chartState = useProvider(chartNotipod);

    return initChart.when(
      data: (_) {
        return chartState.union.when(
          candles: () => Chart(
            onResolutionChanged: (resolution) {
              chartNotifier.fetchBalanceCandles(resolution);
            },
            onChartTypeChanged: (type) {
              chartNotifier.updateChartType(type);
            },
            chartType: chartState.type,
            candleResolution: chartState.resolution,
            walletCreationDate: walletCreationDate,
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
