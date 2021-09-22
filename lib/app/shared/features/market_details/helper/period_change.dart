import 'package:charts/entity/candle_model.dart';

import '../../../../../service/shared/constants.dart';
import '../../../../screens/market/model/market_item_model.dart';
import '../../../helpers/format_asset_price_value.dart';
import '../../chart/notifier/chart_state.dart';
import 'percent_change.dart';

String periodChange({
  required ChartState chart,
  required MarketItemModel item,
  CandleModel? selectedCandle,
}) {
  if (chart.candles.isNotEmpty) {
    final firstPrice = chart.candles.first.close;
    final lastPrice = selectedCandle?.close ?? chart.candles.last.close;
    final periodPriceChange = lastPrice - firstPrice;
    final periodPercentChange = percentChangeBetween(firstPrice, lastPrice);

    return '${formatPriceValue(
      prefix: item.baseCurrencySymbol,
      value: num.parse(
        periodPriceChange.toStringAsFixed(
          item.baseCurrencyAccuracy,
        ),
      ),
      accuracy: item.baseCurrencyAccuracy,
    )} '
        '(${periodPercentChange.toStringAsFixed(signsAfterComma)}%)';
  } else {
    return '';
  }
}
