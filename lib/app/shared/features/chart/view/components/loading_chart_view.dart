import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../../../shared/components/loaders/loader.dart';

class LoadingChartView extends HookWidget {
  const LoadingChartView({
    Key? key,
    required this.chartHeight,
    required this.chartWidgetHeight,
    required this.isAssetChart,
    this.walletCreationDate,
  }) : super(key: key);

  final String? walletCreationDate;
  final double chartHeight;
  final double chartWidgetHeight;
  final bool isAssetChart;

  @override
  Widget build(BuildContext context) {
    // final chart = useProvider(chartNotipod(null));

    return Stack(
      children: [
        // Chart(
        //   onResolutionChanged: (_) {},
        //   onChartTypeChanged: (_) {},
        //   onCandleSelected: (_) {},
        //   candles: const [],
        //   candleResolution: chart.resolution,
        //   walletCreationDate: walletCreationDate,
        //   chartHeight: chartHeight,
        //   chartWidgetHeight: chartWidgetHeight,
        //   isAssetChart: isAssetChart,
        // ),
        const Loader(),
      ],
    );
  }
}
