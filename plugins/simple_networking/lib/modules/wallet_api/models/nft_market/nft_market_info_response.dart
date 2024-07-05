import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'nft_market_info_response.freezed.dart';
part 'nft_market_info_response.g.dart';

@freezed
class NftMarketInfoResponseModel with _$NftMarketInfoResponseModel {
  const factory NftMarketInfoResponseModel({
    required String? symbol,
    required String? contractAddress,
    required String? tokenId,
    required String? description,
    required String? name,
    @DecimalNullSerialiser() final Decimal? sellPrice,
    required String? sellAsset,
    required String? collectionId,
    required DateTime? ownerChangedAt,
    @DecimalNullSerialiser() final Decimal? buyPrice,
    required String? imageName,
    required String? shortUrl,
    required String? url,
    required String? buyAsset,
    @DecimalNullSerialiser() final Decimal? fee,
    required String? shortDescription,
  }) = _NftMarketInfoResponseModel;

  factory NftMarketInfoResponseModel.fromJson(Map<String, dynamic> json) => _$NftMarketInfoResponseModelFromJson(json);
}
