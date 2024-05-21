import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';

part 'market_item_model.freezed.dart';
part 'market_item_model.g.dart';

@freezed
class MarketItemModel with _$MarketItemModel {
  const factory MarketItemModel({
    String? prefixSymbol,
    required String symbol,
    required String name,
    required String iconUrl,
    required String associateAsset,
    required String associateAssetPair,
    required int weight,
    required double dayPercentChange,
    required String startMarketTime,
    required AssetType type,
    required Decimal lastPrice,
    required Decimal dayPriceChange,
    required Decimal assetBalance,
    required Decimal baseBalance,
    required int assetAccuracy,
    required int priceAccuracy,
  }) = _MarketItemModel;

  factory MarketItemModel.empty() => MarketItemModel(
        assetBalance: Decimal.zero,
        baseBalance: Decimal.zero,
        dayPriceChange: Decimal.zero,
        symbol: '',
        name: '',
        iconUrl: '',
        associateAsset: '',
        associateAssetPair: '',
        weight: 1,
        dayPercentChange: 0,
        startMarketTime: '',
        type: AssetType.crypto,
        lastPrice: Decimal.zero,
        assetAccuracy: 0,
        priceAccuracy: 0,
      );

  factory MarketItemModel.fromJson(Map<String, dynamic> json) => _$MarketItemModelFromJson(json);

  const MarketItemModel._();

  bool get isGrowing => dayPercentChange > 0;

  bool get isBalanceEmpty => baseBalance == Decimal.zero;
}
