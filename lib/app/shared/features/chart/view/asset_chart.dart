import 'package:charts/main.dart';
import 'package:charts/simple_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../notifier/chart_notipod.dart';
import '../provider/asset_chart_init_fpod.dart';
import 'components/loading_chart_view.dart';

class AssetChart extends StatefulHookWidget {
  const AssetChart(
    this.instrumentId,
    this.onCandleSelected,
  );

  final String instrumentId;
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
        widget.instrumentId,
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
                  widget.instrumentId,
                );
              },
              onChartTypeChanged: (type) {
                chartNotifier.updateChartType(type);
              },
              chartType: chartState.type,
              candleResolution: chartState.resolution,
              candles: chartState.candles[0]!,
              onCandleSelected: widget.onCandleSelected,
              chartHeight: 240,
              chartWidgetHeight: 336,
              isAssetChart: true,
            );
          },
          loading: () {
            return Chart(
              onResolutionChanged: (resolution) {
                chartNotifier.fetchAssetCandles(
                  resolution,
                  widget.instrumentId,
                );
              },
              onChartTypeChanged: (type) {
                chartNotifier.updateChartType(type);
              },
              chartType: chartState.type,
              candleResolution: chartState.resolution,
              candles: chartState.candles[0]!,
              onCandleSelected: widget.onCandleSelected,
              chartHeight: 240,
              chartWidgetHeight: 336,
              isAssetChart: true,
            );
          },
          error: (String error) {
            return Center(
              child: Text(error),
            );
          },
        );
      },
      loading: () => const LoadingChartView(
        chartHeight: 240,
        chartWidgetHeight: 336,
        isAssetChart: true,
      ),
      error: (_, __) => const Text('Error'),
    );
  }
}
