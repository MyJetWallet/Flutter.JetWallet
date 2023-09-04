import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'nft_market_make_sell_order_request_model.freezed.dart';
part 'nft_market_make_sell_order_request_model.g.dart';

@freezed
class NftMarketMakeSellOrderRequestModel
    with _$NftMarketMakeSellOrderRequestModel {
  factory NftMarketMakeSellOrderRequestModel({
    final String? symbol,
    final String? sellAsset,
    @DecimalSerialiser() final Decimal? sellPrice,
  }) = _NftMarketMakeSellOrderRequestModel;

  factory NftMarketMakeSellOrderRequestModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$NftMarketMakeSellOrderRequestModelFromJson(json);
}
