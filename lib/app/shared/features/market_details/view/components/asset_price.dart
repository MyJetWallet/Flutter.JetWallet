import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../screens/market/model/market_item_model.dart';
import '../../../../helpers/formatting/formatting.dart';
import '../../../../providers/base_currency_pod/base_currency_model.dart';
import '../../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../../chart/notifier/asset_chart_input_stpod.dart';
import '../../../chart/notifier/chart_notipod.dart';
import '../../../chart/notifier/chart_state.dart';

class AssetPrice extends HookWidget {
  const AssetPrice({
    Key? key,
    required this.marketItem,
  }) : super(key: key);

  final MarketItemModel marketItem;

  @override
  Widget build(BuildContext context) {
    final chart = useProvider(
      chartNotipod(
        useProvider(assetChartInputStpod(marketItem)).state,
      ),
    );
    final baseCurrency = useProvider(baseCurrencyPod);

    return SizedBox(
      height: 40,
      child: Baseline(
        baseline: 40.5,
        baselineType: TextBaseline.alphabetic,
        child: Text(
          _price(
            marketItem,
            chart,
            baseCurrency,
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
  ) {
    if (chart.selectedCandle != null) {
      return marketFormat(
        prefix: baseCurrency.prefix,
        // TODO migrate candles to decimal
        decimal: Decimal.parse(chart.selectedCandle!.close.toString()),
        accuracy: marketItem.priceAccuracy,
        symbol: baseCurrency.symbol,
      );
    } else {
      return marketFormat(
        prefix: baseCurrency.prefix,
        decimal: marketItem.lastPrice,
        accuracy: marketItem.priceAccuracy,
        symbol: baseCurrency.symbol,
      );
    }
  }
}
