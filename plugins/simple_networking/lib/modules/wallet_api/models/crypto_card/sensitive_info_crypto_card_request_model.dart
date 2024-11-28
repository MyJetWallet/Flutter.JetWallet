import 'package:freezed_annotation/freezed_annotation.dart';

part 'sensitive_info_crypto_card_request_model.freezed.dart';
part 'sensitive_info_crypto_card_request_model.g.dart';

@freezed
class SensitiveInfoCryptoCardRequestModel with _$SensitiveInfoCryptoCardRequestModel {
  const factory SensitiveInfoCryptoCardRequestModel({
    required String cardId,
  }) = _SensitiveInfoCryptoCardRequestModel;

  factory SensitiveInfoCryptoCardRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SensitiveInfoCryptoCardRequestModelFromJson(json);
}
