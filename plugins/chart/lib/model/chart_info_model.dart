import 'candle_model.dart';

class ChartInfoModel {
  ChartInfoModel({
    required this.left,
    required this.right,
    required this.candleResolution,
  });

  CandleModel left;
  CandleModel right;
  String candleResolution;
}
