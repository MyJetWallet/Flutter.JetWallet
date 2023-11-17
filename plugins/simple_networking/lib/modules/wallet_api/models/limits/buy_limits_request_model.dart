import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/modules/wallet_api/models/card_buy_create/card_buy_create_request_model.dart';

part 'buy_limits_request_model.freezed.dart';
part 'buy_limits_request_model.g.dart';

@freezed
class BuyLimitsRequestModel with _$BuyLimitsRequestModel {
  const factory BuyLimitsRequestModel({
    @Default('EUR') String paymentAsset,
    required String buyAsset,
    required CirclePaymentMethod paymentMethod,
  }) = _BuyLimitsRequestModel;

  factory BuyLimitsRequestModel.fromJson(Map<String, dynamic> json) =>
      _$BuyLimitsRequestModelFromJson(json);
}
