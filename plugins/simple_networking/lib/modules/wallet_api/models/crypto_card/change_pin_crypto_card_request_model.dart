import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_pin_crypto_card_request_model.freezed.dart';
part 'change_pin_crypto_card_request_model.g.dart';

@freezed
class ChangePinCryptoCardRequestModel with _$ChangePinCryptoCardRequestModel {
  const factory ChangePinCryptoCardRequestModel({
    required String cardId,
    required String pin,
  }) = _ChangePinCryptoCardRequestModel;

  factory ChangePinCryptoCardRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ChangePinCryptoCardRequestModelFromJson(json);
}
