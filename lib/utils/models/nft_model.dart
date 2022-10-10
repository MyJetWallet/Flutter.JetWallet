import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/modules/signal_r/models/nft_market.dart';

part 'nft_model.freezed.dart';

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
  }) = _NftModel;
}

enum NftCollectionCategoryEnum {
  CelebsAndFanClubs,
  MusicAndArt,
  GamesAndMeaverse,
  Startup,
  ShopsClubsCafes
}
