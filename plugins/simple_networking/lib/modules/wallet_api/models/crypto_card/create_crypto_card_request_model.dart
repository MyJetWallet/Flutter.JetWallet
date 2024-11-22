import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_crypto_card_request_model.freezed.dart';
part 'create_crypto_card_request_model.g.dart';

@freezed
class CreateCryptoCardRequestModel with _$CreateCryptoCardRequestModel {
  const factory CreateCryptoCardRequestModel({
    String? label,
  }) = _CreateCryptoCardRequestModel;

  factory CreateCryptoCardRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CreateCryptoCardRequestModelFromJson(json);
}
