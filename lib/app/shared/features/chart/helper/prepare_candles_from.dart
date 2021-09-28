import 'package:charts/entity/candle_model.dart';

List<CandleModel> candlesFrom(Map<String, double> walletHistory) {
  final candles = <CandleModel>[];
  walletHistory.forEach((date, price) {
    candles.add(
      CandleModel(
        open: price,
        high: price,
        low: price,
        close: price,
        date: DateTime.parse(date).millisecondsSinceEpoch,
      ),
    );
  });

  return candles;
}
