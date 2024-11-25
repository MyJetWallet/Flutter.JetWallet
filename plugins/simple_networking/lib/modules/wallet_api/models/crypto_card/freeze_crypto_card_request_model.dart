import 'package:freezed_annotation/freezed_annotation.dart';

part 'freeze_crypto_card_request_model.freezed.dart';
part 'freeze_crypto_card_request_model.g.dart';

@freezed
class FreezeCryptoCardRequestModel with _$FreezeCryptoCardRequestModel {
  const factory FreezeCryptoCardRequestModel({
    required String cardId,
  }) = _FreezeCryptoCardRequestModel;

  factory FreezeCryptoCardRequestModel.fromJson(Map<String, dynamic> json) =>
      _$FreezeCryptoCardRequestModelFromJson(json);
}
