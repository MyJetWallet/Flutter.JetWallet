import 'package:charts/components/loading_chart_view.dart';
import 'package:charts/main.dart';
import 'package:charts/simple_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../helpers/formatting/base/market_format.dart';
import '../notifier/chart_notipod.dart';

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
    final chartNotifier = useProvider(chartNotipod(null).notifier);
    final chartState = useProvider(chartNotipod(null));

    return chartState.union.when(
      candles: () => Chart(
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
        walletCreationDate: widget.walletCreationDate,
        candles: chartState.candles[chartState.resolution],
        onCandleSelected: widget.onCandleSelected,
        formatPrice: marketFormat,
        chartHeight: 200,
        chartWidgetHeight: 296,
        isAssetChart: false,
        loader: const LoaderSpinner(),
      ),
      loading: () => LoadingChartView(
        height: 296,
        showLoader: true,
        resolution: chartState.resolution,
        onResolutionChanged: (resolution) {
          chartNotifier.updateResolution(resolution);
        },
        loader: const LoaderSpinner(),
        isBalanceChart: true,
      ),
      error: (String error) {
        return Center(
          child: Text(error),
        );
      },
    );
  }
}
