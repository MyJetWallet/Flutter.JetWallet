import 'package:charts/components/loading_chart_view.dart';
import 'package:charts/main.dart';
import 'package:charts/simple_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/chart/model/chart_input.dart';
import 'package:jetwallet/features/chart/store/chart_store.dart';
import 'package:jetwallet/utils/formatting/base/market_format.dart';
import 'package:jetwallet/utils/helpers/localized_chart_resolution_button.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';

class BalanceChart extends StatefulObserverWidget {
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
    final chartStore = ChartStore.of(context);
    final baseCurrency = sSignalRModules.baseCurrency;

    return chartStore.union.when(
      candles: () => Chart(
        localizedChartResolutionButton: localizedChartResolutionButton(context),
        onResolutionChanged: (resolution) {
          chartStore.updateResolution(
            resolution,
          );
        },
        onChartTypeChanged: (type) {
          chartStore.updateChartType(type);
        },
        chartType: chartStore.type,
        candleResolution: chartStore.resolution,
        walletCreationDate: widget.walletCreationDate,
        candles: chartStore.candles[chartStore.resolution],
        onCandleSelected: widget.onCandleSelected,
        formatPrice: marketFormat,
        chartHeight: 100,
        chartWidgetHeight: 176,
        isAssetChart: false,
        loader: const LoaderSpinner(),
        prefix: baseCurrency.prefix ?? '',
      ),
      loading: () => LoadingChartView(
        height: 176,
        showLoader: true,
        resolution: chartStore.resolution,
        localizedChartResolutionButton: localizedChartResolutionButton(context),
        onResolutionChanged: (resolution) {
          chartStore.updateResolution(resolution);
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
