import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/chart/model/chart_state.dart';
import 'package:jetwallet/features/chart/store/chart_store.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/models/base_currency_model/base_currency_model.dart';
import 'package:simple_kit/simple_kit.dart';

class AssetPrice extends StatelessObserverWidget {
  const AssetPrice({
    super.key,
    required this.marketItem,
  });

  final MarketItemModel marketItem;

  @override
  Widget build(BuildContext context) {
    final chart = ChartStore.of(context);
    final baseCurrency = sSignalRModules.baseCurrency;

    final currency =
        sSignalRModules.getMarketPrices.firstWhere((element) => element.symbol == marketItem.associateAsset);

    return SizedBox(
      height: 40,
      child: Baseline(
        baseline: 40.5,
        baselineType: TextBaseline.alphabetic,
        child: Text(
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
          style: sTextH2Style,
        ),
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
}
