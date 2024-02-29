import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'invest_base_daily_price_model.freezed.dart';
part 'invest_base_daily_price_model.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class InvestBaseDailyPriceModel with _$InvestBaseDailyPriceModel {
  const factory InvestBaseDailyPriceModel({
    required List<BaseDailyPrice> dailyPrices,
  }) = _InvestBaseDailyPriceModel;

  factory InvestBaseDailyPriceModel.fromJson(Map<String, dynamic> json) =>
      _$InvestBaseDailyPriceModelFromJson(json);
}

@freezed
class BaseDailyPrice with _$BaseDailyPrice {
  const factory BaseDailyPrice({
    String? symbol,
    @DecimalNullSerialiser() Decimal? price,
  }) = _BaseDailyPrice;

  factory BaseDailyPrice.fromJson(Map<String, dynamic> json) =>
      _$BaseDailyPriceFromJson(json);
}
