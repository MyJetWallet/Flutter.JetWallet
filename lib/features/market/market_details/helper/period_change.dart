import 'package:charts/model/candle_model.dart';
import 'package:decimal/decimal.dart';
import 'package:jetwallet/features/chart/model/chart_state.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/formatting/base/market_format.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/models/base_currency_model/base_currency_model.dart';
import 'percent_change.dart';

List<String> periodChange({
  CandleModel? selectedCandle,
  MarketItemModel? marketItem,
  required ChartState chart,
  required BaseCurrencyModel baseCurrency,
}) {
  if (chart.candles[chart.resolution] != null &&
      chart.candles[chart.resolution]!.isNotEmpty) {
    final firstPrice = chart.candles[chart.resolution]!.first.close;
    final lastPrice =
        selectedCandle?.close ?? chart.candles[chart.resolution]!.last.close;
    final periodPriceChange = lastPrice - firstPrice;
    final periodPercentChange = percentChangeBetween(firstPrice, lastPrice);

    var periodPercentChangeString = '';
    if (periodPercentChange.isFinite) {
      periodPercentChangeString =
          '''(${periodPercentChange >= 0 ? '+' : ''}${periodPercentChange.toStringAsFixed(signsAfterComma)}%)''';
    }

    return marketItem != null
        ? [
            marketFormat(
              prefix: baseCurrency.prefix,
              decimal: Decimal.parse(periodPriceChange.toString()),
              accuracy: marketItem.priceAccuracy,
              symbol: baseCurrency.symbol,
            ),
            periodPercentChangeString,
          ]
        : [
            volumeFormat(
              prefix: baseCurrency.prefix,
              decimal: Decimal.parse(periodPriceChange.toString()),
              accuracy: baseCurrency.accuracy,
              symbol: baseCurrency.symbol,
            ),
            periodPercentChangeString,
          ];
  } else {
    return ['', ''];
  }
}
