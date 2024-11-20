import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_lable_crypto_card_request_model.freezed.dart';
part 'change_lable_crypto_card_request_model.g.dart';

@freezed
class ChangeLableCryptoCardRequestModel with _$ChangeLableCryptoCardRequestModel {
  const factory ChangeLableCryptoCardRequestModel({
    required String label,
  }) = _ChangeLableCryptoCardRequestModel;

  factory ChangeLableCryptoCardRequestModel.fromJson(Map<String, dynamic> json) => _$ChangeLableCryptoCardRequestModelFromJson(json);
}
