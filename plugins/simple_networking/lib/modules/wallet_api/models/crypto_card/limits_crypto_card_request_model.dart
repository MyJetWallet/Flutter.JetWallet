import 'package:freezed_annotation/freezed_annotation.dart';

part 'limits_crypto_card_request_model.freezed.dart';
part 'limits_crypto_card_request_model.g.dart';

@freezed
class LimitsCryptoCardRequestModel with _$LimitsCryptoCardRequestModel {
  const factory LimitsCryptoCardRequestModel({
    required String cardId,
  }) = _LimitsCryptoCardRequestModel;

  factory LimitsCryptoCardRequestModel.fromJson(Map<String, dynamic> json) =>
      _$LimitsCryptoCardRequestModelFromJson(json);
}
