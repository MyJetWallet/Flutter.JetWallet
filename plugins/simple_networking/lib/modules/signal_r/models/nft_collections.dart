import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'nft_collections.freezed.dart';
part 'nft_collections.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class NftCollections with _$NftCollections {
  const factory NftCollections({
    required double now,
    required List<NftCollection> collection,
  }) = _NftCollections;

  factory NftCollections.fromJson(Map<String, dynamic> json) => _$NftCollectionsFromJson(json);
}

@freezed
class NftCollection with _$NftCollection {
  factory NftCollection({
    final List<String>? tags,
    final int? category,
    final String? id,
    final String? name,
    final String? description,
    final String? sImage,
    final String? fImage,
    @DecimalNullSerialiser() Decimal? totalVolumeUsd,
    @DecimalNullSerialiser() Decimal? bestOffer,
    final String? bestOfferAsset,
    final int? ownerCount,
    final int? order,
  }) = _NftCollection;

  factory NftCollection.fromJson(Map<String, dynamic> json) => _$NftCollectionFromJson(json);
}
