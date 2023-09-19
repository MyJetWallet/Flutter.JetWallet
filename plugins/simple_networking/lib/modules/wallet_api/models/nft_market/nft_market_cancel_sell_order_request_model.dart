import 'package:freezed_annotation/freezed_annotation.dart';

part 'nft_market_cancel_sell_order_request_model.freezed.dart';
part 'nft_market_cancel_sell_order_request_model.g.dart';

@freezed
class NftMarketCancelSellOrderRequestModel
    with _$NftMarketCancelSellOrderRequestModel {
  factory NftMarketCancelSellOrderRequestModel({
    final String? symbol,
  }) = _NftMarketCancelSellOrderRequestModel;

  factory NftMarketCancelSellOrderRequestModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$NftMarketCancelSellOrderRequestModelFromJson(json);
}
