import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/chart/model/chart_state.dart';
import 'package:jetwallet/features/chart/store/chart_store.dart';
import 'package:jetwallet/features/market/market_details/helper/period_change.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/models/base_currency_model/base_currency_model.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class PriceSectionWidget extends StatelessWidget {
  const PriceSectionWidget({
    super.key,
    required this.marketItem,
  });

  final MarketItemModel marketItem;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    final chart = ChartStore.of(context);
    final baseCurrency = sSignalRModules.baseCurrency;

    final currency =
        sSignalRModules.getMarketPrices.firstWhere((element) => element.symbol == marketItem.associateAsset);

    final periodChange = _periodChange(
      ChartState(
        selectedCandle: chart.selectedCandle,
        candles: chart.candles,
        type: chart.type,
        resolution: chart.resolution,
        union: chart.union,
      ),
      marketItem,
      baseCurrency,
    );

    return Container(
      padding: const EdgeInsets.only(
        top: 20,
        left: 24,
        right: 24,
        bottom: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              NetworkIconWidget(
                marketItem.iconUrl,
              ),
              const SizedBox(width: 8),
              Text(
                marketItem.symbol,
                style: STStyles.subtitle1,
              ),
            ],
          ),
          Text(
            _price(
              marketItem,
              ChartState(
                selectedCandle: chart.selectedCandle,
                candles: chart.candles,
                type: chart.type,
                resolution: chart.resolution,
                union: chart.union,
              ),
              baseCurrency,
              currency,
            ),
            style: STStyles.header2,
          ),
          Text(
            '${periodChange[0]} ${periodChange[1]}',
            style: STStyles.body2Medium.copyWith(
              color: periodChange[0].contains('-') ? colors.red : colors.green,
            ),
          ),
        ],
      ),
    );
  }

  String _price(
    MarketItemModel marketItem,
    ChartState chart,
    BaseCurrencyModel baseCurrency,
    MarketItemModel currency,
  ) {
    return chart.selectedCandle != null
        ? Decimal.parse(chart.selectedCandle!.close.toString()).toFormatPrice(
            accuracy: marketItem.priceAccuracy,
            prefix: baseCurrency.prefix,
          )
        : currency.lastPrice.toFormatPrice(
            prefix: baseCurrency.prefix,
            accuracy: currency.priceAccuracy,
          );
  }

  List<String> _periodChange(
    ChartState chartState,
    MarketItemModel marketItem,
    BaseCurrencyModel baseCurrency,
  ) {
    return chartState.selectedCandle != null
        ? periodChange(
            chart: chartState,
            selectedCandle: chartState.selectedCandle,
            baseCurrency: baseCurrency,
            marketItem: marketItem,
          )
        : periodChange(
            chart: chartState,
            baseCurrency: baseCurrency,
            marketItem: marketItem,
          );
  }
}
