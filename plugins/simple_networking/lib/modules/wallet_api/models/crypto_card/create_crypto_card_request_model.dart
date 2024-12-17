import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'create_crypto_card_request_model.freezed.dart';
part 'create_crypto_card_request_model.g.dart';

@freezed
class CreateCryptoCardRequestModel with _$CreateCryptoCardRequestModel {
  const factory CreateCryptoCardRequestModel({
    required String fromAsset,
    @DecimalSerialiser() required Decimal fromAssetVolume,
  }) = _CreateCryptoCardRequestModel;

  factory CreateCryptoCardRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CreateCryptoCardRequestModelFromJson(json);
}
