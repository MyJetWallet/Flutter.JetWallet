// ignore_for_file: constant_identifier_names

import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';
import 'package:simple_networking/modules/signal_r/models/nft_market.dart';

part 'nft_model.freezed.dart';
part 'nft_model.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class NftModel with _$NftModel {
  factory NftModel({
    String? id,
    String? name,
    String? description,
    NftCollectionCategoryEnum? category,
    @Default([]) List<String>? tags,
    @Default([]) List<NftMarket> nftList,
    String? sImage,
    String? fImage,
    @DecimalNullSerialiser() Decimal? totalVolumeUsd,
    @DecimalNullSerialiser() Decimal? bestOffer,
    String? bestOfferAsset,
    int? ownerCount,
    int? order,
  }) = _NftModel;

  factory NftModel.fromJson(Map<String, dynamic> json) =>
      _$NftModelFromJson(json);
}

enum NftCollectionCategoryEnum {
  CelebsAndFanClubs,
  MusicAndArt,
  GamesAndMeaverse,
  Startup,
  ShopsClubsCafes
}
