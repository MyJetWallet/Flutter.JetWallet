import 'package:charts/entity/candle_model.dart';

import '../../../../../service/shared/constants.dart';
import '../../chart/notifier/chart_state.dart';

String averagePeriodPrice({
  required ChartState chart,
  CandleModel? selectedCandle,
}) {
  if (chart.candles.isNotEmpty) {
    return '\$${((chart.candles.first.close +
        (selectedCandle?.close ?? chart.candles.last.close)) / 2)
        .toStringAsFixed(signsAfterComma)}';
  } else {
    return '';
  }
}
