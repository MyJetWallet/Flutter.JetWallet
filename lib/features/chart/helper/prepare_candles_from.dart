import 'package:charts/simple_chart.dart';

List<CandleModel> candlesFrom(Map<String, double> walletHistory) {
  final candles = <CandleModel>[];

  walletHistory.forEach((date, price) {
    final localDate = date.contains('Z') ? date : '${date}Z';

    candles.add(
      CandleModel(
        open: price,
        high: price,
        low: price,
        close: price,
        date: DateTime.parse(localDate).toLocal().millisecondsSinceEpoch,
      ),
    );
  });

  return candles;
}
