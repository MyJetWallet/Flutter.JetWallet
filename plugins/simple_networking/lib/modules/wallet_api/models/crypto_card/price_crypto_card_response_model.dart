import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'price_crypto_card_response_model.freezed.dart';
part 'price_crypto_card_response_model.g.dart';

@freezed
class PriceCryptoCardResponseModel with _$PriceCryptoCardResponseModel {
  const factory PriceCryptoCardResponseModel({
    @DecimalSerialiser() required Decimal regularPrice,
    @DecimalSerialiser() required Decimal userPrice,
    @DecimalSerialiser() required Decimal userDiscount,
    required String assetSymbol,
  }) = _PriceCryptoCardResponseModel;

  factory PriceCryptoCardResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PriceCryptoCardResponseModelFromJson(json);
}
