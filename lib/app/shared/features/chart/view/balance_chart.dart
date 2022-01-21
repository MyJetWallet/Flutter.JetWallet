import 'package:charts/main.dart';
import 'package:charts/simple_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/client_detail_pod/client_detail_pod.dart';
import '../notifier/chart_notipod.dart';
import '../provider/balance_chart_init_fpod.dart';

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
  late final AnimationController animationController = AnimationController(
    duration: const Duration(seconds: 4),
    vsync: this,
  );

  @override
  Widget build(BuildContext context) {
    final initChart = useProvider(balanceChartInitFpod(animationController));
    final chartNotifier =
        useProvider(chartNotipod(animationController).notifier);
    final chartState = useProvider(chartNotipod(animationController));
    final clientDetail = useProvider(clientDetailPod);

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
            candles: chartState.candles,
            onCandleSelected: widget.onCandleSelected,
            chartHeight: 200,
            chartWidgetHeight: 296,
            isAssetChart: false,
            animationController: animationController,
          ),
          loading: () => Chart(
            onResolutionChanged: (resolution) {
              chartNotifier.fetchBalanceCandles(resolution);
            },
            onChartTypeChanged: (type) {
              chartNotifier.updateChartType(type);
            },
            chartType: chartState.type,
            candleResolution: chartState.resolution,
            walletCreationDate: widget.walletCreationDate,
            candles: chartState.candles,
            onCandleSelected: widget.onCandleSelected,
            chartHeight: 200,
            chartWidgetHeight: 296,
            isAssetChart: false,
            animationController: animationController,
          ),
          error: (String error) {
            return Center(
              child: Text(error),
            );
          },
        );
      },
      loading: () => Chart(
        onResolutionChanged: (resolution) {
          chartNotifier.fetchBalanceCandles(resolution);
        },
        onChartTypeChanged: (type) {
          chartNotifier.updateChartType(type);
        },
        chartType: chartState.type,
        candleResolution: chartState.resolution,
        walletCreationDate: widget.walletCreationDate,
        candles: chartState.candles,
        onCandleSelected: widget.onCandleSelected,
        chartHeight: 200,
        chartWidgetHeight: 296,
        isAssetChart: false,
        animationController: animationController,
      ),
      error: (_, __) => const Text('Error'),
    );
  }
}
