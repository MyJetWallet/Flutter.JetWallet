import 'package:freezed_annotation/freezed_annotation.dart';

part 'otp_used_crypto_card_request_model.freezed.dart';
part 'otp_used_crypto_card_request_model.g.dart';

@freezed
class OtpUsedCryptoCardRequestModel with _$OtpUsedCryptoCardRequestModel {
  const factory OtpUsedCryptoCardRequestModel({
    required String otpId,
  }) = _OtpUsedCryptoCardRequestModel;

  factory OtpUsedCryptoCardRequestModel.fromJson(Map<String, dynamic> json) =>
      _$OtpUsedCryptoCardRequestModelFromJson(json);
}
