import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_prices_model.freezed.dart';
part 'base_prices_model.g.dart';

@freezed
class BasePricesModel with _$BasePricesModel {
  const factory BasePricesModel({
    @JsonKey(name: 'priceRecords') required List<AssetPriceModel> basePrices,
  }) = _BasePricesModel;

  factory BasePricesModel.fromJson(Map<String, dynamic> json) =>
      _$BasePricesModelFromJson(json);
}

@freezed
class AssetPriceModel with _$AssetPriceModel {
  const factory AssetPriceModel({
    required String brokerId,
    required String assetSymbol,
    required double currentPrice,
    @JsonKey(name: 'h24P') required double dayPercentChange,
    @JsonKey(name: 'h24') required BasePriceModel dayPrice,
    @JsonKey(name: 'd7') required BasePriceModel weekPrice,
    @JsonKey(name: 'm1') required BasePriceModel monthPrice,
    @JsonKey(name: 'm3') required BasePriceModel threeMonthPrice,
  }) = _AssetPriceModel;

  factory AssetPriceModel.fromJson(Map<String, dynamic> json) =>
      _$AssetPriceModelFromJson(json);
}

@freezed
class BasePriceModel with _$BasePriceModel {
  const factory BasePriceModel({
    required double price,
    @JsonKey(name: 'recordTime') required String date,
  }) = _BasePriceModel;

  factory BasePriceModel.fromJson(Map<String, dynamic> json) =>
      _$BasePriceModelFromJson(json);
}
