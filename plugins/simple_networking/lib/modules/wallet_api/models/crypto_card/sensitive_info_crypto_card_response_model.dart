import 'package:freezed_annotation/freezed_annotation.dart';

part 'sensitive_info_crypto_card_response_model.freezed.dart';
part 'sensitive_info_crypto_card_response_model.g.dart';

@freezed
class SensitiveInfoCryptoCardResponseModel with _$SensitiveInfoCryptoCardResponseModel {
  const factory SensitiveInfoCryptoCardResponseModel({
    required String cvv,
    required String expDate,
    required String cardNumber,
  }) = _SensitiveInfoCryptoCardResponseModel;

  factory SensitiveInfoCryptoCardResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SensitiveInfoCryptoCardResponseModelFromJson(json);
}
