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
    data['o'] = open;
    data['c'] = close;
    data['h'] = high;
    data['l'] = low;
    data['d'] = date;
    return data;
  }

  @override
  String toString() {
    return 'CandleModel{open: $open, high: $high, low: $low, close: $close, '
        'date: $date}';
  }
}

class CandlesWithIdModel {
  CandlesWithIdModel({
    this.instrumentId = '',
    this.candles = const [],
  });

  CandlesWithIdModel.fromJson(Map<String, dynamic> json) {
    var candleList = [];
    final doubleList = List.from([...json['candles'] as List<dynamic>]);

    candleList = doubleList.map((e) => CandleModel(
      open: e.open as double,
      close: e.close as double,
      high: e.high as double,
      low: e.low as double,
      date: e.date as int,
    )).toList();

    instrumentId = json['instrumentId'] as String;
    candles = candleList as List<CandleModel>;
  }


  late String instrumentId;
  late List<CandleModel> candles;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['instrumentId'] = instrumentId;
    data['candles'] = candles.toString();
    return data;
  }

  @override
  String toString() {
    return 'CandlesWithIdModel{instrumentId: $instrumentId, candles: $candles}';
  }
}
