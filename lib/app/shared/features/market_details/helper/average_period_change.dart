import 'package:charts/entity/candle_model.dart';

import '../../../../../service/shared/constants.dart';

import '../../chart/notifier/chart_state.dart';
import 'percent_change.dart';

String averagePeriodChange({
  required ChartState chart,
  CandleModel? selectedCandle,
}) {
  if (chart.candles.isNotEmpty) {
    final firstPrice = chart.candles.first.close;
    final lastPrice = selectedCandle?.close ?? chart.candles.last.close;
    final periodPriceChange = lastPrice - firstPrice;
    final periodPercentChange = percentChangeBetween(firstPrice, lastPrice);

    return '\$${periodPriceChange.toStringAsFixed(signsAfterComma)} '
        '(${periodPercentChange.toStringAsFixed(signsAfterComma)}%)';
  } else {
    return '';
  }
}
