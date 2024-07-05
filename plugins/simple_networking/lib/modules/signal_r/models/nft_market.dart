import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'nft_market.freezed.dart';
part 'nft_market.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class NFTMarkets with _$NFTMarkets {
  const factory NFTMarkets({
    required double now,
    required List<NftMarket> nfts,
  }) = _NFTMarkets;

  factory NFTMarkets.fromJson(Map<String, dynamic> json) => _$NFTMarketsFromJson(json);
}

@freezed
class NftMarket with _$NftMarket {
  factory NftMarket({
    final String? clientId,
    final String? contractAddress,
    final int? id,
    final String? name,
    final String? sellAsset,
    @DecimalNullSerialiser() Decimal? sellPrice,
    final String? symbol,
    final String? tokenId,
    final String? collectionId,
    @DecimalNullSerialiser() Decimal? buyPrice,
    final String? buyAsset,
    final DateTime? ownerChangedAt,
    final String? sImage,
    final String? fImage,
    final String? tradingAsset,
    @DecimalNullSerialiser() Decimal? fee,
    final DateTime? mintDate,
    final int? rarityId,
    final String? blockchain,
    final int? tokenStandard,
    final bool? onSell,
  }) = _NftMarket;

  factory NftMarket.fromJson(Map<String, dynamic> json) => _$NftMarketFromJson(json);
}
