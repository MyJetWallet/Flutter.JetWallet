import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'indices_model.freezed.dart';
part 'indices_model.g.dart';

@freezed
class IndicesModel with _$IndicesModel {
  const factory IndicesModel({
    required double now,
    @JsonKey(name: 'indexDetails') required List<IndexModel> indices,
  }) = _IndicesModel;

  factory IndicesModel.fromJson(Map<String, dynamic> json) => _$IndicesModelFromJson(json);
}

@freezed
class IndexModel with _$IndexModel {
  const factory IndexModel({
    required String symbol,
    required List<BasketAssetModel> basketAssets,
  }) = _IndexModel;

  factory IndexModel.fromJson(Map<String, dynamic> json) => _$IndexModelFromJson(json);
}

@freezed
class BasketAssetModel with _$BasketAssetModel {
  const factory BasketAssetModel({
    required String symbol,
    @DecimalSerialiser() required Decimal volume,
    required String priceInstrumentSymbol,
    required bool directInstrumentPrice,
    @DecimalSerialiser() required Decimal targetRebalanceWeight,
  }) = _BasketAssetModel;

  factory BasketAssetModel.fromJson(Map<String, dynamic> json) => _$BasketAssetModelFromJson(json);
}
