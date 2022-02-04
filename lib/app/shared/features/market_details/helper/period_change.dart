import 'package:charts/simple_chart.dart';
import 'package:decimal/decimal.dart';

import '../../../../../service/shared/constants.dart';
import '../../../../screens/market/model/market_item_model.dart';
import '../../../helpers/formatting/formatting.dart';
import '../../../providers/base_currency_pod/base_currency_model.dart';
import '../../chart/notifier/chart_state.dart';
import 'percent_change.dart';

String periodChange({
  CandleModel? selectedCandle,
  MarketItemModel? marketItem,
  required ChartState chart,
  required BaseCurrencyModel baseCurrency,
}) {
  if (chart.candles.isNotEmpty) {
    final firstPrice = chart.candles[chart.resolution]!.first.close;
    final lastPrice =
        selectedCandle?.close ?? chart.candles[chart.resolution]!.last.close;
    final periodPriceChange = lastPrice - firstPrice;
    final periodPercentChange = percentChangeBetween(firstPrice, lastPrice);

    var periodPercentChangeString = '';
    if (periodPercentChange.isFinite) {
      periodPercentChangeString =
          '(${periodPercentChange.toStringAsFixed(signsAfterComma)}%)';
    }

    if (marketItem != null) {
      return '${marketFormat(
        prefix: baseCurrency.prefix,
        // TODO migrate candles to decimal
        decimal: Decimal.parse(periodPriceChange.toString()),
        accuracy: marketItem.priceAccuracy,
        symbol: baseCurrency.symbol,
      )} $periodPercentChangeString';
    } else {
      return '${volumeFormat(
        prefix: baseCurrency.prefix,
        // TODO migrate candles to decimal
        decimal: Decimal.parse(periodPriceChange.toString()),
        accuracy: baseCurrency.accuracy,
        symbol: baseCurrency.symbol,
      )} $periodPercentChangeString';
    }
  } else {
    return '';
  }
}
