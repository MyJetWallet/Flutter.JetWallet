import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_prices_model.freezed.dart';
part 'base_prices_model.g.dart';

@freezed
class BasePricesModel with _$BasePricesModel {
  const factory BasePricesModel({
    @JsonKey(name: 'P') required List<BasePriceModel> prices,
  }) = _BasePricesModel;

  factory BasePricesModel.fromJson(Map<String, dynamic> json) =>
      _$BasePricesModelFromJson(json);
}

@freezed
class BasePriceModel with _$BasePriceModel {
  const factory BasePriceModel({
    @JsonKey(name: 'T') @Default(0.0) double time,
    @JsonKey(name: 'P') @Default(0.0) double currentPrice,
    @JsonKey(name: 'P24a') @Default(0.0) double dayPriceChange,
    @JsonKey(name: 'P24p') @Default(0.0) double dayPercentChange,
    @JsonKey(name: 'S') required String assetSymbol,
  }) = _PeriodPriceModel;

  factory BasePriceModel.fromJson(Map<String, dynamic> json) =>
      _$BasePriceModelFromJson(json);
}
