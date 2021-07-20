import 'package:freezed_annotation/freezed_annotation.dart';

part 'market_item_model.freezed.dart';

@freezed
class MarketItemModel with _$MarketItemModel {
  const factory MarketItemModel({
    required String id,
    required String name,
    required String iconUrl,
    required String associateAsset,
    required String? associateAssetPair,
    required int weight,
    required double lastPrice,
    required double dayPercentChange,
  }) = _MarketItemModel;
}