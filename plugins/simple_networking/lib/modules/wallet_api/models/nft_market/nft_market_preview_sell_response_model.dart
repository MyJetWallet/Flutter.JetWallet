import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'nft_market_preview_sell_response_model.freezed.dart';
part 'nft_market_preview_sell_response_model.g.dart';

@freezed
class NftMarketPreviewSellResponseModel
    with _$NftMarketPreviewSellResponseModel {
  factory NftMarketPreviewSellResponseModel({
    required String symbol,
    @DecimalSerialiser() required Decimal sellPrice,
    @DecimalSerialiser() required Decimal feePercentage,
    @DecimalSerialiser() required Decimal receiveAmount,
    @DecimalSerialiser() required Decimal feeAmount,
  }) = _NftMarketPreviewSellResponseModel;

  factory NftMarketPreviewSellResponseModel.fromJson(
          Map<String, dynamic> json,) =>
      _$NftMarketPreviewSellResponseModelFromJson(json);
}
