import 'package:charts/simple_chart.dart';

import '../../../../../service/shared/constants.dart';
import '../../../helpers/format_currency_amount.dart';
import '../../../providers/base_currency_pod/base_currency_model.dart';
import '../../chart/notifier/chart_state.dart';
import 'percent_change.dart';

String periodChange({
  required ChartState chart,
  required BaseCurrencyModel baseCurrency,
  CandleModel? selectedCandle,
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

    return '${formatCurrencyAmount(
      prefix: baseCurrency.prefix,
      value: periodPriceChange,
      accuracy: baseCurrency.accuracy,
      symbol: baseCurrency.symbol,
    )} $periodPercentChangeString';
  } else {
    return '';
  }
}
