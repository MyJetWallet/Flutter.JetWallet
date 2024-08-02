import 'package:freezed_annotation/freezed_annotation.dart';

part 'market_references_model.freezed.dart';
part 'market_references_model.g.dart';

@freezed
class MarketReferencesModel with _$MarketReferencesModel {
  const factory MarketReferencesModel({
    required double now,
    required List<MarketReferenceModel> references,
  }) = _MarketReferencesModel;

  factory MarketReferencesModel.fromJson(Map<String, dynamic> json) => _$MarketReferencesModelFromJson(json);
}

@freezed
class MarketReferenceModel with _$MarketReferenceModel {
  const factory MarketReferenceModel({
    String? iconUrl,
    required String id,
    required String brokerId,
    required String name,
    required String associateAsset,
    required String associateAssetPair,
    required int weight,
    required int priceAccuracy,
    required String startMarketTime,
    required bool isMainNet,
    required MarketType type,
  }) = _MarketReferenceModel;

  factory MarketReferenceModel.fromJson(Map<String, dynamic> json) => _$MarketReferenceModelFromJson(json);
}

enum MarketType {
  @JsonValue(0)
  crypto,
  @JsonValue(1)
  indices,
  @JsonValue(2)
  fiat,
}
