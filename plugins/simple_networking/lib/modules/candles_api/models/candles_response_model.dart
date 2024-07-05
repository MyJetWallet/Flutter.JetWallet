import 'package:freezed_annotation/freezed_annotation.dart';

part 'candles_response_model.freezed.dart';

@freezed
class CandlesResponseModel with _$CandlesResponseModel {
  const factory CandlesResponseModel({
    required List<CandleModel> candles,
  }) = _CandlesResponseModel;

  factory CandlesResponseModel.fromList(List<dynamic> list) {
    return CandlesResponseModel(
      candles: list.map((e) => CandleModel.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}

class CandleModel {
  CandleModel({
    this.open = 0.0,
    this.high = 0.0,
    this.low = 0.0,
    this.close = 0.0,
    this.date = 0,
  });

  CandleModel.fromJson(Map<String, dynamic> json) {
    open = (json['o'] as num).toDouble();
    high = (json['h'] as num).toDouble();
    low = (json['l'] as num).toDouble();
    close = (json['c'] as num).toDouble();
    date = (json['d'] as num).toInt();
  }

  late double open;
  late double high;
  late double low;
  late double close;
  late int date;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['open'] = open;
    data['close'] = close;
    data['high'] = high;
    data['low'] = low;
    data['date'] = date;

    return data;
  }

  @override
  String toString() {
    return 'CandleModel{open: $open, high: $high, low: $low, close: $close, '
        'date: $date}';
  }
}
