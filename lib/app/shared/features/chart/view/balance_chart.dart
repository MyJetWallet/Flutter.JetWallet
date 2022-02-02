import 'package:charts/main.dart';
import 'package:charts/simple_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../notifier/chart_notipod.dart';
import '../provider/balance_chart_init_fpod.dart';
import 'components/loading_chart_view.dart';

class BalanceChart extends StatefulHookWidget {
  const BalanceChart({
    Key? key,
    required this.onCandleSelected,
    required this.walletCreationDate,
  }) : super(key: key);

  final void Function(ChartInfoModel?) onCandleSelected;
  final String walletCreationDate;

  @override
  State<StatefulWidget> createState() => _BalanceChartState();
}

class _BalanceChartState extends State<BalanceChart>
    with SingleTickerProviderStateMixin {
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
            walletCreationDate: widget.walletCreationDate,
            candles: chartState.candles[chartState.resolution]!,
            onCandleSelected: widget.onCandleSelected,
            chartHeight: 200,
            chartWidgetHeight: 296,
            isAssetChart: false,
          ),
          loading: () => const LoadingChartView(
            height: 296,
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
        height: 296,
        showLoader: true,
      ),
      error: (_, __) => const LoadingChartView(
        height: 296,
        showLoader: false,
      ),
    );
  }
}
