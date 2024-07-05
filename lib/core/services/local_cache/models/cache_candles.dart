import 'package:charts/simple_chart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cache_candles.freezed.dart';
part 'cache_candles.g.dart';

@freezed
class CacheCandles with _$CacheCandles {
  factory CacheCandles({
    required List<CacheCandlesModel> data,
  }) = _CacheCandles;

  factory CacheCandles.fromJson(Map<String, dynamic> json) => _$CacheCandlesFromJson(json);
}

@freezed
class CacheCandlesModel with _$CacheCandlesModel {
  const factory CacheCandlesModel({
    required String asset,
    required Map<String, List<CandleModel>?> candle,
  }) = _CacheCandlesModel;

  factory CacheCandlesModel.fromJson(Map<String, dynamic> json) => _$CacheCandlesModelFromJson(json);
}
