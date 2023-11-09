import 'package:freezed_annotation/freezed_annotation.dart';

part 'execute_crypto_sell_request_model.freezed.dart';
part 'execute_crypto_sell_request_model.g.dart';

@freezed
abstract class ExecuteCryptoSellRequestModel with _$ExecuteCryptoSellRequestModel {
  const factory ExecuteCryptoSellRequestModel({
    required String paymentId,
  }) = _ExecuteCryptoSellRequest;

  factory ExecuteCryptoSellRequestModel.fromJson(Map<String, dynamic> json) => _$ExecuteCryptoSellRequestModelFromJson(json);
}
