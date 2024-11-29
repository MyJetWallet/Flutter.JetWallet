import 'package:freezed_annotation/freezed_annotation.dart';

part 'preview_crypto_card_request_model.freezed.dart';
part 'preview_crypto_card_request_model.g.dart';

@freezed
class PreviewCryptoCardRequestModel with _$PreviewCryptoCardRequestModel {
  const factory PreviewCryptoCardRequestModel({
    required String fromAsset,
  }) = _PreviewCryptoCardRequestModel;

  factory PreviewCryptoCardRequestModel.fromJson(Map<String, dynamic> json) =>
      _$PreviewCryptoCardRequestModelFromJson(json);
}
