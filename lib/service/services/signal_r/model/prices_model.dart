import 'package:freezed_annotation/freezed_annotation.dart';

part 'prices_model.freezed.dart';
part 'prices_model.g.dart';

@freezed
class PricesModel with _$PricesModel {
  const factory PricesModel({
    required double now,
    required List<PriceModel> prices,
  }) = _PricesModel;

  factory PricesModel.fromJson(Map<String, dynamic> json) =>
      _$PricesModelFromJson(json);
}

@freezed
class PriceModel with _$PriceModel {
  const factory PriceModel({
    required String id,
    @JsonKey(name: 'dateTime') required double date,
    required double bid,
    required double ask,
    @JsonKey(name: 'last') required double lastPrice,
    @JsonKey(name: 'h24Perc') required double dayPercentageChange,
    @JsonKey(name: 'h24Abs') required double dayPriceChange,
  }) = _PriceModel;

  factory PriceModel.fromJson(Map<String, dynamic> json) =>
      _$PriceModelFromJson(json);
}
