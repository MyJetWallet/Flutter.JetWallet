import 'package:freezed_annotation/freezed_annotation.dart';

part 'nft_portfolio.freezed.dart';
part 'nft_portfolio.g.dart';

@freezed
class NftPortfolio with _$NftPortfolio {
  factory NftPortfolio({
    List<String>? nfts,
  }) = _NftPortfolio;

  factory NftPortfolio.fromJson(Map<String, dynamic> json) => _$NftPortfolioFromJson(json);
}
