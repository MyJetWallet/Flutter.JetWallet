import 'package:charts/components/loading_chart_view.dart';
import 'package:charts/main.dart';
import 'package:charts/simple_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/features/chart/store/chart_store.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:jetwallet/utils/formatting/base/market_format.dart';
import 'package:jetwallet/utils/helpers/localized_chart_resolution_button.dart';
import 'package:simple_kit/simple_kit.dart';

class AssetChart extends StatefulObserverWidget {
  const AssetChart({
    Key? key,
    required this.marketItem,
    required this.onCandleSelected,
  }) : super(key: key);

  final MarketItemModel marketItem;
  final void Function(ChartInfoModel?) onCandleSelected;

  @override
  State<AssetChart> createState() => _AssetChartState();
}

class _AssetChartState extends State<AssetChart>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final chartStore = ChartStore.of(context);
    final baseCurrency = sSignalRModules.baseCurrency;

    return chartStore.union.when(
      candles: () {
        return Chart(
          localizedChartResolutionButton:
              localizedChartResolutionButton(context),
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
          formatPrice: marketFormat,
          candles: chartStore.candles[chartStore.resolution],
          onCandleSelected: widget.onCandleSelected,
          chartHeight: 240,
          chartWidgetHeight: 297,
          isAssetChart: true,
          walletCreationDate: widget.marketItem.startMarketTime,
          loader: const LoaderSpinner(),
          prefix: baseCurrency.prefix ?? '',
        );
      },
      loading: () => LoadingChartView(
        height: 297,
        showLoader: true,
        resolution: chartStore.resolution,
        localizedChartResolutionButton: localizedChartResolutionButton(context),
        onResolutionChanged: (resolution) {
          chartStore.updateResolution(resolution);
        },
        loader: const LoaderSpinner(),
        isBalanceChart: false,
      ),
      error: (String error) {
        return Center(
          child: Text(error),
        );
      },
    );
  }
}
