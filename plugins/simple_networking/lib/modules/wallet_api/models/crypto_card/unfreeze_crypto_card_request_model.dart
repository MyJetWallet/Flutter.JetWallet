import 'package:freezed_annotation/freezed_annotation.dart';

part 'unfreeze_crypto_card_request_model.freezed.dart';
part 'unfreeze_crypto_card_request_model.g.dart';

@freezed
class UnfreezeCryptoCardRequestModel with _$UnfreezeCryptoCardRequestModel {
  const factory UnfreezeCryptoCardRequestModel({
    required String cardId,
  }) = _UnfreezeCryptoCardRequestModel;

  factory UnfreezeCryptoCardRequestModel.fromJson(Map<String, dynamic> json) =>
      _$UnfreezeCryptoCardRequestModelFromJson(json);
}
