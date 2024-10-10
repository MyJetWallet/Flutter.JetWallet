import 'package:charts/simple_chart.dart';
import 'package:jetwallet/features/market/market_details/helper/percent_change.dart';
import 'package:jetwallet/utils/formatting/base/format_percent.dart';

double percentPriceCahange(List<CandleModel> candles) {
  if (candles.isNotEmpty) {
    final firstPrice = candles.first.close;
    final lastPrice = candles.last.close;

    final periodPercentChange = percentChangeBetween(firstPrice, lastPrice);

    return periodPercentChange;
  } else {
    return 0;
  }
}

String formatedPercentPriceCahange(List<CandleModel> candles) {
  final periodPercentChange = percentPriceCahange(candles);

  final formatedPercent = periodPercentChange.toFormatPercentPriceChange();

  return formatedPercent;
}
