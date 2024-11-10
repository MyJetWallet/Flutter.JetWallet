import 'package:charts/components/loading_chart_view.dart';
import 'package:charts/main.dart';
import 'package:charts/simple_chart.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/chart/store/chart_store.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:jetwallet/utils/formatting/base/decimal_extension.dart';
import 'package:jetwallet/utils/helpers/localized_chart_resolution_button.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class AssetChart extends StatefulObserverWidget {
  const AssetChart({
    super.key,
    required this.marketItem,
    required this.onCandleSelected,
  });

  final MarketItemModel marketItem;
  final void Function(ChartInfoModel?) onCandleSelected;

  @override
  State<AssetChart> createState() => _AssetChartState();
}

class _AssetChartState extends State<AssetChart> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final chartStore = ChartStore.of(context);
    final baseCurrency = sSignalRModules.baseCurrency;

    return chartStore.union.when(
      candles: () {
        return Chart(
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
          formatPrice: ({
            required int accuracy,
            required Decimal decimal,
            required bool onlyFullPart,
            required String symbol,
            required String prefix,
          }) {
            return decimal.toFormatPrice(
              accuracy: accuracy,
              prefix: prefix,
            );
          },
          candles: chartStore.candles[chartStore.resolution],
          onCandleSelected: widget.onCandleSelected,
          chartHeight: 240,
          chartWidgetHeight: 297,
          isAssetChart: true,
          walletCreationDate: widget.marketItem.startMarketTime,
          loader: const LoaderSpinner(),
          prefix: baseCurrency.prefix ?? '',
          accuracy: widget.marketItem.priceAccuracy,
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
