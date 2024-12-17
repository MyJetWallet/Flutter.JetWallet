import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_crypto_card_responce_model.freezed.dart';
part 'create_crypto_card_responce_model.g.dart';

@freezed
class CreateCryptoCardResponceModel with _$CreateCryptoCardResponceModel {
  const factory CreateCryptoCardResponceModel({
    required String cardId,
  }) = _CreateCryptoCardResponceModel;

  factory CreateCryptoCardResponceModel.fromJson(Map<String, dynamic> json) =>
      _$CreateCryptoCardResponceModelFromJson(json);
}
