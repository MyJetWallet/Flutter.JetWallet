import 'package:freezed_annotation/freezed_annotation.dart';

part 'nft_market_buy_order_request_model.freezed.dart';
part 'nft_market_buy_order_request_model.g.dart';

@freezed
class NftMarketBuyOrderRequestModel with _$NftMarketBuyOrderRequestModel {
  factory NftMarketBuyOrderRequestModel({
    final String? requestId,
    final String? symbol,
    final String? promoCode,
  }) = _NftMarketBuyOrderRequestModel;

  factory NftMarketBuyOrderRequestModel.fromJson(Map<String, dynamic> json) =>
      _$NftMarketBuyOrderRequestModelFromJson(json);
}
